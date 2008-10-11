Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbYJKXld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbYJKXld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 19:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYJKXlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 19:41:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:34353 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbYJKXlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 19:41:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=qtA6s9tt5M2LBw4zUugVckdxMnMn5X8yz20kI3X6S6e6aiLb22rOpyitOlvqbEXQzP
         0dOL95ejpcfsaarEHmim17tkq8DV7DrQHwhWvmC3QUPqMMQ025fFeqzp+g6RQ8vA7MJq
         yfnZtaOCfoZBlkGt5Ng7sOvtl6b1/zrbC/uEg=
Message-ID: <64630f150810111641s764e454n43baf759b7848373@mail.gmail.com>
Date: Sun, 12 Oct 2008 00:41:22 +0100
From: gettinther <gettinther@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Marvell 88SE6141
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To the attention of Alan Cox,

Following an issue from one of our users,  I had to patch the 2.6.26
kernel (and also the 2.6.27) for the marvell controller based on your
patch dated 2006.

http://www.nabble.com/kernel-support-for-Marvell-88SE614x-chipset-to7091227.html

I had to modify the patch to adjust it but the user reported proper
recognition of the hardware.

Just letting you know in case you just forgot to include it.  Or is
there is another issue I should be aware of.

Thanking you

Cyrille

--- a/drivers/ata/ahci.c~ 2006-10-31 13:00:50.918919744 +0000
+++ a/drivers/ata/ahci.c 2006-10-31 13:00:50.927918376 +0000
@@ -540,6 +540,7 @@

	/* Marvell */
	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
+ 	{ PCI_VDEVICE(MARVELL, 0x6141), board_ahci_mv },	/* 6141 */
	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */

	/* Generic, PCI class code for AHCI */
