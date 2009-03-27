Return-Path: <linux-kernel-owner+w=401wt.eu-S1761490AbZC0Drp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761490AbZC0Drp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759521AbZC0Drc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:47:32 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:33984 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758601AbZC0Drb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:47:31 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: "Michael B. Trausch" <mike@trausch.us>
Subject: Re: 2.6.29 Networking Problems
Date: Thu, 26 Mar 2009 23:47:19 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.29; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090326232045.700a251a@zest.trausch.us>
In-reply-to: <20090326232045.700a251a@zest.trausch.us>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200903262347.19338.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 March 2009, Michael B. Trausch wrote:
>Alright, so I upgraded to 2.6.29 and had all sorts of issues with my
>networking (x86-64 system, both forcedeth and 3c59x NICs).  At first I
>thought my forcedeth NIC was dying or something, so I disabled it and
>installed a trusty 3com.  When it started acting up also, I began to
>suspect software, and some searching led me to the thread (and
>eventually the patch) at:
>
>  http://patchwork.kernel.org/patch/14465/
>
>So, I applied this patch to my local kernel, and my test (transferring
>13 GiB of data over the LAN) now can be run repeatedly.  Prior to
>applying the patch, I'd start the transfer and it'd go for about 20
>seconds and all transfer would stop, and ping would not return errors,
>just nothing.
>
>Any chance that this patch will land in 2.6.29.1?  Or other code that
>fixes the same problem?  I haven't tried it against Linus' kernel tree
>yet because I probably won't run that kernel again until at least -rc2
>or -rc3, so apologies if this issue is already fixed in the trunk.
>
>	--- Mike

I'll second this on 2.6.29.  Asus M2N SLI Deluxe mobo, quad core phenom, 4GB 
ram.

When I woke up this morning I had no network.  Ifconfig said it was up and ok, 
but I couldn't even ping my router.  So I went to another machine and the 
router etc was fine.  Restarting the networking did not help.  The leds on the 
mobo jacks were on so the MCP55's hadn't been killed.  A reboot that took a 
good piece of an hour cuz it had timed out on 1.5 TB of drives and had to fsck 
them, and its been fine since.

>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Windows without the X is like making love without a partner.
	-- MaDsen Wikholm, mwikholm@at8.abo.fi

