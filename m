Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab0BBTIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:08:32 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:46513 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab0BBTIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:08:20 -0500
Subject: [PATCH v2 07/18] IB/uverbs: whitespace cleanup
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 12:08:19 -0700
Message-ID: <20100202190819.28217.77764.stgit@bob.kio>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the errors as shown when 'let c_space_errors=1' is set in vim.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/uverbs_main.c |   68 +++++++++++++++++----------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 38b9085..aff706e 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -79,34 +79,34 @@ static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
 static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 				     const char __user *buf, int in_len,
 				     int out_len) = {
-	[IB_USER_VERBS_CMD_GET_CONTEXT]   	= ib_uverbs_get_context,
-	[IB_USER_VERBS_CMD_QUERY_DEVICE]  	= ib_uverbs_query_device,
-	[IB_USER_VERBS_CMD_QUERY_PORT]    	= ib_uverbs_query_port,
-	[IB_USER_VERBS_CMD_ALLOC_PD]      	= ib_uverbs_alloc_pd,
-	[IB_USER_VERBS_CMD_DEALLOC_PD]    	= ib_uverbs_dealloc_pd,
-	[IB_USER_VERBS_CMD_REG_MR]        	= ib_uverbs_reg_mr,
-	[IB_USER_VERBS_CMD_DEREG_MR]      	= ib_uverbs_dereg_mr,
+	[IB_USER_VERBS_CMD_GET_CONTEXT]		= ib_uverbs_get_context,
+	[IB_USER_VERBS_CMD_QUERY_DEVICE]	= ib_uverbs_query_device,
+	[IB_USER_VERBS_CMD_QUERY_PORT]		= ib_uverbs_query_port,
+	[IB_USER_VERBS_CMD_ALLOC_PD]		= ib_uverbs_alloc_pd,
+	[IB_USER_VERBS_CMD_DEALLOC_PD]		= ib_uverbs_dealloc_pd,
+	[IB_USER_VERBS_CMD_REG_MR]		= ib_uverbs_reg_mr,
+	[IB_USER_VERBS_CMD_DEREG_MR]		= ib_uverbs_dereg_mr,
 	[IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL] = ib_uverbs_create_comp_channel,
-	[IB_USER_VERBS_CMD_CREATE_CQ]     	= ib_uverbs_create_cq,
-	[IB_USER_VERBS_CMD_RESIZE_CQ]     	= ib_uverbs_resize_cq,
-	[IB_USER_VERBS_CMD_POLL_CQ]     	= ib_uverbs_poll_cq,
-	[IB_USER_VERBS_CMD_REQ_NOTIFY_CQ]     	= ib_uverbs_req_notify_cq,
-	[IB_USER_VERBS_CMD_DESTROY_CQ]    	= ib_uverbs_destroy_cq,
-	[IB_USER_VERBS_CMD_CREATE_QP]     	= ib_uverbs_create_qp,
-	[IB_USER_VERBS_CMD_QUERY_QP]     	= ib_uverbs_query_qp,
-	[IB_USER_VERBS_CMD_MODIFY_QP]     	= ib_uverbs_modify_qp,
-	[IB_USER_VERBS_CMD_DESTROY_QP]    	= ib_uverbs_destroy_qp,
-	[IB_USER_VERBS_CMD_POST_SEND]    	= ib_uverbs_post_send,
-	[IB_USER_VERBS_CMD_POST_RECV]    	= ib_uverbs_post_recv,
-	[IB_USER_VERBS_CMD_POST_SRQ_RECV]    	= ib_uverbs_post_srq_recv,
-	[IB_USER_VERBS_CMD_CREATE_AH]    	= ib_uverbs_create_ah,
-	[IB_USER_VERBS_CMD_DESTROY_AH]    	= ib_uverbs_destroy_ah,
-	[IB_USER_VERBS_CMD_ATTACH_MCAST]  	= ib_uverbs_attach_mcast,
-	[IB_USER_VERBS_CMD_DETACH_MCAST]  	= ib_uverbs_detach_mcast,
-	[IB_USER_VERBS_CMD_CREATE_SRQ]    	= ib_uverbs_create_srq,
-	[IB_USER_VERBS_CMD_MODIFY_SRQ]    	= ib_uverbs_modify_srq,
-	[IB_USER_VERBS_CMD_QUERY_SRQ]     	= ib_uverbs_query_srq,
-	[IB_USER_VERBS_CMD_DESTROY_SRQ]   	= ib_uverbs_destroy_srq,
+	[IB_USER_VERBS_CMD_CREATE_CQ]		= ib_uverbs_create_cq,
+	[IB_USER_VERBS_CMD_RESIZE_CQ]		= ib_uverbs_resize_cq,
+	[IB_USER_VERBS_CMD_POLL_CQ]		= ib_uverbs_poll_cq,
+	[IB_USER_VERBS_CMD_REQ_NOTIFY_CQ]	= ib_uverbs_req_notify_cq,
+	[IB_USER_VERBS_CMD_DESTROY_CQ]		= ib_uverbs_destroy_cq,
+	[IB_USER_VERBS_CMD_CREATE_QP]		= ib_uverbs_create_qp,
+	[IB_USER_VERBS_CMD_QUERY_QP]		= ib_uverbs_query_qp,
+	[IB_USER_VERBS_CMD_MODIFY_QP]		= ib_uverbs_modify_qp,
+	[IB_USER_VERBS_CMD_DESTROY_QP]		= ib_uverbs_destroy_qp,
+	[IB_USER_VERBS_CMD_POST_SEND]		= ib_uverbs_post_send,
+	[IB_USER_VERBS_CMD_POST_RECV]		= ib_uverbs_post_recv,
+	[IB_USER_VERBS_CMD_POST_SRQ_RECV]	= ib_uverbs_post_srq_recv,
+	[IB_USER_VERBS_CMD_CREATE_AH]		= ib_uverbs_create_ah,
+	[IB_USER_VERBS_CMD_DESTROY_AH]		= ib_uverbs_destroy_ah,
+	[IB_USER_VERBS_CMD_ATTACH_MCAST]	= ib_uverbs_attach_mcast,
+	[IB_USER_VERBS_CMD_DETACH_MCAST]	= ib_uverbs_detach_mcast,
+	[IB_USER_VERBS_CMD_CREATE_SRQ]		= ib_uverbs_create_srq,
+	[IB_USER_VERBS_CMD_MODIFY_SRQ]		= ib_uverbs_modify_srq,
+	[IB_USER_VERBS_CMD_QUERY_SRQ]		= ib_uverbs_query_srq,
+	[IB_USER_VERBS_CMD_DESTROY_SRQ]		= ib_uverbs_destroy_srq,
 };
 
 static struct vfsmount *uverbs_event_mnt;
@@ -368,7 +368,7 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
 
 static const struct file_operations uverbs_event_fops = {
 	.owner	 = THIS_MODULE,
-	.read 	 = ib_uverbs_event_read,
+	.read	 = ib_uverbs_event_read,
 	.poll    = ib_uverbs_event_poll,
 	.release = ib_uverbs_event_close,
 	.fasync  = ib_uverbs_event_fasync
@@ -678,17 +678,17 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 }
 
 static const struct file_operations uverbs_fops = {
-	.owner 	 = THIS_MODULE,
-	.write 	 = ib_uverbs_write,
-	.open 	 = ib_uverbs_open,
+	.owner	 = THIS_MODULE,
+	.write	 = ib_uverbs_write,
+	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close
 };
 
 static const struct file_operations uverbs_mmap_fops = {
-	.owner 	 = THIS_MODULE,
-	.write 	 = ib_uverbs_write,
+	.owner	 = THIS_MODULE,
+	.write	 = ib_uverbs_write,
 	.mmap    = ib_uverbs_mmap,
-	.open 	 = ib_uverbs_open,
+	.open	 = ib_uverbs_open,
 	.release = ib_uverbs_close
 };
 

