Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbXCDMpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbXCDMpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 07:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbXCDMpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 07:45:43 -0500
Received: from mail.queued.net ([207.210.101.209]:1942 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbXCDMpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 07:45:42 -0500
Message-ID: <45EABF71.3010106@debian.org>
Date: Sun, 04 Mar 2007 07:45:37 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] hrtimers: hrtimer_clock_base description typo
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/mixed;
 boundary="------------090609010506030409020208"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090609010506030409020208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The description for the hrtimer_clock_base struct describes
"hrtimer_base".  That should be hrtimer_clock_base.

(Resending; forgot to sign off)

Signed-off-by: Andres Salomon <dilinger@debian.org>

--------------090609010506030409020208
Content-Type: text/x-patch;
 name="hrtimer2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hrtimer2.patch"

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 3bef961..3000539 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -139,7 +139,7 @@ struct hrtimer_sleeper {
 };
 
 /**
- * struct hrtimer_base - the timer base for a specific clock
+ * struct hrtimer_clock_base - the timer base for a specific clock
  * @cpu_base:		per cpu clock base
  * @index:		clock type index for per_cpu support when moving a
  *			timer to a base on another cpu.

--------------090609010506030409020208--
