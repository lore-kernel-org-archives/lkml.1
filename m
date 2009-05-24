Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbZEXIQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbZEXIQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 04:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZEXIQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 04:16:41 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44445 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZEXIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 04:16:39 -0400
Date: Sun, 24 May 2009 11:13:17 +0300 (EEST)
From: Pekka Enberg <penberg@cs.helsinki.fi>
X-X-Sender: penberg@rocky
To: mingo@elte.hu
cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Subject: [PATCH] kmemtrace: fix kernel parameter documentation
Message-ID: <alpine.DEB.2.00.0905241112190.10296@rocky>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The kmemtrace.enable kernel parameter no longer works. To enable kmemtrace at
boot-time, you must pass "ftrace=kmemtrace" instead.

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
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
1.6.0.4

