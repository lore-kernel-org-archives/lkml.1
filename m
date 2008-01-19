Return-Path: <linux-kernel-owner+w=401wt.eu-S1764887AbYASB7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764887AbYASB7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760884AbYASB7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:59:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757317AbYASB7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:59:14 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/6] explicitly use ktime.h include
Date: Fri, 18 Jan 2008 23:59:05 -0200
Message-Id: <12007079562927-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1200707950911-git-send-email-gcosta@redhat.com>
References: <1200707950911-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ktime.h header explicitly to hypercalls file,
and avoid depending on it being included somewhere else.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/hypercalls.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/lguest/hypercalls.c b/drivers/lguest/hypercalls.c
index 32666d0..0f2cb4f 100644
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -23,6 +23,7 @@
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
 #include <linux/mm.h>
+#include <linux/ktime.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include "lg.h"
-- 
1.5.0.6

