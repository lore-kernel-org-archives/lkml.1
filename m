Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbYKTPCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbYKTPCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbYKTOxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:53:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:58682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027AbYKTOxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:53:09 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] fdtable: export alloc_fd()
Date: Thu, 20 Nov 2008 23:52:16 +0900
Message-Id: <1227192740-10532-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227192740-10532-1-git-send-email-tj@kernel.org>
References: <1227192740-10532-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Nov 2008 14:52:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export alloc_fd().  Will be used by FUSE.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/file.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index f313314..806b3ad 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -487,6 +487,7 @@ out:
 	spin_unlock(&files->file_lock);
 	return error;
 }
+EXPORT_SYMBOL_GPL(alloc_fd);
 
 int get_unused_fd(void)
 {
-- 
1.5.6

