Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbXIQR72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbXIQR72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbXIQR7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:59:09 -0400
Received: from smtp116.plus.mail.re1.yahoo.com ([69.147.102.79]:44328 "HELO
	smtp116.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753449AbXIQR7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:59:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=6itSxGTmmzpeFN9Ij1MGYbBEZumckFfqYapBIU0JT2c51ITuL5tcjt0hdwD1xASPcWn5RWcqTpY7EhznCvCwmJ2nBMdoCt8k0Jfj48/4OwgzHUczblch9LxEOLf0bfkUdsUDizcrRZfmTUvanl3wj0klFGvUpKdvGK2AZVwPV+c=  ;
X-YMail-OSG: vqhD8GgVM1mRNZo0SeD5Ny6AMkteAcOMiczpBnrvdC76k01Vqnu2rgeTA.B43tXYCMcJ9XdADA--
Date: Mon, 17 Sep 2007 19:51:49 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org
Cc: amitkale@netxen.com
Subject: [PATCH 1/2] unify DMA_..BIT_MASK definitions: netxen local defs
Message-ID: <20070917175149.GB4941@gollum.tnic>
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
