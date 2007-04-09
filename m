Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbXDIVqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbXDIVqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXDIVqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:46:12 -0400
Received: from nlpi012.sbcis.sbc.com ([207.115.36.41]:26508 "EHLO
	nlpi012.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbXDIVpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:45:39 -0400
X-ORBL: [67.117.73.34]
Date: Mon, 9 Apr 2007 17:45:09 -0400
From: Tony Lindgren <tony@atomide.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/90] Post 2.6.21 OMAP update
Message-ID: <20070409214507.GH7818@atomide.com>
References: <11757088774110-git-send-email-tony@atomide.com> <20070404182728.GK29129@atomide.com> <20070404113925.da221efc.randy.dunlap@oracle.com> <20070404184455.GL29129@atomide.com> <20070404224448.0ff60ed2@the-village.bc.nu> <20070405132144.GC24297@atomide.com> <adar6qybx4y.fsf@cisco.com> <20070405180334.GW24297@atomide.com> <adaslbe8ykc.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaslbe8ykc.fsf@cisco.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland Dreier <rdreier@cisco.com> [070405 14:29]:
>  > Hmm, yeah I'll see if I could group them a bit. The problem there
>  > is that the patch series contains multiple rounds of "add and fix"
>  > cycles. Pretty much all the non-dependant fixes have already been
>  > applied, BTW.
> 
> I think it's nice to roll up fixes into patches that haven't been
> merged upstream yet.  For example I try to avoid merging series like
> 
>   Add feature A
>   Add feature B
>   Fix 1 for feature A
>   Fix 2 for feature A
>   Fix for fix 1 for feature A
> 
> because that means I already knew the first patch was broken before it
> ever got merged.  And it's better to avoid setting any more booby
> traps for people trying to use git bisect or something like
> that... enough bugs get merged by accident without us merging known
> bugs.  So before I merge, I go back and create a new series like
> 
>   Add fixed feature A
>   Add feature B

OK, done and reposted. Your suggestion got the following fixes merged
into other patches:

0022-ARM-OMAP-Fix-Amstrad-Delta-omap-keypad-usage.txt
0023-ARM-OMAP-PalmZ71-extra-brace-fix.txt
0024-ARM-OMAP-Fix-typo-in-gpio.txt
0030-ARM-OMAP-Palm-Zire71-minor-fixes.txt
0033-ARM-OMAP-This-patch-enables-I2C-2-support-for-2430-SDP.txt
0034-ARM-OMAP-Set-keypad-sense-delays-for-the-Palms.txt
0048-ARM-OMAP-I2C-1-init-fix-for-2430.txt
0049-ARM-OMAP-update-board-2430-file-for-TWL-PIH-interrupts.txt
0050-ARM-OMAP-board-sdp2430.c-Remove-unnecessary-includes.txt
0056-ARM-OMAP-Make-board-palmz71-compile-again.txt
0058-ARM-OMAP-musb_hdrc-tusb-dma-patch-minor.txt
0064-ARM-OMAP-Fix-warning-in-pm.c.txt
0065-ARM-OMAP-Convert-interrupt-flags-SA_-to-IRQF_.txt
0073-ARM-OMAP-Add-onennand-board-specific-support-for-N800.txt
0074-ARM-OMAP-N800-Update-board-specific-audio-support.txt
0079-ARM-OMAP-fix-H4-dependencies-again.txt
0081-ARM-OMAP-omap2-pm.c-build-fix.txt
0084-ARM-OMAP-Update-changed-TSC2301-config-names-in-N800-board-files.txt
0089-ARM-OMAP-Activate-MPU-retention-code-in-omap2-pm.c.txt

I also split 0040-ARM-OMAP-Sync-board-specific-files-with-linux-omap.txt
into two patches, one for OMAP1 and one for OMAP2.

So now there are somewhat smaller mountain of patches :)

Regards,

Tony

