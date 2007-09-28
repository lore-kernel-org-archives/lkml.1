Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbXI1UbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbXI1UbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXI1UbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:31:15 -0400
Received: from ara.aytolacoruna.es ([212.51.63.12]:38445 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbXI1UbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:31:15 -0400
X-Greylist: delayed 1635 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 16:31:15 EDT
Date: Fri, 28 Sep 2007 22:03:52 +0200
From: Santiago Garcia Mantinan <manty@manty.net>
To: linux-kernel@vger.kernel.org
Subject: vga text console not working on 2.6.23-rc8
Message-ID: <20070928200352.GA2312@pul.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have just compiled a 2.6.23-rc8 using the config from my 2.6.22 as a basis
and I came out with a not working (almost black) vga text console.

This is what I'm getting on my logs:

Console: colour dummy device 80x25
console [tty0] enabled

Instead of the old:

Console: colour VGA+ 80x25

The options related to the console on my config are these:

CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_VGA_CONSOLE=y
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y

The machine is a AMD x64 X2 Athlon with a NForce 4 chipset, vga is a ATI
radeon and I have also set:

CONFIG_DRM=m
CONFIG_DRM_RADEON=m

I have tried with and without CONFIG_VIDEO_SELECT and
CONFIG_VIDEO_OUTPUT_CONTROL with the same results. BTW: when X starts the
display is Ok.

If you want me to do any tests or need more info just tell me.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
