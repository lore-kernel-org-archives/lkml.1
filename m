Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbYJWE6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbYJWE6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 00:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYJWE62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 00:58:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:60939 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbYJWE61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 00:58:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=U0NJ8hrs7ttO4AtemvyS8OKbiPY6OeuC0GPi6Fhp3+9pl39SPEjwOC5dJt+5K3CsU9
         PkuPBJdzDQPGlJr5v/tjK4pkhooIxccB2PTlb30Memv6dqKbhFhCviqs+qDN7fJCHuya
         eslIC1/MIMmb7qAfde60vstlcRMcFgJysO60M=
Subject: [PATCH 2/3] netxen: trivial endian annotations of netxen structs
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dhananjay Phadke <dhananjay@netxen.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 21:58:21 -0700
Message-Id: <1224737901.6823.27.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly used in netxen_nic_ctx.c. Currently all assignments to these
members are properly annotated, make the structs match.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/netxen/netxen_nic.h |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic.h b/drivers/net/netxen/netxen_nic.h
index 18c699d..0947514 100644
--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -995,29 +995,29 @@ struct netxen_recv_context {
  */
 
 typedef struct {
-	u64 host_phys_addr;	/* Ring base addr */
-	u32 ring_size;		/* Ring entries */
-	u16 msi_index;
+	__le64 host_phys_addr;	/* Ring base addr */
+	__le32 ring_size;		/* Ring entries */
+	__le16 msi_index;
 	u16 rsvd;		/* Padding */
 } nx_hostrq_sds_ring_t;
 
 typedef struct {
-	u64 host_phys_addr;	/* Ring base addr */
-	u64 buff_size;		/* Packet buffer size */
-	u32 ring_size;		/* Ring entries */
-	u32 ring_kind;		/* Class of ring */
+	__le64 host_phys_addr;	/* Ring base addr */
+	__le64 buff_size;		/* Packet buffer size */
+	__le32 ring_size;		/* Ring entries */
+	__le32 ring_kind;		/* Class of ring */
 } nx_hostrq_rds_ring_t;
 
 typedef struct {
-	u64 host_rsp_dma_addr;	/* Response dma'd here */
-	u32 capabilities[4];	/* Flag bit vector */
-	u32 host_int_crb_mode;	/* Interrupt crb usage */
-	u32 host_rds_crb_mode;	/* RDS crb usage */
+	__le64 host_rsp_dma_addr;	/* Response dma'd here */
+	__le32 capabilities[4];	/* Flag bit vector */
+	__le32 host_int_crb_mode;	/* Interrupt crb usage */
+	__le32 host_rds_crb_mode;	/* RDS crb usage */
 	/* These ring offsets are relative to data[0] below */
 	u32 rds_ring_offset;	/* Offset to RDS config */
 	u32 sds_ring_offset;	/* Offset to SDS config */
-	u16 num_rds_rings;	/* Count of RDS rings */
-	u16 num_sds_rings;	/* Count of SDS rings */
+	__le16 num_rds_rings;	/* Count of RDS rings */
+	__le16 num_sds_rings;	/* Count of SDS rings */
 	u16 rsvd1;		/* Padding */
 	u16 rsvd2;		/* Padding */
 	u8  reserved[128]; 	/* reserve space for future expansion*/
-- 
1.6.0.3.723.g757e


