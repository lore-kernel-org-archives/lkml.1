Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab0BBTJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:09:09 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:43202 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab0BBTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:08:51 -0500
Subject: [PATCH v2 13/18] IB/umad: clean whitespace
To: rdreier@cisco.com
From: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 12:08:50 -0700
Message-ID: <20100202190850.28217.88334.stgit@bob.kio>
In-Reply-To: <20100202185235.28217.64521.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean errors as shown when 'let c_space_errors=1' is set in vim.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/infiniband/core/user_mad.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 7fc1e51..3595bd5 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -487,8 +487,8 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		ah_attr.ah_flags = IB_AH_GRH;
 		memcpy(ah_attr.grh.dgid.raw, packet->mad.hdr.gid, 16);
 		ah_attr.grh.sgid_index	   = packet->mad.hdr.gid_index;
-		ah_attr.grh.flow_label 	   = be32_to_cpu(packet->mad.hdr.flow_label);
-		ah_attr.grh.hop_limit  	   = packet->mad.hdr.hop_limit;
+		ah_attr.grh.flow_label	   = be32_to_cpu(packet->mad.hdr.flow_label);
+		ah_attr.grh.hop_limit	   = packet->mad.hdr.hop_limit;
 		ah_attr.grh.traffic_class  = packet->mad.hdr.traffic_class;
 	}
 
@@ -519,9 +519,9 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		goto err_ah;
 	}
 
-	packet->msg->ah 	= ah;
+	packet->msg->ah		= ah;
 	packet->msg->timeout_ms = packet->mad.hdr.timeout_ms;
-	packet->msg->retries 	= packet->mad.hdr.retries;
+	packet->msg->retries	= packet->mad.hdr.retries;
 	packet->msg->context[0] = packet;
 
 	/* Copy MAD header.  Any RMPP header is already in place. */
@@ -856,16 +856,16 @@ static int ib_umad_close(struct inode *inode, struct file *filp)
 }
 
 static const struct file_operations umad_fops = {
-	.owner 	 	= THIS_MODULE,
-	.read 	 	= ib_umad_read,
-	.write 	 	= ib_umad_write,
-	.poll 	 	= ib_umad_poll,
+	.owner		= THIS_MODULE,
+	.read		= ib_umad_read,
+	.write		= ib_umad_write,
+	.poll		= ib_umad_poll,
 	.unlocked_ioctl = ib_umad_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl 	= ib_umad_compat_ioctl,
+	.compat_ioctl	= ib_umad_compat_ioctl,
 #endif
-	.open 	 	= ib_umad_open,
-	.release 	= ib_umad_close
+	.open		= ib_umad_open,
+	.release	= ib_umad_close
 };
 
 static int ib_umad_sm_open(struct inode *inode, struct file *filp)
@@ -930,8 +930,8 @@ static int ib_umad_sm_close(struct inode *inode, struct file *filp)
 }
 
 static const struct file_operations umad_sm_fops = {
-	.owner 	 = THIS_MODULE,
-	.open 	 = ib_umad_sm_open,
+	.owner	 = THIS_MODULE,
+	.open	 = ib_umad_sm_open,
 	.release = ib_umad_sm_close
 };
 

