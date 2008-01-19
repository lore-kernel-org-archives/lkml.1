Return-Path: <linux-kernel-owner+w=401wt.eu-S1763905AbYASCAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763905AbYASCAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 21:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764470AbYASB7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:59:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762790AbYASB7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:59:19 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 3/6] explicitly use sched.h include
Date: Fri, 18 Jan 2008 23:59:07 -0200
Message-Id: <12007079663929-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12007079613080-git-send-email-gcosta@redhat.com>
References: <1200707950911-git-send-email-gcosta@redhat.com> <12007079562927-git-send-email-gcosta@redhat.com> <12007079613080-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the sched.h header explicitly to lguest_user file,
and avoid depending on it being included somewhere else.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/lguest_user.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index a87fca6..85d42d3 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -6,6 +6,7 @@
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
+#include <linux/sched.h>
 #include "lg.h"
 
 /*L:055 When something happens, the Waker process needs a way to stop the
-- 
1.5.0.6

