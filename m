Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308Ab0BDPi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:38:26 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:57897 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab0BDPiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:38:24 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: davem@davemloft.net
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] can: ems_usb: removed duplicated code setting local echo support
Date: Thu,  4 Feb 2010 13:33:44 -0200
Message-Id: <1265297624-1853-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <20100203.203256.227182356.davem@davemloft.net>
References: <20100203.203256.227182356.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/net/can/usb/ems_usb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index bfab283..11c8784 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -1024,8 +1024,6 @@ static int ems_usb_probe(struct usb_interface *intf,
 	dev->can.do_set_mode = ems_usb_set_mode;
 	dev->can.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES;
 
-	netdev->flags |= IFF_ECHO; /* we support local echo */
-
 	netdev->netdev_ops = &ems_usb_netdev_ops;
 
 	netdev->flags |= IFF_ECHO; /* we support local echo */
-- 
1.6.6.1

