Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYBZQIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYBZQIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 11:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYBZQI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 11:08:28 -0500
Received: from ns.ariel-networks.com ([124.39.57.10]:54437 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYBZQI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 11:08:28 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ext2: correct type miss (linux-2.6.24.3)
Message-Id: <20080226160827.59B56978018@ns.ariel-networks.com>
Date: Wed, 27 Feb 2008 01:08:27 +0900 (JST)
From: ohyama_sec@ariel-networks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroyasu Ohyama

Maybe I found a type miss in fs/ext2/ext2.h which is in linux-2.6.24.3, and write difference below.

Signed-off-by: Hiroyasu OHYAMA <ohyama_sec@ariel-networks.com>
---

--- fs/ext2/ext2.h.orig	2008-02-27 00:56:34.000000000 +0900
+++ fs/ext2/ext2.h	2008-02-26 19:12:55.000000000 +0900
@@ -27,7 +27,7 @@ struct ext2_inode_info {
 	/*
 	 * i_block_group is the number of the block group which contains
 	 * this file's inode.  Constant across the lifetime of the inode,
-	 * it is ued for making block allocation decisions - we try to
+	 * it is used for making block allocation decisions - we try to
 	 * place a file's data blocks near its inode block, and new inodes
 	 * near to their parent directory's inode.
 	 */
