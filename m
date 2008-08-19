Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYHSSho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYHSSho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbYHSShV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:37:21 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:24745 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbYHSShR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ac69+w4mM/Vy6B8lpdLy/7FtS5G+6wDlNgNjRC70n3uY98fGquEvdWzqJRMukvDzL9
         wDwNxJpVXLGh1EYf+AUlkJrPkoi87mNgDhZzK2Y0rFiGLwCn0wgUYA/JZMHbKWqNue9A
         BlUXVZ+kCeWNs+AfQo3a+EC8TFvaD9vm+yGoo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/5] ide: use unique names for struct pci_driver instances
Date: Tue, 19 Aug 2008 20:30:53 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+lkml@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192030.54287.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed-by: Russell King <rmk+lkml@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/aec62xx.c      |    6 +++---
 drivers/ide/pci/alim15x3.c     |    6 +++---
 drivers/ide/pci/amd74xx.c      |    6 +++---
 drivers/ide/pci/atiixp.c       |    6 +++---
 drivers/ide/pci/cmd64x.c       |    6 +++---
 drivers/ide/pci/cs5520.c       |    4 ++--
 drivers/ide/pci/cs5530.c       |    6 +++---
 drivers/ide/pci/cs5535.c       |    6 +++---
 drivers/ide/pci/cy82c693.c     |    6 +++---
 drivers/ide/pci/delkin_cb.c    |    6 +++---
 drivers/ide/pci/generic.c      |    6 +++---
 drivers/ide/pci/hpt34x.c       |    6 +++---
 drivers/ide/pci/hpt366.c       |    6 +++---
 drivers/ide/pci/it8213.c       |    6 +++---
 drivers/ide/pci/it821x.c       |    6 +++---
 drivers/ide/pci/jmicron.c      |    6 +++---
 drivers/ide/pci/ns87415.c      |    6 +++---
 drivers/ide/pci/opti621.c      |    6 +++---
 drivers/ide/pci/pdc202xx_new.c |    6 +++---
 drivers/ide/pci/pdc202xx_old.c |    6 +++---
 drivers/ide/pci/piix.c         |    6 +++---
 drivers/ide/pci/rz1000.c       |    6 +++---
 drivers/ide/pci/sc1200.c       |    6 +++---
 drivers/ide/pci/scc_pata.c     |    6 +++---
 drivers/ide/pci/serverworks.c  |    6 +++---
 drivers/ide/pci/siimage.c      |    6 +++---
 drivers/ide/pci/sis5513.c      |    6 +++---
 drivers/ide/pci/sl82c105.c     |    6 +++---
 drivers/ide/pci/slc90e66.c     |    6 +++---
 drivers/ide/pci/tc86c001.c     |    6 +++---
 drivers/ide/pci/triflex.c      |    6 +++---
 drivers/ide/pci/trm290.c       |    6 +++---
 drivers/ide/pci/via82cxxx.c    |    6 +++---
 33 files changed, 98 insertions(+), 98 deletions(-)

Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -302,7 +302,7 @@ static const struct pci_device_id aec62x
 };
 MODULE_DEVICE_TABLE(pci, aec62xx_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver aec62xx_pci_driver = {
 	.name		= "AEC62xx_IDE",
 	.id_table	= aec62xx_pci_tbl,
 	.probe		= aec62xx_init_one,
@@ -315,12 +315,12 @@ static struct pci_driver driver = {
 
 static int __init aec62xx_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&aec62xx_pci_driver);
 }
 
 static void __exit aec62xx_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&aec62xx_pci_driver);
 }
 
 module_init(aec62xx_ide_init);
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -575,7 +575,7 @@ static const struct pci_device_id alim15
 };
 MODULE_DEVICE_TABLE(pci, alim15x3_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver alim15x3_pci_driver = {
 	.name		= "ALI15x3_IDE",
 	.id_table	= alim15x3_pci_tbl,
 	.probe		= alim15x3_init_one,
@@ -588,12 +588,12 @@ static struct pci_driver driver = {
 
 static int __init ali15x3_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&alim15x3_pci_driver);
 }
 
 static void __exit ali15x3_ide_exit(void)
 {
-	return pci_unregister_driver(&driver);
+	return pci_unregister_driver(&alim15x3_pci_driver);
 }
 
 module_init(ali15x3_ide_init);
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -319,7 +319,7 @@ static const struct pci_device_id amd74x
 };
 MODULE_DEVICE_TABLE(pci, amd74xx_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver amd74xx_pci_driver = {
 	.name		= "AMD_IDE",
 	.id_table	= amd74xx_pci_tbl,
 	.probe		= amd74xx_probe,
@@ -332,12 +332,12 @@ static struct pci_driver driver = {
 
 static int __init amd74xx_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&amd74xx_pci_driver);
 }
 
 static void __exit amd74xx_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&amd74xx_pci_driver);
 }
 
 module_init(amd74xx_ide_init);
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -182,7 +182,7 @@ static const struct pci_device_id atiixp
 };
 MODULE_DEVICE_TABLE(pci, atiixp_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver atiixp_pci_driver = {
 	.name		= "ATIIXP_IDE",
 	.id_table	= atiixp_pci_tbl,
 	.probe		= atiixp_init_one,
@@ -195,12 +195,12 @@ static struct pci_driver driver = {
 
 static int __init atiixp_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&atiixp_pci_driver);
 }
 
 static void __exit atiixp_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&atiixp_pci_driver);
 }
 
 module_init(atiixp_ide_init);
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -505,7 +505,7 @@ static const struct pci_device_id cmd64x
 };
 MODULE_DEVICE_TABLE(pci, cmd64x_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver cmd64x_pci_driver = {
 	.name		= "CMD64x_IDE",
 	.id_table	= cmd64x_pci_tbl,
 	.probe		= cmd64x_init_one,
@@ -518,12 +518,12 @@ static struct pci_driver driver = {
 
 static int __init cmd64x_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&cmd64x_pci_driver);
 }
 
 static void __exit cmd64x_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&cmd64x_pci_driver);
 }
 
 module_init(cmd64x_ide_init);
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -145,7 +145,7 @@ static const struct pci_device_id cs5520
 };
 MODULE_DEVICE_TABLE(pci, cs5520_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver cs5520_pci_driver = {
 	.name		= "Cyrix_IDE",
 	.id_table	= cs5520_pci_tbl,
 	.probe		= cs5520_init_one,
@@ -157,7 +157,7 @@ static struct pci_driver driver = {
 
 static int __init cs5520_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&cs5520_pci_driver);
 }
 
 module_init(cs5520_ide_init);
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -267,7 +267,7 @@ static const struct pci_device_id cs5530
 };
 MODULE_DEVICE_TABLE(pci, cs5530_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver cs5530_pci_driver = {
 	.name		= "CS5530 IDE",
 	.id_table	= cs5530_pci_tbl,
 	.probe		= cs5530_init_one,
@@ -280,12 +280,12 @@ static struct pci_driver driver = {
 
 static int __init cs5530_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&cs5530_pci_driver);
 }
 
 static void __exit cs5530_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&cs5530_pci_driver);
 }
 
 module_init(cs5530_ide_init);
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -192,7 +192,7 @@ static const struct pci_device_id cs5535
 
 MODULE_DEVICE_TABLE(pci, cs5535_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver cs5535_pci_driver = {
 	.name		= "CS5535_IDE",
 	.id_table	= cs5535_pci_tbl,
 	.probe		= cs5535_init_one,
@@ -205,12 +205,12 @@ static struct pci_driver driver = {
 
 static int __init cs5535_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&cs5535_pci_driver);
 }
 
 static void __exit cs5535_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&cs5535_pci_driver);
 }
 
 module_init(cs5535_ide_init);
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -331,7 +331,7 @@ static const struct pci_device_id cy82c6
 };
 MODULE_DEVICE_TABLE(pci, cy82c693_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver cy82c693_pci_driver = {
 	.name		= "Cypress_IDE",
 	.id_table	= cy82c693_pci_tbl,
 	.probe		= cy82c693_init_one,
@@ -344,12 +344,12 @@ static struct pci_driver driver = {
 
 static int __init cy82c693_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&cy82c693_pci_driver);
 }
 
 static void __exit cy82c693_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&cy82c693_pci_driver);
 }
 
 module_init(cy82c693_ide_init);
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -117,7 +117,7 @@ static struct pci_device_id delkin_cb_pc
 };
 MODULE_DEVICE_TABLE(pci, delkin_cb_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver delkin_cb_pci_driver = {
 	.name		= "Delkin-ASKA-Workbit Cardbus IDE",
 	.id_table	= delkin_cb_pci_tbl,
 	.probe		= delkin_cb_probe,
@@ -126,12 +126,12 @@ static struct pci_driver driver = {
 
 static int __init delkin_cb_init(void)
 {
-	return pci_register_driver(&driver);
+	return pci_register_driver(&delkin_cb_pci_driver);
 }
 
 static void __exit delkin_cb_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&delkin_cb_pci_driver);
 }
 
 module_init(delkin_cb_init);
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -166,7 +166,7 @@ static const struct pci_device_id generi
 };
 MODULE_DEVICE_TABLE(pci, generic_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver generic_pci_driver = {
 	.name		= "PCI_IDE",
 	.id_table	= generic_pci_tbl,
 	.probe		= generic_init_one,
@@ -179,12 +179,12 @@ static struct pci_driver driver = {
 
 static int __init generic_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&generic_pci_driver);
 }
 
 static void __exit generic_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&generic_pci_driver);
 }
 
 module_init(generic_ide_init);
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -166,7 +166,7 @@ static const struct pci_device_id hpt34x
 };
 MODULE_DEVICE_TABLE(pci, hpt34x_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver hpt34x_pci_driver = {
 	.name		= "HPT34x_IDE",
 	.id_table	= hpt34x_pci_tbl,
 	.probe		= hpt34x_init_one,
@@ -179,12 +179,12 @@ static struct pci_driver driver = {
 
 static int __init hpt34x_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&hpt34x_pci_driver);
 }
 
 static void __exit hpt34x_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&hpt34x_pci_driver);
 }
 
 module_init(hpt34x_ide_init);
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1620,7 +1620,7 @@ static const struct pci_device_id hpt366
 };
 MODULE_DEVICE_TABLE(pci, hpt366_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver hpt366_pci_driver = {
 	.name		= "HPT366_IDE",
 	.id_table	= hpt366_pci_tbl,
 	.probe		= hpt366_init_one,
@@ -1633,12 +1633,12 @@ static struct pci_driver driver = {
 
 static int __init hpt366_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&hpt366_pci_driver);
 }
 
 static void __exit hpt366_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&hpt366_pci_driver);
 }
 
 module_init(hpt366_ide_init);
Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -189,7 +189,7 @@ static const struct pci_device_id it8213
 
 MODULE_DEVICE_TABLE(pci, it8213_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver it8213_pci_driver = {
 	.name		= "ITE8213_IDE",
 	.id_table	= it8213_pci_tbl,
 	.probe		= it8213_init_one,
@@ -202,12 +202,12 @@ static struct pci_driver driver = {
 
 static int __init it8213_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&it8213_pci_driver);
 }
 
 static void __exit it8213_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&it8213_pci_driver);
 }
 
 module_init(it8213_ide_init);
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -676,7 +676,7 @@ static const struct pci_device_id it821x
 
 MODULE_DEVICE_TABLE(pci, it821x_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver it821x_pci_driver = {
 	.name		= "ITE821x IDE",
 	.id_table	= it821x_pci_tbl,
 	.probe		= it821x_init_one,
@@ -689,12 +689,12 @@ static struct pci_driver driver = {
 
 static int __init it821x_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&it821x_pci_driver);
 }
 
 static void __exit it821x_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&it821x_pci_driver);
 }
 
 module_init(it821x_ide_init);
Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -149,7 +149,7 @@ static struct pci_device_id jmicron_pci_
 
 MODULE_DEVICE_TABLE(pci, jmicron_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver jmicron_pci_driver = {
 	.name		= "JMicron IDE",
 	.id_table	= jmicron_pci_tbl,
 	.probe		= jmicron_init_one,
@@ -162,12 +162,12 @@ static struct pci_driver driver = {
 
 static int __init jmicron_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&jmicron_pci_driver);
 }
 
 static void __exit jmicron_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&jmicron_pci_driver);
 }
 
 module_init(jmicron_ide_init);
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -339,7 +339,7 @@ static const struct pci_device_id ns8741
 };
 MODULE_DEVICE_TABLE(pci, ns87415_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver ns87415_pci_driver = {
 	.name		= "NS87415_IDE",
 	.id_table	= ns87415_pci_tbl,
 	.probe		= ns87415_init_one,
@@ -352,12 +352,12 @@ static struct pci_driver driver = {
 
 static int __init ns87415_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&ns87415_pci_driver);
 }
 
 static void __exit ns87415_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&ns87415_pci_driver);
 }
 
 module_init(ns87415_ide_init);
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -220,7 +220,7 @@ static const struct pci_device_id opti62
 };
 MODULE_DEVICE_TABLE(pci, opti621_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver opti621_pci_driver = {
 	.name		= "Opti621_IDE",
 	.id_table	= opti621_pci_tbl,
 	.probe		= opti621_init_one,
@@ -233,12 +233,12 @@ static struct pci_driver driver = {
 
 static int __init opti621_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&opti621_pci_driver);
 }
 
 static void __exit opti621_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&opti621_pci_driver);
 }
 
 module_init(opti621_ide_init);
Index: b/drivers/ide/pci/pdc202xx_new.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -561,7 +561,7 @@ static const struct pci_device_id pdc202
 };
 MODULE_DEVICE_TABLE(pci, pdc202new_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver pdc202new_pci_driver = {
 	.name		= "Promise_IDE",
 	.id_table	= pdc202new_pci_tbl,
 	.probe		= pdc202new_init_one,
@@ -574,12 +574,12 @@ static struct pci_driver driver = {
 
 static int __init pdc202new_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&pdc202new_pci_driver);
 }
 
 static void __exit pdc202new_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&pdc202new_pci_driver);
 }
 
 module_init(pdc202new_ide_init);
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -426,7 +426,7 @@ static const struct pci_device_id pdc202
 };
 MODULE_DEVICE_TABLE(pci, pdc202xx_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver pdc202xx_pci_driver = {
 	.name		= "Promise_Old_IDE",
 	.id_table	= pdc202xx_pci_tbl,
 	.probe		= pdc202xx_init_one,
@@ -439,12 +439,12 @@ static struct pci_driver driver = {
 
 static int __init pdc202xx_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&pdc202xx_pci_driver);
 }
 
 static void __exit pdc202xx_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&pdc202xx_pci_driver);
 }
 
 module_init(pdc202xx_ide_init);
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -444,7 +444,7 @@ static const struct pci_device_id piix_p
 };
 MODULE_DEVICE_TABLE(pci, piix_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver piix_pci_driver = {
 	.name		= "PIIX_IDE",
 	.id_table	= piix_pci_tbl,
 	.probe		= piix_init_one,
@@ -458,12 +458,12 @@ static struct pci_driver driver = {
 static int __init piix_ide_init(void)
 {
 	piix_check_450nx();
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&piix_pci_driver);
 }
 
 static void __exit piix_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&piix_pci_driver);
 }
 
 module_init(piix_ide_init);
Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -59,7 +59,7 @@ static const struct pci_device_id rz1000
 };
 MODULE_DEVICE_TABLE(pci, rz1000_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver rz1000_pci_driver = {
 	.name		= "RZ1000_IDE",
 	.id_table	= rz1000_pci_tbl,
 	.probe		= rz1000_init_one,
@@ -68,12 +68,12 @@ static struct pci_driver driver = {
 
 static int __init rz1000_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&rz1000_pci_driver);
 }
 
 static void __exit rz1000_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&rz1000_pci_driver);
 }
 
 module_init(rz1000_ide_init);
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -328,7 +328,7 @@ static const struct pci_device_id sc1200
 };
 MODULE_DEVICE_TABLE(pci, sc1200_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver sc1200_pci_driver = {
 	.name		= "SC1200_IDE",
 	.id_table	= sc1200_pci_tbl,
 	.probe		= sc1200_init_one,
@@ -341,12 +341,12 @@ static struct pci_driver driver = {
 
 static int __init sc1200_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&sc1200_pci_driver);
 }
 
 static void __exit sc1200_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&sc1200_pci_driver);
 }
 
 module_init(sc1200_ide_init);
Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -944,7 +944,7 @@ static const struct pci_device_id scc_pc
 };
 MODULE_DEVICE_TABLE(pci, scc_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver scc_pci_driver = {
 	.name = "SCC IDE",
 	.id_table = scc_pci_tbl,
 	.probe = scc_init_one,
@@ -953,14 +953,14 @@ static struct pci_driver driver = {
 
 static int scc_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&scc_pci_driver);
 }
 
 module_init(scc_ide_init);
 /* -- No exit code?
 static void scc_ide_exit(void)
 {
-	ide_pci_unregister_driver(&driver);
+	ide_pci_unregister_driver(&scc_pci_driver);
 }
 module_exit(scc_ide_exit);
  */
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -443,7 +443,7 @@ static const struct pci_device_id svwks_
 };
 MODULE_DEVICE_TABLE(pci, svwks_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver svwks_pci_driver = {
 	.name		= "Serverworks_IDE",
 	.id_table	= svwks_pci_tbl,
 	.probe		= svwks_init_one,
@@ -456,12 +456,12 @@ static struct pci_driver driver = {
 
 static int __init svwks_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&svwks_pci_driver);
 }
 
 static void __exit svwks_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&svwks_pci_driver);
 }
 
 module_init(svwks_ide_init);
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -830,7 +830,7 @@ static const struct pci_device_id siimag
 };
 MODULE_DEVICE_TABLE(pci, siimage_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver siimage_pci_driver = {
 	.name		= "SiI_IDE",
 	.id_table	= siimage_pci_tbl,
 	.probe		= siimage_init_one,
@@ -843,12 +843,12 @@ static struct pci_driver driver = {
 
 static int __init siimage_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&siimage_pci_driver);
 }
 
 static void __exit siimage_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&siimage_pci_driver);
 }
 
 module_init(siimage_ide_init);
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -605,7 +605,7 @@ static const struct pci_device_id sis551
 };
 MODULE_DEVICE_TABLE(pci, sis5513_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver sis5513_pci_driver = {
 	.name		= "SIS_IDE",
 	.id_table	= sis5513_pci_tbl,
 	.probe		= sis5513_init_one,
@@ -618,12 +618,12 @@ static struct pci_driver driver = {
 
 static int __init sis5513_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&sis5513_pci_driver);
 }
 
 static void __exit sis5513_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&sis5513_pci_driver);
 }
 
 module_init(sis5513_ide_init);
Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -345,7 +345,7 @@ static const struct pci_device_id sl82c1
 };
 MODULE_DEVICE_TABLE(pci, sl82c105_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver sl82c105_pci_driver = {
 	.name		= "W82C105_IDE",
 	.id_table	= sl82c105_pci_tbl,
 	.probe		= sl82c105_init_one,
@@ -358,12 +358,12 @@ static struct pci_driver driver = {
 
 static int __init sl82c105_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&sl82c105_pci_driver);
 }
 
 static void __exit sl82c105_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&sl82c105_pci_driver);
 }
 
 module_init(sl82c105_ide_init);
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -154,7 +154,7 @@ static const struct pci_device_id slc90e
 };
 MODULE_DEVICE_TABLE(pci, slc90e66_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver slc90e66_pci_driver = {
 	.name		= "SLC90e66_IDE",
 	.id_table	= slc90e66_pci_tbl,
 	.probe		= slc90e66_init_one,
@@ -167,12 +167,12 @@ static struct pci_driver driver = {
 
 static int __init slc90e66_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&slc90e66_pci_driver);
 }
 
 static void __exit slc90e66_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&slc90e66_pci_driver);
 }
 
 module_init(slc90e66_ide_init);
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -245,7 +245,7 @@ static const struct pci_device_id tc86c0
 };
 MODULE_DEVICE_TABLE(pci, tc86c001_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver tc86c001_pci_driver = {
 	.name		= "TC86C001",
 	.id_table	= tc86c001_pci_tbl,
 	.probe		= tc86c001_init_one,
@@ -254,12 +254,12 @@ static struct pci_driver driver = {
 
 static int __init tc86c001_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&tc86c001_pci_driver);
 }
 
 static void __exit tc86c001_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&tc86c001_pci_driver);
 }
 
 module_init(tc86c001_ide_init);
Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -113,7 +113,7 @@ static const struct pci_device_id trifle
 };
 MODULE_DEVICE_TABLE(pci, triflex_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver triflex_pci_driver = {
 	.name		= "TRIFLEX_IDE",
 	.id_table	= triflex_pci_tbl,
 	.probe		= triflex_init_one,
@@ -126,12 +126,12 @@ static struct pci_driver driver = {
 
 static int __init triflex_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&triflex_pci_driver);
 }
 
 static void __exit triflex_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&triflex_pci_driver);
 }
 
 module_init(triflex_ide_init);
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -350,7 +350,7 @@ static const struct pci_device_id trm290
 };
 MODULE_DEVICE_TABLE(pci, trm290_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver trm290_pci_driver = {
 	.name		= "TRM290_IDE",
 	.id_table	= trm290_pci_tbl,
 	.probe		= trm290_init_one,
@@ -359,12 +359,12 @@ static struct pci_driver driver = {
 
 static int __init trm290_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&trm290_pci_driver);
 }
 
 static void __exit trm290_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&trm290_pci_driver);
 }
 
 module_init(trm290_ide_init);
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -487,7 +487,7 @@ static const struct pci_device_id via_pc
 };
 MODULE_DEVICE_TABLE(pci, via_pci_tbl);
 
-static struct pci_driver driver = {
+static struct pci_driver via_pci_driver = {
 	.name 		= "VIA_IDE",
 	.id_table 	= via_pci_tbl,
 	.probe 		= via_init_one,
@@ -500,12 +500,12 @@ static struct pci_driver driver = {
 
 static int __init via_ide_init(void)
 {
-	return ide_pci_register_driver(&driver);
+	return ide_pci_register_driver(&via_pci_driver);
 }
 
 static void __exit via_ide_exit(void)
 {
-	pci_unregister_driver(&driver);
+	pci_unregister_driver(&via_pci_driver);
 }
 
 module_init(via_ide_init);
