Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbYFBRMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbYFBRMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYFBRLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:11:18 -0400
Received: from styx.suse.cz ([82.119.242.94]:55201 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753725AbYFBRLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:11:15 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Add explicit include of <linux/quota.h> into super.c
Date: Mon,  2 Jun 2008 19:11:09 +0200
Message-Id: <12124266723968-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124266722979-git-send-email-jack@suse.cz>
References: y
 <12124266712214-git-send-email-jack@suse.cz>
 <12124266711334-git-send-email-jack@suse.cz>
 <12124266712838-git-send-email-jack@suse.cz>
 <12124266722979-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need definitions from quota.h and so far we depended on fs.h to
include this file for us. This will be no longer true.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index ef50cbc..609df85 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -31,6 +31,7 @@
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/log2.h>
+#include <linux/quota.h>
 #include <asm/uaccess.h>
 #include "ext2.h"
 #include "xattr.h"
-- 
1.5.2.4

