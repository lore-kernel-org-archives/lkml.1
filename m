Return-Path: <linux-kernel-owner+w=401wt.eu-S1765297AbYAUKTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765297AbYAUKTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 05:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759058AbYAUKDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 05:03:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759331AbYAUKDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 05:03:08 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 46/58] [GFS2] Remove unused variable
Date: Mon, 21 Jan 2008 09:22:04 +0000
Message-Id: <12009074213460-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <12009074192015-git-send-email-swhiteho@redhat.com>
References: <1200907336293-git-send-email-swhiteho@redhat.com>
 <12009073443813-git-send-email-swhiteho@redhat.com>
 <12009073453549-git-send-email-swhiteho@redhat.com>
 <1200907348435-git-send-email-swhiteho@redhat.com>
 <12009073492811-git-send-email-swhiteho@redhat.com>
 <12009073512300-git-send-email-swhiteho@redhat.com>
 <12009073531216-git-send-email-swhiteho@redhat.com>
 <12009073542596-git-send-email-swhiteho@redhat.com>
 <1200907356883-git-send-email-swhiteho@redhat.com>
 <12009073571991-git-send-email-swhiteho@redhat.com>
 <12009073591688-git-send-email-swhiteho@redhat.com>
 <12009073611695-git-send-email-swhiteho@redhat.com>
 <1200907362266-git-send-email-swhiteho@redhat.com>
 <12009073642512-git-send-email-swhiteho@redhat.com>
 <12009073662309-git-send-email-swhiteho@redhat.com>
 <12009073671755-git-send-email-swhiteho@redhat.com>
 <12009073698-git-send-email-swhiteho@redhat.com>
 <12009073701982-git-send-email-swhiteho@redhat.com>
 <12009073722253-git-send-email-swhiteho@redhat.com>
 <1200907374616-git-send-email-swhiteho@redhat.com>
 <12009073753723-git-send-email-swhiteho@redhat.com>
 <12009073771883-git-send-email-swhiteho@redhat.com>
 <1200907378664-git-send-email-swhiteho@redhat.com>
 <12009073803732-git-send-email-swhiteho@redhat.com>
 <12009073823161-git-send-email-swhiteho@redhat.com>
 <12009073841692-git-send-email-swhiteho@redhat.com>
 <12009073862261-git-send-email-swhiteho@redhat.com>
 <12009073883125-git-send-email-swhiteho@redhat.com>
 <12009073891848-git-send-email-swhiteho@redhat.com>
 <12009073913676-git-send-email-swhiteho@redhat.com>
 <12009073933630-git-send-email-swhiteho@redhat.com>
 <12009073953412-git-send-email-swhiteho@redhat.com>
 <1200907397123-git-send-email-swhiteho@redhat.com>
 <12009073981159-git-send-email-swhiteho@redhat.com>
 <12009074002775-git-send-email-swhiteho@redhat.com>
 <12009074021586-git-send-email-swhiteho@redhat.com>
 <12009074032614-git-send-email-swhiteho@redhat.com>
 <1200907405414-git-send-email-swhiteho@redhat.com>
 <12009074074196-git-send-email-swhiteho@redhat.com>
 <12009074082286-git-send-email-swhiteho@redhat.com>
 <12009074103982-git-send-email-swhiteho@redhat.com>
 <12009074121930-git-send-email-swhiteho@redhat.com>
 <12009074142128-git-send-email-swhiteho@redhat.com>
 <12009074163163-git-send-email-swhiteho@redhat.com>
 <1200907417194-git-send-email-swhiteho@redhat.com>
 <12009074192015-git-send-email-swhiteho@redhat.com>
Message-Id: <265b3e84047d5333b9d35417d136e15e80ecefba.1200905287.git.swhiteho@redhat.com>
In-Reply-To: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
References: <ba7d43779caabf7d3e6c62c3007564cdff351e40.1200905287.git.swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

The go_drop_th function is never called or referenced.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 9a83429..c85f4fd 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -131,7 +131,6 @@ struct gfs2_bufdata {
 struct gfs2_glock_operations {
 	void (*go_xmote_th) (struct gfs2_glock *gl);
 	void (*go_xmote_bh) (struct gfs2_glock *gl);
-	void (*go_drop_th) (struct gfs2_glock *gl);
 	void (*go_inval) (struct gfs2_glock *gl, int flags);
 	int (*go_demote_ok) (struct gfs2_glock *gl);
 	int (*go_lock) (struct gfs2_holder *gh);
-- 
1.5.1.2

