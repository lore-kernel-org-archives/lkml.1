Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936378Ab0CMBTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:19:17 -0500
Received: from kroah.org ([198.145.64.141]:60961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934976Ab0CMAUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:39 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:12 2010
Message-Id: <20100313001511.981386918@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Hutchings <ben@decadent.org.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 078/123] sunxvr500: Additional PCI id for sunxvr500 driver
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 275143e9b237dd7e0b6d01660fd9b8acd9922fa7 upstream.

Intergraph bought 3D Labs and some XVR-500 chips have Intergraph's
vendor id.

Reported-by: Jurij Smakov <jurij@wooyd.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/sunxvr500.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/sunxvr500.c
+++ b/drivers/video/sunxvr500.c
@@ -400,6 +400,7 @@ static void __devexit e3d_pci_unregister
 
 static struct pci_device_id e3d_pci_table[] = {
 	{	PCI_DEVICE(PCI_VENDOR_ID_3DLABS, 0x7a0),	},
+	{	PCI_DEVICE(0x1091, 0x7a0),			},
 	{	PCI_DEVICE(PCI_VENDOR_ID_3DLABS, 0x7a2),	},
 	{	.vendor = PCI_VENDOR_ID_3DLABS,
 		.device = PCI_ANY_ID,


