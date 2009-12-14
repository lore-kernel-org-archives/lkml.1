Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZLNAKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZLNAKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZLNAJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:09:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34964 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbZLMX6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:12 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, swhiteho@redhat.com, bmarzins@redhat.com,
       torvalds@linux-foundation.org
Subject: [PATCH 2/4] Constify struct kset_uevent_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:02 +0100
Message-Id: <6710f02ae2e61ac5f9d711c263fa1a5693fff998.1260663000.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663000.git.re.emese@gmail.com>
References: <cover.1260663000.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 fs/gfs2/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index c5dad1e..2d9b7ed 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -586,7 +586,7 @@ static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
 	return 0;
 }
 
-static struct kset_uevent_ops gfs2_uevent_ops = {
+static const struct kset_uevent_ops gfs2_uevent_ops = {
 	.uevent = gfs2_uevent,
 };
 
-- 
1.6.5.3

