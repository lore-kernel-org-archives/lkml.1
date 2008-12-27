Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYL0Gvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYL0Gvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 01:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYL0Gv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 01:51:29 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:40342 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbYL0Gv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 01:51:28 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dtor@mail.ru, henk.vergonet@gmail.com
Subject: [PATCH] linux/map_to_7segment.h: convert to __inline__ for userspace
Date: Sat, 27 Dec 2008 01:51:27 -0500
Message-Id: <1230360687-6739-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __inline__ rather than inline for map_to_seg7() since it is exported
to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 include/linux/map_to_7segment.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/map_to_7segment.h b/include/linux/map_to_7segment.h
index 7df8432..12d62a5 100644
--- a/include/linux/map_to_7segment.h
+++ b/include/linux/map_to_7segment.h
@@ -75,7 +75,7 @@ struct seg7_conversion_map {
 	unsigned char	table[128];
 };
 
-static inline int map_to_seg7(struct seg7_conversion_map *map, int c)
+static __inline__ int map_to_seg7(struct seg7_conversion_map *map, int c)
 {
 	return c >= 0 && c < sizeof(map->table) ? map->table[c] : -EINVAL;
 }
-- 
1.6.0.6

