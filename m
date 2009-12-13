Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZLMWJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZLMWJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbZLMWJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:09:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42307 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbZLMWJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:09:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/2] PM: rwsem.h need not be included into main.c
Date: Sun, 13 Dec 2009 23:09:32 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200912132306.57741.rjw@sisk.pl>
In-Reply-To: <200912132306.57741.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912132309.33054.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

It is not necessary to include <linux/rwsem.h> into
drivers/base/power/main.c, so don't do that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -23,7 +23,6 @@
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
 #include <linux/resume-trace.h>
-#include <linux/rwsem.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 
