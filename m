Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbZKRLhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbZKRLhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 06:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZKRLhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 06:37:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:39100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZKRLhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 06:37:11 -0500
Date: Wed, 18 Nov 2009 11:36:48 GMT
From: tip-bot for H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, yong.zhang0@gmail.com,
       hartleys@visionengravers.com, tglx@linutronix.de,
       hsweeten@visionengravers.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       hartleys@visionengravers.com, yong.zhang0@gmail.com,
       hsweeten@visionengravers.com
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901E24550@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901E24550@mi8nycmail19.Mi8.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents: Add missing include to pacify sparse
Message-ID: <tip-8e1a928a2ed7e8d5cad97c8e985294b4caedd168@git.kernel.org>
Git-Commit-ID: 8e1a928a2ed7e8d5cad97c8e985294b4caedd168
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e1a928a2ed7e8d5cad97c8e985294b4caedd168
Gitweb:     http://git.kernel.org/tip/8e1a928a2ed7e8d5cad97c8e985294b4caedd168
Author:     H Hartley Sweeten <hartleys@visionengravers.com>
AuthorDate: Fri, 16 Oct 2009 18:19:01 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 18 Nov 2009 12:31:48 +0100

clockevents: Add missing include to pacify sparse

Include "tick-internal.h" in order to pick up the extern function
prototype for clockevents_shutdown(). This quiets the following sparse
build noise:

  warning: symbol 'clockevents_shutdown' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
LKML-Reference: <BD79186B4FD85F4B8E60E381CAEE190901E24550@mi8nycmail19.Mi8.com>
Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: johnstul@us.ibm.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clockevents.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 05e8aee..20a8920 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -20,6 +20,8 @@
 #include <linux/sysdev.h>
 #include <linux/tick.h>
 
+#include "tick-internal.h"
+
 /* The registered clock event devices */
 static LIST_HEAD(clockevent_devices);
 static LIST_HEAD(clockevents_released);
