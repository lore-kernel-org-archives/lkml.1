Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbYBZKYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbYBZKYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757692AbYBZKYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:24:17 -0500
Received: from ns.ariel-networks.com ([124.39.57.10]:45784 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009AbYBZKYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:24:16 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] I found a type miss in fs/ext2/ext2
Message-Id: <20080226102415.DA893948006@ns.ariel-networks.com>
Date: Tue, 26 Feb 2008 19:24:15 +0900 (JST)
From: ohyama_sec@ariel-networks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroyasu Ohyama
==================

Maybe I found a type miss in fs/ext2/ext2.h which is in linux-2.6.24.3, and write difference below.

---

*** fs/ext2/ext2.h	2008-02-26 09:20:20.000000000 +0900
--- fs/ext2/ext2_correct.h	2008-02-26 19:12:55.000000000 +0900
***************
*** 27,33 ****
  	/*
  	 * i_block_group is the number of the block group which contains
  	 * this file's inode.  Constant across the lifetime of the inode,
! 	 * it is ued for making block allocation decisions - we try to
  	 * place a file's data blocks near its inode block, and new inodes
  	 * near to their parent directory's inode.
  	 */
--- 27,33 ----
  	/*
  	 * i_block_group is the number of the block group which contains
  	 * this file's inode.  Constant across the lifetime of the inode,
! 	 * it is used for making block allocation decisions - we try to
  	 * place a file's data blocks near its inode block, and new inodes
  	 * near to their parent directory's inode.
  	 */
