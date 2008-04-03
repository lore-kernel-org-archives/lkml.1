Return-Path: <linux-kernel-owner+w=401wt.eu-S1762130AbYDUN3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762130AbYDUN3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbYDUNTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:9129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760185AbYDUNT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=tFFfrC7PCreaBuNSsvzJ7mDqCPQm8xzm9dIosF1r+GC+8GI0RKYjAc6OxcYf1moYg9ajleaTFekq/hyznpDPexE/hYU+wAZ4hA9wMmEqp4PuFGZ4GBn0x/r7TLSpo0uvy+OUPIwlZuKZFyqFPexNDT3ww99KZv5CkPnJRGpAtE4=
Message-Id: <8a7ae2a890852b133342a6d72f84b0dac1bc8e8e.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 3 Apr 2008 16:18:35 -0400
Subject: [PATCH 14/37] Input: xpad - add more xbox 360 controller ids
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Anssi Hannula <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Mad Catz and 0x0e6f xbox360 controllers which are already found
in xpad_device[] table in xpad.c into the vendor id list. Also add
Logitech into the vendor list for Logitech Chillstream gamepads.
Also add the RedOctane Guitar Hero X-plorer.

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 316d987..8952495 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -110,6 +110,7 @@ static const struct xpad_device {
 	{ 0x045e, 0x0287, "Microsoft Xbox Controller S", MAP_DPAD_TO_AXES, XTYPE_XBOX },
 	{ 0x0c12, 0x8809, "RedOctane Xbox Dance Pad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
+	{ 0x046d, 0xc242, "Logitech Chillstream Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
 	{ 0x046d, 0xca84, "Logitech Xbox Cordless Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
 	{ 0x046d, 0xca88, "Logitech Compact Controller for Xbox", MAP_DPAD_TO_AXES, XTYPE_XBOX },
 	{ 0x05fd, 0x1007, "Mad Catz Controller (unverified)", MAP_DPAD_TO_AXES, XTYPE_XBOX },
@@ -136,6 +137,7 @@ static const struct xpad_device {
 	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
 	{ 0x102c, 0xff0c, "Joytech Wireless Advanced Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
 	{ 0x12ab, 0x8809, "Xbox DDR dancepad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
+	{ 0x1430, 0x4748, "RedOctane Guitar Hero X-plorer", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
 	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", MAP_DPAD_TO_AXES, XTYPE_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", MAP_DPAD_TO_AXES, XTYPE_XBOX },
@@ -188,6 +190,10 @@ static const signed short xpad_abs_pad[] = {
 static struct usb_device_id xpad_table [] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
 	{ XPAD_XBOX360_VENDOR(0x045e) },	/* Microsoft X-Box 360 controllers */
+	{ XPAD_XBOX360_VENDOR(0x046d) },	/* Logitech X-Box 360 style controllers */
+	{ XPAD_XBOX360_VENDOR(0x0738) },	/* Mad Catz X-Box 360 controllers */
+	{ XPAD_XBOX360_VENDOR(0x0e6f) },	/* 0x0e6f X-Box 360 controllers */
+	{ XPAD_XBOX360_VENDOR(0x1430) },	/* RedOctane X-Box 360 controllers */
 	{ }
 };
 
-- 
1.5.5.rc2.6.gf58d


