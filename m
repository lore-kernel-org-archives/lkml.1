Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbXIRGRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbXIRGRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbXIRGRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:17:08 -0400
Received: from smtp114.plus.mail.re1.yahoo.com ([69.147.102.77]:40138 "HELO
	smtp114.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758126AbXIRGRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:17:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=OIsA8ZRb0pxDxTEkUtTFwwPge6FlKXpBXW4XZu30IfHhy0zfbsGdl07Y7MQoISpzdlAzRU+qoiXmez6zunsXwKs7CwKZpXMC7MaTQ2gh15hxXEsxmKXuLiAwq0CaFsGulLW38CWbq8MZeqJnmPTU+ZRUvbBmkhxbADOyD+ep0DE=  ;
X-YMail-OSG: JXR2Gh0VM1lpBUXHTvo3XQvKzvY.J_TuMLmaB2qFxdP.rPBk
Date: Tue, 18 Sep 2007 08:16:28 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: amitkale@netxen.com, Jeremy Fitzhardinge <jeremy@goop.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>
Subject: [PATCH 1/2] unify DMA_..BIT_MASK definitions v2: netxen local defs
Message-ID: <20070918061628.GA15965@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move dma bitmask definitions into the dma-mappings header.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>

---
 23-rc6/drivers/net/netxen/netxen_nic_main.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/23-rc6/drivers/net/netxen/netxen_nic_main.c
===================================================================
--- a/23-rc6/drivers/net/netxen/netxen_nic_main.c	2007-09-18 08:11:03.000000000 +0200
+++ b/23-rc6/drivers/net/netxen/netxen_nic_main.c	2007-09-18 08:14:29.000000000 +0200
@@ -54,9 +54,6 @@
 #define NETXEN_ADAPTER_UP_MAGIC 777
 #define NETXEN_NIC_PEG_TUNE 0
 
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_35BIT_MASK	0x00000007ffffffffULL
-
 /* Local functions to NetXen NIC driver */
 static int __devinit netxen_nic_probe(struct pci_dev *pdev,
 				      const struct pci_device_id *ent);

-- 
Regards/Gruﬂ,
    Boris.
