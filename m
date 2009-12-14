Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZLNAIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZLNAIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:08:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbZLNAIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:08:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34999 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbZLMX6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:16 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, penberg@cs.helsinki.fi,
       rientjes@google.com, cl@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [PATCH 3/4] Constify struct kset_uevent_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:03 +0100
Message-Id: <eff97be7c5839477c88f7ba61ef100f38c58bf7d.1260663000.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663000.git.re.emese@gmail.com>
References: <cover.1260663000.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 mm/slub.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 4996fc7..fb63aca 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4522,7 +4522,7 @@ static int uevent_filter(struct kset *kset, struct kobject *kobj)
 	return 0;
 }
 
-static struct kset_uevent_ops slab_uevent_ops = {
+static const struct kset_uevent_ops slab_uevent_ops = {
 	.filter = uevent_filter,
 };
 
-- 
1.6.5.3

