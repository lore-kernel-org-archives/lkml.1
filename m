Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbXKKMCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbXKKMCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 07:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbXKKMCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 07:02:17 -0500
Received: from ensim03.bon.m2soft.com ([195.38.20.12]:58299 "EHLO
	ensim03.bon.m2soft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbXKKMCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 07:02:16 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2007 07:02:16 EST
X-ClientAddr: 85.124.174.38
Date: Sun, 11 Nov 2007 12:51:32 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] fs/hfs: remove duplicated defines
Message-ID: <20071111125132.1ce29211@lucky.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-M2Soft-MailScanner-Information: Please contact the ISP for more information
X-M2Soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated defines.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---

 fs/hfs/btree.h |    5 -----
 1 file changed, 5 deletions(-)

--- a/fs/hfs/btree.h	2007-10-09 22:31:38.000000000 +0200
+++ b/fs/hfs/btree.h	2007-11-11 12:42:59.000000000 +0100
@@ -153,11 +153,6 @@
 	u32 reserved3[16];
 } __packed;
 
-#define HFS_NODE_INDEX	0x00	/* An internal (index) node */
-#define HFS_NODE_HEADER	0x01	/* The tree header node (node 0) */
-#define HFS_NODE_MAP		0x02	/* Holds part of the bitmap of used nodes */
-#define HFS_NODE_LEAF		0xFF	/* A leaf (ndNHeight==1) node */
-
 #define BTREE_ATTR_BADCLOSE	0x00000001	/* b-tree not closed properly. not
 						   used by hfsplus. */
 #define HFS_TREE_BIGKEYS	0x00000002	/* key length is u16 instead of u8.
