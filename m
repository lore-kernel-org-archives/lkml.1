Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbXHBLGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbXHBLGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbXHBLGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:06:09 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52112 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbXHBLGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:06:08 -0400
Date: Thu, 2 Aug 2007 07:06:07 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] pata_isapnp: use MODULE_DEVICE_TABLE()
Message-ID: <20070802110606.GA26087@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I found this while doing ISDN PCI API conversions...  I presume this
omission was not intentional?

Signed-off-by: Jeff Garzik <jeff@garzik.org>


diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 5525518..91a396f 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -139,6 +139,8 @@ static struct pnp_device_id isapnp_devices[] = {
 	{.id = ""}
 };
 
+MODULE_DEVICE_TABLE(pnp, isapnp_devices);
+
 static struct pnp_driver isapnp_driver = {
 	.name		= DRV_NAME,
 	.id_table	= isapnp_devices,
