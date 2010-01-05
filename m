Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627Ab0AEAhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab0AEAhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571Ab0AEAgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:36:25 -0500
Received: from kroah.org ([198.145.64.141]:42528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab0AEAgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:21 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Fang Wenqi <anton.fang@gmail.com>,
       Fang Wenqi <antonf@turbolinux.com.cn>, "Theodore Ts'o" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 94/97] ext4: Update documentation to correct the inode_readahead_blks option name
Date: Mon,  4 Jan 2010 16:33:47 -0800
Message-Id: <1262651630-7354-94-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fang Wenqi <anton.fang@gmail.com>

commit 6d3b82f2d31f22085e5711b28dddcb9fb3d97a25 upstream.

Per commit 240799cd, the option name for readahead should be
inode_readahead_blks, not inode_readahead.

Signed-off-by: Fang Wenqi <antonf@turbolinux.com.cn>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/ext4.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index af6885c..e1def17 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -196,7 +196,7 @@ nobarrier		This also requires an IO stack which can support
 			also be used to enable or disable barriers, for
 			consistency with other ext4 mount options.
 
-inode_readahead=n	This tuning parameter controls the maximum
+inode_readahead_blks=n	This tuning parameter controls the maximum
 			number of inode table blocks that ext4's inode
 			table readahead algorithm will pre-read into
 			the buffer cache.  The default value is 32 blocks.
-- 
1.6.6

