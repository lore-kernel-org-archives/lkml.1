Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZLNAAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZLNAAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZLNAAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:00:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbZLMX6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:43 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, shemminger@vyatta.com,
       torvalds@linux-foundation.org, teigland@redhat.com
Subject: [PATCH 04/25] Constify struct sysfs_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:11 +0100
Message-Id: <f03a15670a182d88546d446560dd6b71fb549fe4.1260663004.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663004.git.re.emese@gmail.com>
References: <cover.1260663004.git.re.emese@gmail.com>
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
Acked-by: David Teigland <teigland@redhat.com>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
---
 fs/dlm/lockspace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index c010ecf..a8d8c59 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -148,7 +148,7 @@ static void lockspace_kobj_release(struct kobject *k)
 	kfree(ls);
 }
 
-static struct sysfs_ops dlm_attr_ops = {
+static const struct sysfs_ops dlm_attr_ops = {
 	.show  = dlm_attr_show,
 	.store = dlm_attr_store,
 };
-- 
1.6.5.3

