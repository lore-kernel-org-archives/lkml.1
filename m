Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbYFZUFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbYFZUFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYFZUE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:04:59 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:41685 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621AbYFZUE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:04:58 -0400
X-Authority-Analysis: v=1.0 c=1 a=vIJMcV4iED4A:10 a=wT66fwWsXUsA:10
 a=BGZmisL9TkpbHdiXfUxj7A==:17 a=FLhA3KDuAAAA:8 a=_-pQFLo-GXBqeTDp1jcA:9
 a=GdaQckKwNW3iO5Ix2bEA:7 a=MzEyJgpO71pTXjDpd8x4svRkOSgA:4 a=50e4U0PicR4A:10
From: kelk1@comcast.net (Quel Qun)
To: LKML <linux-kernel@vger.kernel.org>
Cc: Quel Qun <kelk1@comcast.net>
Subject: No console on Riva TNT since 2.6.26-0.rc4
Date: Thu, 26 Jun 2008 20:04:56 +0000
Message-Id: <062620082004.6012.4863F668000CEA0D0000177C2200751090CE05040A05@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2007)
X-Authenticated-Sender: a2VsazFAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The system boots fine with 2.6.26-0.rc3.1mnb (Mandriva Cooker), but since rc4, I see a few squares of color, then a black screen and the console never comes back. This is independent of the resolution chosen when using vga=ask. The machine does boot and I can start X if I log in blindly. Only the F1 to F6 consoles are gone.

Bug originally reported and ignored on Cooker: https://qa.mandriva.com/show_bug.cgi?id=41302

My card is an old STB NVidia Riva TNT, monitor is a flat panel Dell 2007FP, system is a Dell Dimension XPS T600 (82371AB/EB/MB PIIX4 with PIII 600).

I cannot see anything different in /var/log/messages between rc3 and rc4 (vga=837)

vesafb: framebuffer at 0xfc000000, mapped to 0xd8880000, using 7500k, total
16320k
vesafb: mode is 1600x1200x8, linelength=1600, pages=6
vesafb: protected mode interface info at c000:02d2
vesafb: pmi: set display start = c00c030b, set palette = c00c0381
vesafb: pmi: ports = 3b4 3b5 3ba 3c0 3c1 3c4 3c5 3c6 3c7 3c8 3c9 3cc 3ce 3cf
3d0 3d1 3d2 3d3 3d4 3d5 3da
vesafb: scrolling: redraw
vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
Console: switching to colour frame buffer device 200x75
fb0: VESA VGA frame buffer device

This is still true with a vanilla 2.6.26-rc8.

$ grep FB_RIVA /boot/config
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y

Please cc me if you need more info since I am not subscribed to the kernel list.
Thank you.
--
Eric
