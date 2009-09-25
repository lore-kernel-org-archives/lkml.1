Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbZIYWTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbZIYWTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 18:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZIYWSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 18:18:49 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:31808 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbZIYWSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 18:18:47 -0400
From: kxie@chelsio.com
Message-Id: <200909252225.n8PMPaa4031752@localhost.localdomain>
Date: Fri, 25 Sep 2009 15:25:36 -0700
To: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com,
       davem@davemloft.net
Subject: [PATCH v2 2/2 scsi-post-merge] cxgb3i: support of private MAC
 address in iSCSI
Cc: swise@opengridcomputing.com, divy@chelsio.com, rakesh@chelsio.com,
       kxie@chelsio.com, linux-scsi@vger.kernel.org,
       open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH v2 2/2 scsi-post-merge] cxgb3i: private MAC address for iSCSI

From: Karen Xie <kxie@chelsio.com>
        
This patch updated the use of private MAC address per port in iscsi.

This patch is generated against scsi-post-merge.
             
Signed-off-by: Karen Xie <kxie@chelsio.com>
--- 
 drivers/scsi/cxgb3i/cxgb3i_offload.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index 6a1d86b..f585ece 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -234,9 +234,9 @@ struct sge_opaque_hdr {
  * get and set private ip for iscsi traffic
  */
 #define cxgb3i_get_private_ipv4addr(ndev) \
-	(((struct port_info *)(netdev_priv(ndev)))->iscsi_ipv4addr)
+	(((struct port_info *)(netdev_priv(ndev)))->iscsic.ipv4_addr)
 #define cxgb3i_set_private_ipv4addr(ndev, addr) \
-	(((struct port_info *)(netdev_priv(ndev)))->iscsi_ipv4addr) = addr
+	(((struct port_info *)(netdev_priv(ndev)))->iscsic.ipv4_addr) = addr
 
 /* max. connections per adapter */
 #define CXGB3I_MAX_CONN		16384
