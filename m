Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZG1Vpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZG1Vpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbZG1Vpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:45:34 -0400
Received: from kroah.org ([198.145.64.141]:55421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395AbZG1Vpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:45:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>, Jason Baron <jbaron@redhat.com>,
       Greg Banks <gnb@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] Dynamic debug: fix typo: -/->
Date: Tue, 28 Jul 2009 14:44:39 -0700
Message-Id: <1248817481-13372-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090728213826.GC13090@kroah.com>
References: <20090728213826.GC13090@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

The member was intended, not the local variable.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Greg Banks <gnb@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dynamic_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 833139c..e22c148 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -164,7 +164,7 @@ static void ddebug_change(const struct ddebug_query *query,
 
 			if (!newflags)
 				dt->num_enabled--;
-			else if (!dp-flags)
+			else if (!dp->flags)
 				dt->num_enabled++;
 			dp->flags = newflags;
 			if (newflags) {
-- 
1.6.3.2

