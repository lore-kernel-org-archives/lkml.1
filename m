Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0CAPSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:18:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab0CAPSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:18:01 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/5] GFS2: print glock numbers in hex
Date: Mon,  1 Mar 2010 15:08:26 +0000
Message-Id: <1267456106-3084-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1267456106-3084-5-git-send-email-swhiteho@redhat.com>
References: <1267456106-3084-1-git-send-email-swhiteho@redhat.com>
 <1267456106-3084-2-git-send-email-swhiteho@redhat.com>
 <1267456106-3084-3-git-send-email-swhiteho@redhat.com>
 <1267456106-3084-4-git-send-email-swhiteho@redhat.com>
 <1267456106-3084-5-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes glock numbers from printing in decimal to hex.
Since DLM prints corresponding resource IDs in hex, it makes debugging
easier.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/glock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 4773f90..454d4b4 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1658,7 +1658,7 @@ static int __dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 	dtime *= 1000000/HZ; /* demote time in uSec */
 	if (!test_bit(GLF_DEMOTE, &gl->gl_flags))
 		dtime = 0;
-	gfs2_print_dbg(seq, "G:  s:%s n:%u/%llu f:%s t:%s d:%s/%llu a:%d r:%d\n",
+	gfs2_print_dbg(seq, "G:  s:%s n:%u/%llx f:%s t:%s d:%s/%llu a:%d r:%d\n",
 		  state2str(gl->gl_state),
 		  gl->gl_name.ln_type,
 		  (unsigned long long)gl->gl_name.ln_number,
-- 
1.6.2.5

