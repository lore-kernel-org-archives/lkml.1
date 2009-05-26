Return-Path: <linux-kernel-owner+w=401wt.eu-S1754279AbZEZCFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbZEZCFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 22:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZEZCE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 22:04:58 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34158 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZEZCE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 22:04:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nVF2CaaLbT5fRmqhc51dH104oDa9hLqX0I03E5kE+F09tXmSw7Q9RtunHIU5x4MAV3
         SFWEvwU3vNeQ/D0WF2rSstG+8zvlnM1dmIvvkghV3Itt1tgAxLCVHqCGoG0ed4Z67O5w
         EFOoO6LCFZFzRMOZU/agxPGZBPpeNYtUQPmxg=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] kmemtrace: fix kernel parameter documentation
Date: Tue, 26 May 2009 04:04:48 +0200
Message-Id: <1243303490-8019-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
References: <1243303490-8019-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

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
-- 
1.6.2.3

