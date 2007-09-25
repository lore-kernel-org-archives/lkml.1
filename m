Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbXIYJ2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbXIYJ2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXIYJ15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:27:57 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:2213 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751405AbXIYJ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:27:56 -0400
X-Greylist: delayed 9406 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2007 05:27:56 EDT
Date: Tue, 25 Sep 2007 11:27:55 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
Message-ID: <20070925092755.GA4553@localhost.localdomain>
References: <20070925065109.GA3080@localhost.localdomain> <20070925003340.5d6dd7f4.akpm@linux-foundation.org> <46F8C880.1010006@suse.de> <64bb37e0709250208gcbdeb6do6026e138e746bde2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0709250208gcbdeb6do6026e138e746bde2@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> On 9/25/07, Alexey Starikovskiy <astarikovskiy@suse.de> wrote:
> > Do you have CONFIG_ACPI_SLEEP enabled in your .config?

* Torsten Kaiser <just.for.lkml@googlemail.com> [2007-09-25 11:08]:
> I'm answering that too, because I suspect that my "2.6.23-rc7-mm1 does
> not power off"-error might have the same cause.

> No, I do not have CONFIG_ACPI_SLEEP set,
> because I do not have CONFIG_PM_SLEEP set,
> because I do not want SUSPEND and/or HIBERNATION.

Same answer from my side: I do not have CONFIG_ACPI_SLEEP for the same
reason (and this worked fine without them in rc7). I do not think these
settings should have changed between rc7 and rc8.

-- 
Damien Wyart
