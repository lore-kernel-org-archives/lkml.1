Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYL1KgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYL1KgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 05:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYL1Kf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 05:35:57 -0500
Received: from gateway.crfreenet.org ([81.92.146.254]:55152 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbYL1Kf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 05:35:57 -0500
X-Greylist: delayed 1155 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Dec 2008 05:35:56 EST
Date: Sun, 28 Dec 2008 11:20:27 +0100
From: Ondrej Zajicek <santiago@crfreenet.org>
To: corentincj@iksaif.net, linux-kernel@vger.kernel.org
Cc: mjg@redhat.com, len.brown@intel.com
Subject: Patch enabling Bluetooth for Asus EEE 901
Message-ID: <20081228102026.GA18096@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eeepc-laptop driver has interface for enabling/disabling
Bluetooth, but it does not work. This patch fixes it.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>

diff -uprN -X linux-2.6.28-plain/Documentation/dontdiff linux-2.6.28-plain/drivers/misc/eeepc-laptop.c linux-2.6.28/drivers/misc/eeepc-laptop.c
--- linux-2.6.28-plain/drivers/misc/eeepc-laptop.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/drivers/misc/eeepc-laptop.c	2008-12-27 11:19:25.000000000 +0100
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


-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
