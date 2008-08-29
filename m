Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbYH2PdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbYH2PdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbYH2Pcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:32:52 -0400
Received: from isuela.unizar.es ([155.210.1.53]:36299 "EHLO isuela.unizar.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYH2Pcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:32:51 -0400
Message-Id: <BEE3259F-0ED8-4030-9CA5-D8892C9096C2@ono.com>
From: "=?ISO-8859-1?Q?=22J.A._Magall=F3n=22?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Out of mtrrs
Date: Fri, 29 Aug 2008 17:32:49 +0200
X-Mailer: Apple Mail (2.926)
X-Mail-Scanned: Criba 2.0 + Clamd & Bogofilter
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I'm using the xorg intel driver, and drm/X report it has no free mtrrs
in kernel to set up:

one:~# cat /proc/mtrr
reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1

dmesg:

[drm] Initialized i915 1.6.0 20060119 on minor 0
mtrr: no more MTRRs available

one:/var/log# grep Linear x.log
(--) intel(0): Linear framebuffer at 0x20000000

I think X tries to get a mtrr at 0x20000000, but kernel has no free one
to offer.

Does this have any solution ?

TIA

(Oh, this is 2.6.26.3, intel driver 2.4.2)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,  
943/940GML Express Integrated Graphics Controller (rev 03)

--
J.A. Magallon <jamagallon()ono!com>     \               Software is  
like sex:
                                          \         It's better when  
it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam13 (gcc 4.3.1 20080515 (GCC) #1 SMP



