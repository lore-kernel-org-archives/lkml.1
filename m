Return-Path: <linux-kernel-owner+w=401wt.eu-S1422768AbXBGSyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768AbXBGSyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 13:54:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422800AbXBGSyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 13:54:41 -0500
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:33029 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422768AbXBGSyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 13:54:39 -0500
Message-ID: <45CA206C.2080205@kernel.org>
Date: Wed, 07 Feb 2007 10:54:36 -0800
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] rcutorture: Use ARRAY_SIZE macro when appropriate
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open-coded array size calculation with standard ARRAY_SIZE macro.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Signed-off-by: Josh Triplett <josh@kernel.org>
---
 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 482b11f..97c2277 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -899,7 +899,7 @@ rcu_torture_init(void)
 	/* Set up the freelist. */
 
 	INIT_LIST_HEAD(&rcu_torture_freelist);
-	for (i = 0; i < sizeof(rcu_tortures) / sizeof(rcu_tortures[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(rcu_tortures); i++) {
 		rcu_tortures[i].rtort_mbtest = 0;
 		list_add_tail(&rcu_tortures[i].rtort_free,
 			      &rcu_torture_freelist);
