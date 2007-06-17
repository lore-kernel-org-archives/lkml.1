Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbXFQVYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbXFQVYQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbXFQVYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:24:01 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:56326 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXFQVYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:24:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qOcQppPjnXYIVLBlqw8uEXw+OPvXMzdiD4/KDePUuePdd1B+XlCdxGfvkjHFHHYMf9jTlHGx09oLOCN/MeCPWN5zbrDoI14AfQMg/QEWLsnEqBoBZmu0H6TCFVt9VInAUpyk2zg0JqSQ4loWddz+B+daWfwE9G81YRhXtqe0Ikc=
Message-ID: <e4c519350706171423ldf77f77ve7080c213e6ec3fc@mail.gmail.com>
Date: Sun, 17 Jun 2007 23:23:27 +0200
From: "Maurizio Monge" <maurizio.monge@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add new ICH9M pci id (8086:2850) to ata_piix id list
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To make ata_piix recognize my ich9m chip i had to apply the
modification that follows.

Best regards
Maurizio Monge


diff -Nurb old/drivers/ata/ata_piix.c new/drivers/ata/ata_piix.c
--- old/drivers/ata/ata_piix.c  2007-06-17 23:06:12.000000000 +0200
+++ new/drivers/ata/ata_piix.c  2007-06-17 23:15:57.000000000 +0200
@@ -243,6 +243,8 @@
        { 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
        /* SATA Controller IDE (ICH9M) */
        { 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+       /* Mobile SATA Controller IDE (ICH9M) */
+       { 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },

        { }     /* terminate list */
 };
