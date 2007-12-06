Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbXLFQIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbXLFQIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:08:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbXLFQHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:07:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:3515 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbXLFQHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:07:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Tzzg9UJNYDw1ec/6CVFEYPpO/hZddGTgdsI5in0ejN+lmVoBxv7qwLP6XrAc8r4qWjkYtaababLj1yuh8gr5gv+FSwSjHirXqsT97w1y3Fiv4RY+e7Lqh7G/e/T65rRvlOBTVfCbgolt0N9b4cnhelkaFKPfaEN05v00IRJ2yu4=
From: Denis Cheng <crquan@gmail.com>
To: linux-x25@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 15/20] net/lapb/lapb_iface.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Fri,  7 Dec 2007 00:07:18 +0800
Message-Id: <1196957239-5728-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/lapb/lapb_iface.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index a2e7aa6..2ba1bc4 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -39,7 +39,7 @@
 #include <linux/init.h>
 #include <net/lapb.h>
 
-static struct list_head lapb_list = LIST_HEAD_INIT(lapb_list);
+static LIST_HEAD(lapb_list);
 static DEFINE_RWLOCK(lapb_list_lock);
 
 /*
-- 
1.5.3.4

