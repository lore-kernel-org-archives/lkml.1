Return-Path: <linux-kernel-owner+w=401wt.eu-S965558AbXBFWN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965558AbXBFWN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965576AbXBFWN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:13:27 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39731 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965541AbXBFWNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:13:00 -0500
Date: Tue, 6 Feb 2007 23:13:04 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make kernel/time/timer_stats.c:nr_entries static
Message-ID: <20070206221304.GL27397@stusta.de>
References: <20070129001207.71ea3470.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129001207.71ea3470.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 12:12:07AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm1:
>...
> +add-debugging-feature-proc-timer_stat.patch
>...
>  New hrtimers/dynticks patches
>...


nr_entries can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-rc6-mm3/kernel/time/timer_stats.c.old	2007-02-06 10:27:13.000000000 +0100
+++ linux-2.6.20-rc6-mm3/kernel/time/timer_stats.c	2007-02-06 10:27:31.000000000 +0100
@@ -112,7 +112,7 @@
 #define MAX_ENTRIES_BITS	10
 #define MAX_ENTRIES		(1UL << MAX_ENTRIES_BITS)
 
-unsigned long nr_entries;
+static unsigned long nr_entries;
 static struct entry entries[MAX_ENTRIES];
 
 static atomic_t overflow_count;

