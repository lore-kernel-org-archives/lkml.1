Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbXIYLoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbXIYLoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbXIYLoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:44:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34027 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXIYLoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:44:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Damien Wyart <damien.wyart@free.fr>
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
Date: Tue, 25 Sep 2007 13:45:10 +0200
User-Agent: KMail/1.9.5
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, linux-acpi@vger.kernel.org
References: <20070925065109.GA3080@localhost.localdomain> <20070925092755.GA4553@localhost.localdomain> <20070925095855.GA4982@localhost.localdomain>
In-Reply-To: <20070925095855.GA4982@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251345.11370.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 September 2007 11:58, Damien Wyart wrote:
> > > No, I do not have CONFIG_ACPI_SLEEP set,
> > > because I do not have CONFIG_PM_SLEEP set,
> > > because I do not want SUSPEND and/or HIBERNATION.
> 
> > Same answer from my side: I do not have CONFIG_ACPI_SLEEP for the same
> > reason (and this worked fine without them in rc7). I do not think
> > these settings should have changed between rc7 and rc8.

Well, we haven't changed much.

> Also, another test I just did: on another computer, rc8 is fine
> regarding ACPI power off, even if CONFIG_ACPI_SLEEP is not set. I can
> provide config if needed.

On the box that fails to power off, can you please test -rc8 with these two
commits reverted:

commit 5a50fe709d527f31169263e36601dd83446d5744
ACPI: suspend: consolidate handling of Sx states addendum

commit f216cc3748a3a22c2b99390fddcdafa0583791a2
ACPI: suspend: consolidate handling of Sx states.

and see if it works?

Greetings,
Rafael
