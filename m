Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZAKSQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZAKSQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbZAKSQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:16:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:52039 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbZAKSQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:16:19 -0500
Date: Sun, 11 Jan 2009 18:16:11 +0000 (GMT)
From: Alexey Korolev <akorolev@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>, dwmw2@infradead.org
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: mtd/lpddr/qinfo_probe.c needs lpddr_cmds to be compiled
In-Reply-To: <496A23AC.1090909@oracle.com>
Message-ID: <alpine.LFD.2.00.0901111812490.12586@casper.infradead.org>
References: <20090110021641.GA26951@orion> <49682F42.8070304@oracle.com> <alpine.LFD.2.00.0901110958360.20119@casper.infradead.org> <496A23AC.1090909@oracle.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <akorolev@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,
Yes, it has alreay been merged today.

David,
Thank you very much!

> 
> MAINTAINERS file:
> 
> MEMORY TECHNOLOGY DEVICES (MTD)
> P:      David Woodhouse
> M:      dwmw2@infradead.org
> 
> > Thanks,
> > Alexey
> > 
> >>> drivers/built-in.o: In function `lpddr_probe':
> >>> drivers/mtd/lpddr/qinfo_probe.c:215:
> >>> undefined reference to `lpddr_cmdset'
> >>>
> >>> # CONFIG_MTD_LPDDR is not set
> >>> CONFIG_MTD_QINFO_PROBE=y
> >>> --
> >> This patch has been posted, just needs to be merged (hint):
> >> ---
> >>
> >>
> >> Signed-off-by: Alexey Korolev <akorolev@infradead.org>
> >> ---
> >> diff --git a/drivers/mtd/lpddr/Kconfig b/drivers/mtd/lpddr/Kconfig
> >> index acd4ea9..5a401d8 100644
> >> --- a/drivers/mtd/lpddr/Kconfig
> >> +++ b/drivers/mtd/lpddr/Kconfig
> >> @@ -12,6 +12,7 @@ config MTD_LPDDR
> >>  	  DDR memories, intended for battery-operated systems.
> >>  
> >>  config MTD_QINFO_PROBE
> >> +	depends on MTD_LPDDR
> >>  	tristate "Detect flash chips by QINFO probe"
> >>  	help
> >>  	    Device Information for LPDDR chips is offered through the Overlay
> >>
> >>
> 
> 
> -- 
> ~Randy
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 
