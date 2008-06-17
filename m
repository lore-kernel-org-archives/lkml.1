Return-Path: <linux-kernel-owner+w=401wt.eu-S1761154AbYFQWeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761154AbYFQWeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760197AbYFQWcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:32:25 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46813 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759300AbYFQWcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:32:24 -0400
Date: Wed, 18 Jun 2008 01:30:57 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh/boards/dreamcast/rtc.c: make 2 functions static
Message-ID: <20080617223057.GK25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global aica_rtc_{get,set}timeofday() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sh/boards/dreamcast/rtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

1716a5d5a29b5a2c16713e34465558cce3895545 diff --git a/arch/sh/boards/dreamcast/rtc.c b/arch/sh/boards/dreamcast/rtc.c
index b3a876a..a743368 100644
--- a/arch/sh/boards/dreamcast/rtc.c
+++ b/arch/sh/boards/dreamcast/rtc.c
@@ -30,7 +30,7 @@
  *
  * Grabs the current RTC seconds counter and adjusts it to the Unix Epoch.
  */
-void aica_rtc_gettimeofday(struct timespec *ts)
+static void aica_rtc_gettimeofday(struct timespec *ts)
 {
 	unsigned long val1, val2;
 
@@ -54,7 +54,7 @@ void aica_rtc_gettimeofday(struct timespec *ts)
  *
  * Adjusts the given @tv to the AICA Epoch and sets the RTC seconds counter.
  */
-int aica_rtc_settimeofday(const time_t secs)
+static int aica_rtc_settimeofday(const time_t secs)
 {
 	unsigned long val1, val2;
 	unsigned long adj = secs + TWENTY_YEARS;

