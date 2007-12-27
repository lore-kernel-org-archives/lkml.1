Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbXL0TBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbXL0TBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbXL0TBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:01:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6066 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbXL0TBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=StAWarG2lfwGAFRei9cGLGNTHcmoTGaARpQ81KCvTlAwuzFm/XHCkrZ/JtWhc5owRo9kiX7Zra1Iv43r7kOLF7uU7/OuYfT77UbZyLoub0skOXEQAgSeYNz1gEkd0C7xtK3G1htEyLIXpBw5g438UYt89ZEPA2Rxgwtd+4sgWAM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, bzolnier@gmail.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 27 Dec 2007 20:12:00 +0100
Message-Id: <20071227191200.1357.71766.sendpatchset@localhost.localdomain>
In-Reply-To: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/9] piix: remove stale comments
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/piix.c |   47 +----------------------------------------------
 1 file changed, 1 insertion(+), 46 deletions(-)

Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -8,53 +8,8 @@
  *
  *  May be copied or modified under the terms of the GNU General Public License
  *
- *  PIO mode setting function for Intel chipsets.
- *  For use instead of BIOS settings.
+ * Documentation:
  *
- * 40-41
- * 42-43
- * 
- *                 41
- *                 43
- *
- * | PIO 0       | c0 | 80 | 0 |
- * | PIO 2 | SW2 | d0 | 90 | 4 |
- * | PIO 3 | MW1 | e1 | a1 | 9 |
- * | PIO 4 | MW2 | e3 | a3 | b |
- *
- * sitre = word40 & 0x4000; primary
- * sitre = word42 & 0x4000; secondary
- *
- * 44 8421|8421    hdd|hdb
- *
- * 48 8421         hdd|hdc|hdb|hda udma enabled
- *
- *    0001         hda
- *    0010         hdb
- *    0100         hdc
- *    1000         hdd
- *
- * 4a 84|21        hdb|hda
- * 4b 84|21        hdd|hdc
- *
- *    ata-33/82371AB
- *    ata-33/82371EB
- *    ata-33/82801AB            ata-66/82801AA
- *    00|00 udma 0              00|00 reserved
- *    01|01 udma 1              01|01 udma 3
- *    10|10 udma 2              10|10 udma 4
- *    11|11 reserved            11|11 reserved
- *
- * 54 8421|8421    ata66 drive|ata66 enable
- *
- * pci_read_config_word(HWIF(drive)->pci_dev, 0x40, &reg40);
- * pci_read_config_word(HWIF(drive)->pci_dev, 0x42, &reg42);
- * pci_read_config_word(HWIF(drive)->pci_dev, 0x44, &reg44);
- * pci_read_config_byte(HWIF(drive)->pci_dev, 0x48, &reg48);
- * pci_read_config_word(HWIF(drive)->pci_dev, 0x4a, &reg4a);
- * pci_read_config_byte(HWIF(drive)->pci_dev, 0x54, &reg54);
- *
- * Documentation
  *	Publically available from Intel web site. Errata documentation
  * is also publically available. As an aide to anyone hacking on this
  * driver the list of errata that are relevant is below.going back to
