Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbXD2Kz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbXD2Kz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbXD2Kxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:53:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:51327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318AbXD2Kx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:27 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: Parag Warudkar <parag.warudkar@gmail.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [36/48] i386: get rid of unused variables
Message-Id: <20070429105326.1CB02151C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Parag Warudkar <parag.warudkar@gmail.com>

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/apm.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux/arch/i386/kernel/apm.c
===================================================================
--- linux.orig/arch/i386/kernel/apm.c
+++ linux/arch/i386/kernel/apm.c
@@ -384,13 +384,6 @@ static int			ignore_sys_suspend;
 static int			ignore_normal_resume;
 static int			bounce_interval __read_mostly = DEFAULT_BOUNCE_INTERVAL;
 
-#ifdef CONFIG_APM_RTC_IS_GMT
-#	define	clock_cmos_diff	0
-#	define	got_clock_diff	1
-#else
-static long			clock_cmos_diff;
-static int			got_clock_diff;
-#endif
 static int			debug __read_mostly;
 static int			smp __read_mostly;
 static int			apm_disabled = -1;
