Return-Path: <linux-kernel-owner+w=401wt.eu-S936315AbXJTCzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936315AbXJTCzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbXJTCzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:55:41 -0400
Received: from xenotime.net ([66.160.160.81]:60298 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751642AbXJTCzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:55:41 -0400
Date: Fri, 19 Oct 2007 19:55:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Subject: Re: 2.6.23-git Kconfig regression
Message-Id: <20071019195535.0dbafd39.rdunlap@xenotime.net>
In-Reply-To: <47196165.8070406@oracle.com>
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20071019184607.06e1eef9.randy.dunlap@oracle.com>
	<20071020015735.270C923A748@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<47196165.8070406@oracle.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 19:01:09 -0700 Randy Dunlap wrote:

> >>> I noticed a regression, visible in the drivers/usb/gadget Kconfig;
> >>> it seems to be quite recent.
> >>>
> >>> ...
> >> Hm, it does look very odd.  It looks like it has something to
> >> do with <choice> working differently for some reason.
> >>
> >> In xconfig, I set all of the View Options and when I click on one
> >> of the periph. controllers, it says
> >>
> >> 	depends on =y && PCI
> > 
> > That's what I saw too.  Looked dubious ... 
> > 
> > 
> >> but if I back up to -git7, it says
> >>
> >> 	depends on <choice> && PCI
> > 
> > And that git7 thing doesn't look _quite_ so odd.  Did git7 actually
> > let you configure a modular GOKU (for example), i.e. work correctly?
> 
> Yes, -git9 does.
> 
> Looks to me like it broke on -git10.  -git9 is OK.
> 
> >> I'll keep looking.
> > 
> > Thanks.  Kconfig is one of the areas I prefer to let others
> > be the experts.  :)

[hm, odd email problems, changing SMTP]

David,

Just a small update.

If I set USB gadget support to Y instead of M and peripheral
controller menu item to Y instead of M, then I can select any of the
4 periph. controllers that are available to me.  (on -git14)
I don't know why it's like this though.

---
~Randy
