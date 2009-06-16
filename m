Return-Path: <linux-kernel-owner+w=401wt.eu-S936262AbZFPFx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936262AbZFPFx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933524AbZFPFvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:00 -0400
Received: from kroah.org ([198.145.64.141]:48321 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761233AbZFPFvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 12/64] debugfs: fix docbook error
Date: Mon, 15 Jun 2009 22:46:01 -0700
Message-Id: <1245131213-24168-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Corbet <corbet@lwn.net>

Fix an error in debugfs_create_blob's docbook description

It cannot actually be used to write a binary blob.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 fs/debugfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 33a9012..39a619c 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -419,7 +419,7 @@ static const struct file_operations fops_blob = {
 };
 
 /**
- * debugfs_create_blob - create a debugfs file that is used to read and write a binary blob
+ * debugfs_create_blob - create a debugfs file that is used to read a binary blob
  * @name: a pointer to a string containing the name of the file to create.
  * @mode: the permission that the file should have
  * @parent: a pointer to the parent dentry for this file.  This should be a
-- 
1.6.3.2

