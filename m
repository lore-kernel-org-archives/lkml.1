Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbYC0XJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbYC0XJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 19:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYC0XIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 19:08:54 -0400
Received: from testure.choralone.org ([194.9.77.134]:34992 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYC0XIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 19:08:53 -0400
Date: Thu, 27 Mar 2008 19:08:46 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>, mchehab@infradead.org
Subject: Re: v4l oops in 2.6.25-rc7
Message-ID: <20080327230846.GB28795@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>, mchehab@infradead.org
References: <20080327230430.GA28795@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327230430.GA28795@codemonkey.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 07:04:30PM -0400, Dave Jones wrote:
 > Booted up with an ancient bt848 card present and got this..

actually that card was slightly newer than I thought, it's an 878.
>From earlier in the boot process..

bttv: Bt8xx card found (0).
ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 23 (level, low) -> IRQ 23
bttv0: Bt878 (rev 17) at 0000:02:0b.0, irq: 23, latency: 32, mmio: 0xf47fe000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 0-0050: Hauppauge model 44354, rev B121, serial# 2106674
tveeprom 0-0050: tuner model is Philips FM1216 (idx 21, type 5)
tveeprom 0-0050: TV standards PAL(B/G) (eeprom 0x04)
tveeprom 0-0050: audio processor is MSP3415 (idx 6)
tveeprom 0-0050: has radio
bttv0: Hauppauge eeprom indicates model#44354
bttv0: tuner type=5
bttv0: i2c: checking for MSP34xx @ 0x80... found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 .. ok
ACPI: PCI Interrupt 0000:02:0d.0[A] -> GSI 21 (level, low) -> IRQ 21

	Dave

-- 
http://www.codemonkey.org.uk
