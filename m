Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0AODFo (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 22:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312Ab0AODFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 22:05:43 -0500
Received: from [206.15.93.42] ([206.15.93.42]:15481 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751911Ab0AODFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 22:05:43 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] inotify_user.c: make local symbol static
Date: Thu, 14 Jan 2010 20:05:46 -0700
Cc: john@johnmccutchan.com, rlove@rlove.org, eparis@parisplace.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001142005.46300.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify_user.c: make local symbol static

The symbol inotify_max_user_watches is only used locally
in this file. Make it static to prevent the following sparse warning:

warning: symbol 'inotify_max_user_watches ' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>

---

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 8271cf0..3c67691 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -50,7 +50,7 @@ static struct vfsmount *inotify_mnt __read_mostly;
 /* these are configurable via /proc/sys/fs/inotify/ */
 static int inotify_max_user_instances __read_mostly;
 static int inotify_max_queued_events __read_mostly;
-int inotify_max_user_watches __read_mostly;
+static int inotify_max_user_watches __read_mostly;
 
 static struct kmem_cache *inotify_inode_mark_cachep __read_mostly;
 struct kmem_cache *event_priv_cachep __read_mostly;
