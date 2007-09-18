Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbXIREbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbXIREbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 00:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbXIREbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 00:31:06 -0400
Received: from smtp103.plus.mail.re1.yahoo.com ([69.147.102.66]:45717 "HELO
	smtp103.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753922AbXIREbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 00:31:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=FIw67t4hpRZGFtr/mL5OYZljnzeyoqD9hsAU6W+hCNfDU6NKnzdBeds1+rk5eJ3zEngjaFbge3mgcjbOKOqDbVKamFgIo0xLzRf+725+wrRfbha4qkNsUldBnMcePcgdpfze36ceMzbrLCKMO05mBceBzYpiOJZE7hrwC8Pqlzo=  ;
X-YMail-OSG: kdlPxKAVM1nwQ7rEtnloN8M_fwobcfnp1ePucDup.00LnWMGKl8ubmIHQGo_QbixsXK8RBUx1A--
Date: Tue, 18 Sep 2007 06:30:30 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: amitkale@netxen.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 1/2] unify DMA_..BIT_MASK definitions v1: netxen local defs
Message-ID: <20070918043030.GA9206@gollum.tnic>
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

--
Index: 23-rc6/drivers/net/netxen/netxen_nic_main.c
===================================================================
--- 23-rc6/drivers/net/netxen/netxen_nic_main.c.orig	2007-09-17 17:51:46.000000000 +0200
+++ 23-rc6/drivers/net/netxen/netxen_nic_main.c	2007-09-17 17:51:59.000000000 +0200
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
