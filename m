Return-Path: <linux-kernel-owner+w=401wt.eu-S1763708AbYCWIzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763708AbYCWIzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760182AbYCWILt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:49 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2344 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758843AbYCWILn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:43 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 105/148] include/asm-x86/rio.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:20 -0700
Message-Id: <1206259443-13210-106-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/rio.h |   76 ++++++++++++++++++++++++------------------------
 1 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/asm-x86/rio.h b/include/asm-x86/rio.h
index 97cdcc9..3451c57 100644
--- a/include/asm-x86/rio.h
+++ b/include/asm-x86/rio.h
@@ -11,53 +11,53 @@
 #define RIO_TABLE_VERSION	3
 
 struct rio_table_hdr {
-	u8 version;      /* Version number of this data structure  */
-	u8 num_scal_dev; /* # of Scalability devices               */
-	u8 num_rio_dev;  /* # of RIO I/O devices                   */
+	u8 version;		/* Version number of this data structure  */
+	u8 num_scal_dev;	/* # of Scalability devices               */
+	u8 num_rio_dev;		/* # of RIO I/O devices                   */
 } __attribute__((packed));
 
 struct scal_detail {
-	u8 node_id;      /* Scalability Node ID                    */
-	u32 CBAR;        /* Address of 1MB register space          */
-	u8 port0node;    /* Node ID port connected to: 0xFF=None   */
-	u8 port0port;    /* Port num port connected to: 0,1,2, or  */
-	                 /* 0xFF=None                              */
-	u8 port1node;    /* Node ID port connected to: 0xFF = None */
-	u8 port1port;    /* Port num port connected to: 0,1,2, or  */
-	                 /* 0xFF=None                              */
-	u8 port2node;    /* Node ID port connected to: 0xFF = None */
-	u8 port2port;    /* Port num port connected to: 0,1,2, or  */
-	                 /* 0xFF=None                              */
-	u8 chassis_num;  /* 1 based Chassis number (1 = boot node) */
+	u8 node_id;		/* Scalability Node ID                    */
+	u32 CBAR;		/* Address of 1MB register space          */
+	u8 port0node;		/* Node ID port connected to: 0xFF=None   */
+	u8 port0port;		/* Port num port connected to: 0,1,2, or  */
+				/* 0xFF=None                              */
+	u8 port1node;		/* Node ID port connected to: 0xFF = None */
+	u8 port1port;		/* Port num port connected to: 0,1,2, or  */
+				/* 0xFF=None                              */
+	u8 port2node;		/* Node ID port connected to: 0xFF = None */
+	u8 port2port;		/* Port num port connected to: 0,1,2, or  */
+				/* 0xFF=None                              */
+	u8 chassis_num;		/* 1 based Chassis number (1 = boot node) */
 } __attribute__((packed));
 
 struct rio_detail {
-	u8 node_id;      /* RIO Node ID                            */
-	u32 BBAR;        /* Address of 1MB register space          */
-	u8 type;         /* Type of device                         */
-	u8 owner_id;     /* Node ID of Hurricane that owns this    */
-	                 /* node                                   */
-	u8 port0node;    /* Node ID port connected to: 0xFF=None   */
-	u8 port0port;    /* Port num port connected to: 0,1,2, or  */
-	                 /* 0xFF=None                              */
-	u8 port1node;    /* Node ID port connected to: 0xFF=None   */
-	u8 port1port;    /* Port num port connected to: 0,1,2, or  */
-	                 /* 0xFF=None                              */
-	u8 first_slot;   /* Lowest slot number below this Calgary  */
-	u8 status;       /* Bit 0 = 1 : the XAPIC is used          */
-	                 /*       = 0 : the XAPIC is not used, ie: */
-	                 /*            ints fwded to another XAPIC */
-	                 /*           Bits1:7 Reserved             */
-	u8 WP_index;     /* instance index - lower ones have       */
-	                 /*     lower slot numbers/PCI bus numbers */
-	u8 chassis_num;  /* 1 based Chassis number                 */
+	u8 node_id;		/* RIO Node ID                            */
+	u32 BBAR;		/* Address of 1MB register space          */
+	u8 type;		/* Type of device                         */
+	u8 owner_id;		/* Node ID of Hurricane that owns this    */
+				/* node                                   */
+	u8 port0node;		/* Node ID port connected to: 0xFF=None   */
+	u8 port0port;		/* Port num port connected to: 0,1,2, or  */
+				/* 0xFF=None                              */
+	u8 port1node;		/* Node ID port connected to: 0xFF=None   */
+	u8 port1port;		/* Port num port connected to: 0,1,2, or  */
+				/* 0xFF=None                              */
+	u8 first_slot;		/* Lowest slot number below this Calgary  */
+	u8 status;		/* Bit 0 = 1 : the XAPIC is used          */
+				/*       = 0 : the XAPIC is not used, ie: */
+				/*            ints fwded to another XAPIC */
+				/*           Bits1:7 Reserved             */
+	u8 WP_index;		/* instance index - lower ones have       */
+				/*     lower slot numbers/PCI bus numbers */
+	u8 chassis_num;		/* 1 based Chassis number                 */
 } __attribute__((packed));
 
 enum {
-	HURR_SCALABILTY	= 0,  /* Hurricane Scalability info */
-	HURR_RIOIB	= 2,  /* Hurricane RIOIB info       */
-	COMPAT_CALGARY	= 4,  /* Compatibility Calgary      */
-	ALT_CALGARY	= 5,  /* Second Planar Calgary      */
+	HURR_SCALABILTY	= 0,	/* Hurricane Scalability info */
+	HURR_RIOIB	= 2,	/* Hurricane RIOIB info       */
+	COMPAT_CALGARY	= 4,	/* Compatibility Calgary      */
+	ALT_CALGARY	= 5,	/* Second Planar Calgary      */
 };
 
 /*
-- 
1.5.4.rc2

