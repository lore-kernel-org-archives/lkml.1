Return-Path: <linux-kernel-owner+w=401wt.eu-S1760210AbYBNBzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760210AbYBNBzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbYBNBzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:55:04 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:52493 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYBNBzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:55:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xw4vcRbLxq0nwzotORUZZbNGJGmAhLRRWpjDOfpks8wkyU9QPBetFc01zIixqUb93lqpTSOX7bh2yO4bE+euNVQ6NcjGQ1kCyvhLDAfdHH9s2C0ZNxAXlcbz/3WcoE7N0mMYsSwC8JIjZkU/6fM8tC0cZsofvzNdarhSc+fDTLk=
Subject: [PATCH] inotify: make variables static in inotify_user.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Robert Love <rml@novell.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 17:54:59 -0800
Message-Id: <1202954099.18204.44.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify_max_user_instances, inotify_max_user_watches, inotify_max_queued_events
can all be made static.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/inotify_user.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/inotify_user.c b/fs/inotify_user.c
index 3ab09a6..9ef4d21 100644
--- a/fs/inotify_user.c
+++ b/fs/inotify_user.c
@@ -41,9 +41,9 @@ static struct kmem_cache *event_cachep __read_mostly;
 static struct vfsmount *inotify_mnt __read_mostly;
 
 /* these are configurable via /proc/sys/fs/inotify/ */
-int inotify_max_user_instances __read_mostly;
-int inotify_max_user_watches __read_mostly;
-int inotify_max_queued_events __read_mostly;
+static int inotify_max_user_instances __read_mostly;
+static int inotify_max_user_watches __read_mostly;
+static int inotify_max_queued_events __read_mostly;
 
 /*
  * Lock ordering:
-- 
1.5.4.1.1278.gc75be



