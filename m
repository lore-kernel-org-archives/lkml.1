Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426Ab0AKIHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab0AKIHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346Ab0AKIG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:06:59 -0500
Received: from h3281.serverkompetenz.net ([81.169.158.52]:52842 "EHLO
	h3281.serverkompetenz.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0AKIG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:06:58 -0500
Message-ID: <4B4ADC14.3060006@hillier.de>
Date: Mon, 11 Jan 2010 09:06:44 +0100
From: Gernot Hillier <gernot@hillier.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Matthias Urlichs <smurf@smurf.noris.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] option.c: Add chipset information for 4G W14
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gernot Hillier <gernot@hillier.de>

Carsten Juttner thankfully investigated a bit and found out some details 
about the chipset used in the 4G W14 device I recently added to option.c.

I think this information is useful for reference, so I'd be happy if you 
could include those bits.

Signed-off-by: Gernot Hillier <gernot@hillier.de>

Index: linux-2.6/drivers/usb/serial/option.c
===================================================================
--- linux-2.6.orig/drivers/usb/serial/option.c	2010-01-11 08:50:02.000000000 +0100
+++ linux-2.6/drivers/usb/serial/option.c	2010-01-11 08:52:55.000000000 +0100
@@ -338,6 +338,8 @@
 
 /* 4G Systems products */
 #define FOUR_G_SYSTEMS_VENDOR_ID		0x1c9e
+/* This is the 4G XS Stick W14 a.k.a. Mobilcom Debitel Surf-Stick *
+ * It seems to contain a Qualcomm QSC6240/6290 chipset            */
 #define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
 
 /* Haier products */
