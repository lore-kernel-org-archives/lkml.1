Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYJFP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYJFP5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYJFP4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 11:56:38 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:33946 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbYJFP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 11:56:36 -0400
From: Tom Tucker <tom@opengridcomputing.com>
To: ericvh@gmail.com
Cc: linux-kernel@vger.kernel.org, v9fs-devel@vger.kernel.org,
       minnich@dancer.ca.sandia.gov, lionkov@lanl.gov,
       Tom Tucker <tom@opengridcomputing.com>
Subject: [PATCH 03/03] 9prdma: Kconfig changes for the RDMA transport
Date: Mon,  6 Oct 2008 10:56:36 -0500
Message-Id: <1223308596-12014-4-git-send-email-tom@opengridcomputing.com>
X-Mailer: git-send-email 1.5.3.4.452.g09149
In-Reply-To: <1223308596-12014-3-git-send-email-tom@opengridcomputing.com>
References: <1223308596-12014-1-git-send-email-tom@opengridcomputing.com>
 <1223308596-12014-2-git-send-email-tom@opengridcomputing.com>
 <1223308596-12014-3-git-send-email-tom@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a config option for the 9P RDMA transport.

Signed-off-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: Latchesar Ionkov <lionkov@lanl.gov>

---
 net/9p/Kconfig |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index ff34c5a..c42c0c4 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -20,6 +20,12 @@ config NET_9P_VIRTIO
 	  This builds support for a transports between
 	  guest partitions and a host partition.
 
+config NET_9P_RDMA
+	depends on NET_9P && INFINIBAND && EXPERIMENTAL
+	tristate "9P RDMA Transport (Experimental)"
+	help
+	  This builds support for a RDMA transport.
+
 config NET_9P_DEBUG
 	bool "Debug information"
 	depends on NET_9P
