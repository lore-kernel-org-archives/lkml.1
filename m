Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbZFLWjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbZFLWjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZFLWji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:39:38 -0400
Received: from tichy.grunau.be ([85.131.189.73]:38914 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZFLWjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:39:37 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jun 2009 18:39:37 EDT
Date: Sat, 13 Jun 2009 00:33:09 +0200
From: Janne Grunau <j@jannau.net>
To: acpi4asus-user@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 1/2] eeepc-laptop: add 3G and Wimax CM_ASL values and acpi
	method names
Message-ID: <20090612223309.GE14878@aniel.lan>
References: <cover.1244845758.git.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1244845758.git.j@jannau.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asus_acpi module as found in the eeepc 901go redefines the control
methods bits. Bits indicating 3G modem and wimax are added between
CM_ASL_CARDREADER and CM_ASL_LID. As CM_ASL_LID was unused this does
not changes behaviour for older models.

Signed-off-by: Janne Grunau <j@jannau.net>
---
 drivers/platform/x86/eeepc-laptop.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 2c58641..8d1ecc0 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -85,6 +85,8 @@ enum {
 	CM_ASL_USBPORT3,
 	CM_ASL_MODEM,
 	CM_ASL_CARDREADER,
+	CM_ASL_3G,
+	CM_ASL_WIMAX,
 	CM_ASL_LID
 };
 
@@ -94,7 +96,7 @@ static const char *cm_getv[] = {
 	NULL, "PBLG", NULL, NULL,
 	"CFVG", NULL, NULL, NULL,
 	"USBG", NULL, NULL, "MODG",
-	"CRDG", "LIDG"
+	"CRDG", "M3GG", "WIMG", "LIDG"
 };
 
 static const char *cm_setv[] = {
@@ -103,7 +105,7 @@ static const char *cm_setv[] = {
 	"SDSP", "PBLS", "HDPS", NULL,
 	"CFVS", NULL, NULL, NULL,
 	"USBG", NULL, NULL, "MODS",
-	"CRDS", NULL
+	"CRDS", "M3GS", "WIMS", NULL
 };
 
 #define EEEPC_EC	"\\_SB.PCI0.SBRG.EC0."
-- 
1.6.0.4

