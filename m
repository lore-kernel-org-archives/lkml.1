Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0BFNca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 08:32:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab0BFNc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 08:32:28 -0500
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       smfrench@gmail.com, ebiederm@xmission.com, petr@vandrovec.name
Subject: [PATCH] dcache: export d_hash_and_lookup
Date: Sat,  6 Feb 2010 08:32:23 -0500
Message-Id: <1265463143-3074-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filesystems occasionally need to the same sort of hash the name and
then do a lookup operation (for instance, in readdir routines). Export
d_hash_and_lookup to make that code more compact.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Steve French <smfrench@gmail.com>
---
 fs/dcache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 953173a..0f427e6 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2334,6 +2334,7 @@ EXPORT_SYMBOL(d_find_alias);
 EXPORT_SYMBOL(d_instantiate);
 EXPORT_SYMBOL(d_invalidate);
 EXPORT_SYMBOL(d_lookup);
+EXPORT_SYMBOL(d_hash_and_lookup);
 EXPORT_SYMBOL(d_move);
 EXPORT_SYMBOL_GPL(d_materialise_unique);
 EXPORT_SYMBOL(d_path);
-- 
1.6.6

