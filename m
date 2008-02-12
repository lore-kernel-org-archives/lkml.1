Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbYBLCCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbYBLCCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 21:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYBLCCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 21:02:43 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:46797 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYBLCCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 21:02:42 -0500
Message-ID: <47B0FE41.7090804@tlinx.org>
Date: Mon, 11 Feb 2008 18:02:41 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: graphics probing messages: questions
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this should go to a more specific list, but I had
a question about a dmesg v. Kconfig item.

One option under graphics asks about enabling firmware EDID
and says should be safe.  So it's 'yes'

Further down under nVidia FB Support, there is an option
"Enable DDC Support" which tries to use i2c for getting
EDID info and I should say 'Y'.

With those on, in dmesg, I get:
i2c-adapter i2c-0: unable to read EDID block.
i2c-adapter i2c-0: unable to read EDID block.
i2c-adapter i2c-0: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
Followed by:
nvidiafb: CRTC 0 appears to have a CRT attached
nvidiafb: Using CRT on CRTC 0
mtrr: base(0xd0000000) is not aligned on a size(0x20000000) boundary
nvidiafb: unable to setup MTRR
Console: switching to colour frame buffer device 80x30
nvidiafb: PCI nVidia NV9 framebuffer (64MB @ 0xD0000000)
vesafb: cannot reserve video memory at 0xd0000000
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20015200000, using 
3072k, total 262144k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
fb1: VESA VGA frame buffer device
----
    So this means turning "DCC Support" is useless on this machine?
    Also, why can't the graphics drivers use a base that is
not aligned on a 0x20000000 boundary?  Is this a machine design flaw,
or some limitation in the software?

Thanks muchly,
Linda

