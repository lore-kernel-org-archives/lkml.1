Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbXIYMCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbXIYMCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXIYMCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:02:07 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:1163 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752092AbXIYMCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:02:06 -0400
Date: Tue, 25 Sep 2007 14:02:02 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
Message-ID: <20070925120202.GA5641@localhost.localdomain>
References: <20070925065109.GA3080@localhost.localdomain> <20070925092755.GA4553@localhost.localdomain> <20070925095855.GA4982@localhost.localdomain> <200709251345.11370.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709251345.11370.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On the box that fails to power off, can you please test -rc8 with these two
> commits reverted:

> commit 5a50fe709d527f31169263e36601dd83446d5744
> ACPI: suspend: consolidate handling of Sx states addendum

> commit f216cc3748a3a22c2b99390fddcdafa0583791a2
> ACPI: suspend: consolidate handling of Sx states.

> and see if it works?

I had done these tests in the first place (see my first mail), so yes,
reverting makes the box power off fine.

Will test this evening the patch you pointed in your next message.

-- 
Damien Wyart
