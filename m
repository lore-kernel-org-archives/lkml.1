Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbYEPUTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbYEPUTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbYEPUS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:18:57 -0400
Received: from [158.64.110.160] ([158.64.110.160]:46767 "EHLO
	bonbons.gotdns.org" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754305AbYEPUSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:18:55 -0400
From: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH] Input: i8042 - add Dritek quirk for Acer TravelMate 660
Date: Fri, 16 May 2008 22:08:32 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805162208.33370.bonbons@linux-vserver.org>
X-VirusProbe: ClamAV, untested
X-SpamProbe: GOOD 0.0001426 5e13a41f180e93ba1d6e9866111de053
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Acer TravelMate 660 series also requires the Dritek quirk to enable the
extra scancodes.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
CC: Dmitry Torokhov <dtor@mail.ru>

diff -NurpP linux-2.6.25.4-orig/drivers/input/serio/i8042-x86ia64io.h linux-2.6.25.4/drivers/input/serio/i8042-x86ia64io.h
--- linux-2.6.25.4-orig/drivers/input/serio/i8042-x86ia64io.h	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25.4/drivers/input/serio/i8042-x86ia64io.h	2008-05-16 19:20:30.000000000 +0200
@@ -331,6 +331,13 @@ static struct dmi_system_id __initdata i
 		},
 	},
 	{
+		.ident = "Acer TravelMate 660",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 660"),
+		},
+	},
+	{
 		.ident = "Acer TravelMate 2490",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),

