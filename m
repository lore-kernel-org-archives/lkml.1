Return-Path: <linux-kernel-owner+w=401wt.eu-S1752281AbXBXRXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbXBXRXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 12:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbXBXRXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 12:23:36 -0500
Received: from smtp3.nextra.sk ([195.168.1.142]:3948 "EHLO mailhub3.nextra.sk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752280AbXBXRXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 12:23:36 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Feb 2007 12:23:35 EST
From: Ondrej Zary <linux@rainbow-software.org>
To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Kernel warning from Matrox Framebuffer in 2.6.20.1
Date: Sat, 24 Feb 2007 18:18:24 +0100
User-Agent: KMail/1.9.4
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <306590.53720.qm@web52912.mail.yahoo.com>
In-Reply-To: <306590.53720.qm@web52912.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702241818.24675.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 February 2007 14:08, Chris Rankin wrote:
> Hi,
>
> I have just booted 2.6.20.1 on my Pentium 3 machine, which has a G400 MAX
> graphics card. This machine uses the Matrox framebuffer and TV-OUT modules,
> and I have found these warnings in the kernel log:
>
> **WARNING** I2C adapter driver [DDC:fb0 #0] forgot to specify physical
> device; fix it! **WARNING** I2C adapter driver [DDC:fb0 #1] forgot to
> specify physical device; fix it! **WARNING** I2C adapter driver [MAVEN:fb0]
> forgot to specify physical device; fix it!

I'm seeing something like that since installing 2.6.20.1 yesterday:

matroxfb: Matrox Mystique (PCI) detected
PInS memtype = 0
matroxfb: MTRR's turned on
matroxfb: 1024x768x8bpp (virtual: 1024x4096)
matroxfb: framebuffer at 0xE1000000, mapped to 0xcc880000, size 4194304
Console: switching to colour frame buffer device 128x48
fb0: MATROX frame buffer device
**WARNING** I2C adapter driver [DDC:fb0 #0] forgot to specify physical device; 
fix it!

> The relevant kernel modules seem to be:
>
> matroxfb_maven         13228  0
> i2c_matroxfb            4064  0
> i2c_algo_bit            6312  1 i2c_matroxfb
>
> Cheers,
> Chris

-- 
Ondrej Zary
