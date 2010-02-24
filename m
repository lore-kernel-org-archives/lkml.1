Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab0BXUWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:22:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758038Ab0BXUWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:22:20 -0500
Date: Wed, 24 Feb 2010 21:20:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] workqueues: s/2/WORK_STRUCT_STATIC/ in
	WORK_DATA_STATIC_INIT()
Message-ID: <20100224202038.GA26998@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cosmetic. Don't hide WORK_STRUCT_STATIC from grep.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/workqueue.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wq/include/linux/workqueue.h~3_STATIC_INIT_USE_STATIC	2010-02-24 20:33:43.000000000 +0100
+++ wq/include/linux/workqueue.h	2010-02-24 21:01:20.000000000 +0100
@@ -36,7 +36,7 @@ struct work_struct {
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
-#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(2)
+#define WORK_DATA_STATIC_INIT()	ATOMIC_LONG_INIT(1UL << WORK_STRUCT_STATIC)
 
 struct delayed_work {
 	struct work_struct work;

