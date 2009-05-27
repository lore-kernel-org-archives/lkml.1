Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbZE0Wgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbZE0Wgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759059AbZE0Wfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:35:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:57596 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773AbZE0Wf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:35:27 -0400
Date: Wed, 27 May 2009 22:34:47 GMT
From: tip-bot for Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, penberg@cs.helsinki.fi, eduard.munteanu@linux360.ro,
       tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.00.0905241112190.10296@rocky>
References: <alpine.DEB.2.00.0905241112190.10296@rocky>
Subject: [tip:tracing/core] kmemtrace: fix kernel parameter documentation
Message-ID: <tip-29fcefba8a2f0fea11e2b721fe174a1832801284@git.kernel.org>
Git-Commit-ID: 29fcefba8a2f0fea11e2b721fe174a1832801284
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 22:34:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29fcefba8a2f0fea11e2b721fe174a1832801284
Gitweb:     http://git.kernel.org/tip/29fcefba8a2f0fea11e2b721fe174a1832801284
Author:     Pekka Enberg <penberg@cs.helsinki.fi>
AuthorDate: Sun, 24 May 2009 11:13:17 +0300
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 26 May 2009 03:03:21 +0200

kmemtrace: fix kernel parameter documentation

The kmemtrace.enable kernel parameter no longer works. To enable
kmemtrace at boot-time, you must pass "ftrace=kmemtrace" instead.

[ Impact: remove obsolete kernel parameter documentation ]

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <alpine.DEB.2.00.0905241112190.10296@rocky>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 Documentation/kernel-parameters.txt |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e87bdbf..9243dd8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -56,7 +56,6 @@ parameter is applicable:
 	ISAPNP	ISA PnP code is enabled.
 	ISDN	Appropriate ISDN support is enabled.
 	JOY	Appropriate joystick support is enabled.
-	KMEMTRACE kmemtrace is enabled.
 	LIBATA  Libata driver is enabled
 	LP	Printer support is enabled.
 	LOOP	Loopback device support is enabled.
@@ -1054,15 +1053,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			use the HighMem zone if it exists, and the Normal
 			zone if it does not.
 
-	kmemtrace.enable=	[KNL,KMEMTRACE] Format: { yes | no }
-				Controls whether kmemtrace is enabled
-				at boot-time.
-
-	kmemtrace.subbufs=n	[KNL,KMEMTRACE] Overrides the number of
-			subbufs kmemtrace's relay channel has. Set this
-			higher than default (KMEMTRACE_N_SUBBUFS in code) if
-			you experience buffer overruns.
-
 	kgdboc=		[HW] kgdb over consoles.
 			Requires a tty driver that supports console polling.
 			(only serial suported for now)
