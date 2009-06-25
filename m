Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbZFYFSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbZFYFSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758620AbZFYFOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:14:23 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1474 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbZFYFOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:14:12 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 17/19] drivers/telephony: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:33 -0700
Message-Id: <7a39a21ecd9cfd5204828ef9c4c273b0e80d30e7.1245906153.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/telephony/ixj.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index a913efc..1e941d3 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -283,8 +283,7 @@ static int samplerate = 100;
 module_param(ixjdebug, int, 0);
 
 static struct pci_device_id ixj_pci_tbl[] __devinitdata = {
-	{ PCI_VENDOR_ID_QUICKNET, PCI_DEVICE_ID_QUICKNET_XJ,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VDEVICE(QUICKNET, PCI_DEVICE_ID_QUICKNET_XJ), 0},
 	{ }
 };
 
-- 
1.6.3.1.10.g659a0.dirty

