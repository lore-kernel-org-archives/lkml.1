Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYLCUj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYLCUj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbYLCUbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:31:14 -0500
Received: from the.earth.li ([217.147.81.2]:47898 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637AbYLCUbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:31:13 -0500
Date: Wed, 3 Dec 2008 20:31:11 +0000
From: Jonathan McDowell <noodles@earth.li>
To: corentincj@iksaif.net, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH] Add EEE Bluetooth ACPI details
Message-ID: <20081203203111.GA28234@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although rfkill support for the EEE bluetooth device has been added to
2.6.28-rc the appropriate ACPI accessor definitions were not added, so
the support was non functional. The patch below adds the get and set
accessors and has been verified to work on an EEE 901.

Signed-off-by: Jonathan McDowell <noodles@earth.li>

-----
diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c
index 02fe2b8..9d93cb9 100644
--- a/drivers/misc/eeepc-laptop.c
+++ b/drivers/misc/eeepc-laptop.c
@@ -90,7 +90,7 @@ enum {
 };
 
 static const char *cm_getv[] = {
-	"WLDG", NULL, NULL, NULL,
+	"WLDG", "BTHG", NULL, NULL,
 	"CAMG", NULL, NULL, NULL,
 	NULL, "PBLG", NULL, NULL,
 	"CFVG", NULL, NULL, NULL,
@@ -99,7 +99,7 @@ static const char *cm_getv[] = {
 };
 
 static const char *cm_setv[] = {
-	"WLDS", NULL, NULL, NULL,
+	"WLDS", "BTHS", NULL, NULL,
 	"CAMS", NULL, NULL, NULL,
 	"SDSP", "PBLS", "HDPS", NULL,
 	"CFVS", NULL, NULL, NULL,
-----

J.

-- 
/-\                             |  umop 3pisdn w,I u3ym hx3s os w,I
|@/  Debian GNU/Linux Developer |
\-                              |
