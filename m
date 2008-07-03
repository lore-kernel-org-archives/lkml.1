Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbYGCOUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbYGCOUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbYGCOTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:19:47 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:17962 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758553AbYGCOTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:19:46 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH 2/3] ehea: add MODULE_DEVICE_TABLE
Date: Thu, 3 Jul 2008 15:18:48 +0100
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, kamalesh@linux.vnet.ibm.com,
       hering2@de.ibm.com
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200807031618.49641.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Required to allow distros to easily detect when ehea
module needs to be loaded

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>


---

diff -Nurp -X dontdiff linux-2.6.26-rc8/drivers/net/ehea/ehea_main.c patched_kernel/drivers/net/ehea/ehea_main.c
--- linux-2.6.26-rc8/drivers/net/ehea/ehea_main.c	2008-07-02 13:27:03.000000000 +0200
+++ patched_kernel/drivers/net/ehea/ehea_main.c	2008-07-02 13:48:21.000000000 +0200
@@ -118,6 +118,7 @@ static struct of_device_id ehea_device_t
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, ehea_device_table);
 
 static struct of_platform_driver ehea_driver = {
 	.name = "ehea",
