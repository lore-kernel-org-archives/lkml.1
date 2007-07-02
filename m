Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXGBPJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXGBPJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 11:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXGBPJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 11:09:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:44418 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbXGBPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 11:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PGa5VI31KbTUcYMdk72E43rTPnfo/CTSgg+axzReQjeFWRcW3RmAACEPDL1zT06hZm1LTraUiAAN2hD1yg4x/x+lNZRcJKt2Myt52uZmPEu2vmkIMy+lYN9f6ASWnVwb3O2GqxtI55mrRf3CMpWSeFzzGvu+hqcA7PHW4VNq/v8=
Date: Mon, 2 Jul 2007 17:09:29 +0200
From: Florian Attenberger <valdyn@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 2.6.22-rc6] sata_mv: PCI-ID for Adaptec 1430SA SATA
	Controller
Message-ID: <20070702150929.GA15731@master.home>
References: <20070630144436.GA13479@master.home> <468906B6.1050700@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <468906B6.1050700@garzik.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Florian Attenberger  <valdyn@gmail.com>


--- 2.6.22-rc6/drivers/ata/sata_mv.c	2007-06-30 16:21:47.462020256 +0200
+++ 2.6.22-rc6.mine/drivers/ata/sata_mv.c	2007-06-30 16:25:25.999165444 +0200
@@ -582,6 +582,9 @@ static const struct pci_device_id mv_pci
 
 	{ PCI_VDEVICE(ADAPTEC2, 0x0241), chip_604x },
 
+	/* Adaptec 1430SA */
+	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
+
 	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },
 
 	/* add Marvell 7042 support */
