Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZFZC1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZFZC1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZFZC1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:27:39 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:60401 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZFZC1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:27:39 -0400
Message-ID: <4A44321D.3070007@oss.ntt.co.jp>
Date: Fri, 26 Jun 2009 11:27:41 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: jbeulich@novell.com, gregkh@suse.de, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com
Subject: [PATCH] PCI: remove pci_dac_dma_... APIs on mn10300
References: <1228367335.10823.22.camel@sebastian.kern.oss.ntt.co.jp> <4A4431D9.10906@oss.ntt.co.jp>
In-Reply-To: <4A4431D9.10906@oss.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that mn10300 made it upstream after Jan Beulich's pci_dac_dma_*
cleanup work and still defines pci_dac_dma_supported(). This API is not
required by the PCI subsystem anymore, so remove it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.31-rc1-orig/arch/mn10300/include/asm/pci.h linux-2.6.31-rc1/arch/mn10300/include/asm/pci.h
--- linux-2.6.31-rc1-orig/arch/mn10300/include/asm/pci.h	2009-06-26 10:58:02.012044068 +0900
+++ linux-2.6.31-rc1/arch/mn10300/include/asm/pci.h	2009-06-26 11:19:34.130867667 +0900
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
