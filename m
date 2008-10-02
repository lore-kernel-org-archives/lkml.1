Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbYJBAJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbYJBAJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYJBAIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:08:41 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:38606 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbYJBAIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:08:39 -0400
From: Tom Tucker <tom@opengridcomputing.com>
To: ericvh@gmail.com, linux-kernel@vger.kernel.org, v9fs-devel@vger.kernel.org
Cc: rminnich@dancer.ca.sandia.gov, lionkov@lanl.gov, tom@opengridcomputing.com
Subject: [PATCH 02/03] 9prdma: Makefile change for the RDMA transport
Date: Wed,  1 Oct 2008 19:08:38 -0500
Message-Id: <1222906119-14310-3-git-send-email-tom@opengridcomputing.com>
X-Mailer: git-send-email 1.5.3.4.452.g09149
In-Reply-To: <1222906119-14310-2-git-send-email-tom@opengridcomputing.com>
References: <1222906119-14310-1-git-send-email-tom@opengridcomputing.com>
 <1222906119-14310-2-git-send-email-tom@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a make rule for the 9pnet_rdma module that implements
the RDMA transport.

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: Latchesar Ionkov <lionkov@lanl.gov>

---
 net/9p/Makefile |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/9p/Makefile b/net/9p/Makefile
index 5192194..bc909ab 100644
--- a/net/9p/Makefile
+++ b/net/9p/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_NET_9P) := 9pnet.o
 obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_virtio.o
+obj-$(CONFIG_NET_9P_RDMA) += 9pnet_rdma.o
 
 9pnet-objs := \
 	mod.o \
@@ -12,3 +13,6 @@ obj-$(CONFIG_NET_9P_VIRTIO) += 9pnet_virtio.o
 
 9pnet_virtio-objs := \
 	trans_virtio.o \
+
+9pnet_rdma-objs := \
+	trans_rdma.o \
