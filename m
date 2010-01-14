Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814Ab0ANVKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0ANVKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997Ab0ANVKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:10:53 -0500
Received: from [206.15.93.42] ([206.15.93.42]:1350 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753535Ab0ANVKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:10:52 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] posix-timers.c: don't export local functions
Date: Thu, 14 Jan 2010 14:10:50 -0700
Cc: tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141410.50675.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Thomas Gleixner <tglx@linutronix.de>

---

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4954407..00d1fda 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -256,7 +256,7 @@ static int posix_get_monotonic_coarse(clockid_t which_clock,
 	return 0;
 }
 
-int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
+static int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
 {
 	*tp = ktime_to_timespec(KTIME_LOW_RES);
 	return 0;
