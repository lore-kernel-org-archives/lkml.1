Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbZJOIfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbZJOIfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760797AbZJOIfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:35:34 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:51200 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760602AbZJOIfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:35:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=t6XbMXHpX6GiOwcGaTHXl4+Zm8WI1KWsYgB58ThDqUEEFvopGGMlZz9ep9E36h9WPB
         O3qjiR1HUt2xAnNcrS5Db7YIX5i+093XNXizPuzwnJwJ3L4O2vcZ3xZ7gym6w3fazNVH
         nINvFVkTQ9p55yKOXy1n8BLp1cK73322Fg5XY=
MIME-Version: 1.0
Date: Thu, 15 Oct 2009 16:34:56 +0800
Message-ID: <cfaab6210910150134q6cc2d5ffna39cf31bf89a8e2@mail.gmail.com>
Subject: [PATCH] ahci: Add the AHCI controller Linux Device ID for NVIDIA 
	chipsets.
From: peer chen <peerchen@gmail.com>
To: linux-ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, akpm <akpm@linux-foundation.org>,
       pchen@nvidia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the generic device ID for NVIDIA AHCI controller.

Signed-off-by: Peer Chen<peerchen@gmail.com>
---
--- linux-2.6.32-rc4/drivers/ata/ahci.c.orig
+++ linux-2.6.32-rc4/drivers/ata/ahci.c
@@ -605,6 +605,7 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci_yesncq },	/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci_yesncq },	/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci_yesncq },	/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x0580), board_ahci_yesncq },	/* Linux ID */
 	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci_yesncq },	/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci_yesncq },	/* MCP73 */
 	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci_yesncq },	/* MCP73 */
-
