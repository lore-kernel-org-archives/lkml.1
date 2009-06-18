Return-Path: <linux-kernel-owner+w=401wt.eu-S1759869AbZFRJ06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759869AbZFRJ06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 05:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbZFRJ0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 05:26:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:39884 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757199AbZFRJ0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 05:26:18 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] fdtable: export alloc_fd()
Date: Thu, 18 Jun 2009 18:24:30 +0900
Message-Id: <1245317073-24000-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245317073-24000-1-git-send-email-tj@kernel.org>
References: <1245317073-24000-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 09:24:49 +0000 (UTC)
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
1.6.0.2

