Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbZISKnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbZISKnb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 06:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbZISKnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 06:43:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:50969 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757008AbZISKna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 06:43:30 -0400
X-Authenticated: #1593455
X-Provags-ID: V01U2FsdGVkX1/UEgZFw2bU9n62gn7dc4DCImcoc3eg6y+KHYN0oY
	mwAdnizGGPJtYW
From: Sebastian Frei <dr.nop@gmx.net>
To: mitr@volny.cz
Subject: [PATCH] wistron_btns.c: Add DMI entry for Medion WIM2030 laptop
Date: Sat, 19 Sep 2009 12:43:09 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31; KDE/4.3.1; i686; svn-1016677; 2009-08-27)
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-input@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909191243.09243.dr.nop@gmx.net>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a DMI entry for the Medion WIM2030 laptop.

Signed-off-by: Sebastian Frei <dr.nop@gmx.net>

--- linux-2.6.31.orig/drivers/input/misc/wistron_btns.c
+++ linux-2.6.31/drivers/input/misc/wistron_btns.c
@@ -669,6 +669,15 @@
        },
        {
                .callback = dmi_matched,
+               .ident = "Medion MD 42200",
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "Medion"),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "WIM 2030"),
+               },
+               .driver_data = keymap_fs_amilo_pro_v2000
+       },
+       {
+               .callback = dmi_matched,
                .ident = "Fujitsu N3510",
                .matches = {
                        DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
