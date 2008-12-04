Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbYLDFJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbYLDFJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 00:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYLDFI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 00:08:58 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49085 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYLDFI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 00:08:57 -0500
Subject: [PATCH] PCI: remove pci_dac_dma_... APIs on mn10300
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: jbeulich@novell.com, gregkh@suse.de, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com,
       Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 04 Dec 2008 14:08:55 +0900
Message-Id: <1228367335.10823.22.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that mn10300 made it upstream after Jan Beulich's pci_dac_dma_*
cleanup work and still defines pci_dac_dma_supported(). This API is not
required by the PCI subsystem anymore, so remove it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.28-rc7-orig/include/asm-mn10300/pci.h linux-2.6.28-rc7/include/asm-mn10300/pci.h
--- linux-2.6.28-rc7-orig/include/asm-mn10300/pci.h	2008-10-10 07:13:53.000000000 +0900
+++ linux-2.6.28-rc7/include/asm-mn10300/pci.h	2008-12-04 13:53:13.000000000 +0900
@@ -70,10 +70,6 @@ struct pci_dev;
  */
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
-
-/* This is always fine. */
-#define pci_dac_dma_supported(pci_dev, mask)	(0)
-
 /* Return the index of the PCI controller for device. */
 static inline int pci_controller_num(struct pci_dev *dev)
 {


