Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbYJFP47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbYJFP47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYJFP4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:56:37 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:33945 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbYJFP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:56:36 -0400
From: Tom Tucker <tom@opengridcomputing.com>
To: ericvh@gmail.com
Cc: linux-kernel@vger.kernel.org, v9fs-devel@vger.kernel.org,
       minnich@dancer.ca.sandia.gov, lionkov@lanl.gov,
       Tom Tucker <tom@opengridcomputing.com>
Subject: [PATCH 02/03] 9prdma: Makefile change for the RDMA transport
Date: Mon,  6 Oct 2008 10:56:35 -0500
Message-Id: <1223308596-12014-3-git-send-email-tom@opengridcomputing.com>
X-Mailer: git-send-email 1.5.3.4.452.g09149
In-Reply-To: <1223308596-12014-2-git-send-email-tom@opengridcomputing.com>
References: <1223308596-12014-1-git-send-email-tom@opengridcomputing.com>
 <1223308596-12014-2-git-send-email-tom@opengridcomputing.com>
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
