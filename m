Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbYASB77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbYASB77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759158AbYASB7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:59:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761599AbYASB7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:59:17 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 2/6] explicitly use hrtimer.h include
Date: Fri, 18 Jan 2008 23:59:06 -0200
Message-Id: <12007079613080-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12007079562927-git-send-email-gcosta@redhat.com>
References: <1200707950911-git-send-email-gcosta@redhat.com> <12007079562927-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the hrtimer.h header explicitly to lg.h file,
and avoid depending on it being included somewhere else.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/lg.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index f9707cf..eb51fc2 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -8,6 +8,7 @@
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
 #include <linux/wait.h>
+#include <linux/hrtimer.h>
 #include <linux/err.h>
 #include <asm/semaphore.h>
 
-- 
1.5.0.6

