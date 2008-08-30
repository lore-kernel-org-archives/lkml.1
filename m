Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYH3DCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYH3DCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 23:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbYH3DCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 23:02:07 -0400
Received: from main.gmane.org ([80.91.229.2]:39978 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbYH3DCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 23:02:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Out of mtrrs
Date: Fri, 29 Aug 2008 23:16:00 -0400
Message-ID: <g9ad75$o1k$1@ger.gmane.org>
References: <BEE3259F-0ED8-4030-9CA5-D8892C9096C2@ono.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-71-245-142-197.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <BEE3259F-0ED8-4030-9CA5-D8892C9096C2@ono.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> Hi all...
> 
> I'm using the xorg intel driver, and drm/X report it has no free mtrrs
> in kernel to set up:
> 
> one:~# cat /proc/mtrr
> reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
> reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
> reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
> reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
> reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
> reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
> reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
> reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1
> 
> dmesg:
> 
> [drm] Initialized i915 1.6.0 20060119 on minor 0
> mtrr: no more MTRRs available
> 
> one:/var/log# grep Linear x.log
> (--) intel(0): Linear framebuffer at 0x20000000
> 
> I think X tries to get a mtrr at 0x20000000, but kernel has no free one
> to offer.
> 
> Does this have any solution ?

I don't, but there have been a LOT of mtrr issues recently. I see that 
there were patches to -rc5 in that area. Many of my systems have RAM 
they can't use, even in 32bit PAE mode, and I just have the feeling that 
there is room for improvement here. For various reasons I would rather 
run 32 bit on some machines, and to have 3.2GB RAM used in a 8 or 16GB 
machine seems undesirable at the least, and with PAE and at least three 
unused mtrr I assume that the problem is soluable, just not today. :-(

I will try a 2.6.27-rc5 build late next week, I have another box to build.
> 
> TIA
> 
> (Oh, this is 2.6.26.3, intel driver 2.4.2)
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 
> 943/940GML Express Integrated Graphics Controller (rev 03)
> 
> -- 
> J.A. Magallon <jamagallon()ono!com>     \               Software is like 
> sex:
>                                          \         It's better when it's 
> free
> Mandriva Linux release 2009.0 (Cooker) for i586
> Linux 2.6.25-jam13 (gcc 4.3.1 20080515 (GCC) #1 SMP
> 
> 
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

