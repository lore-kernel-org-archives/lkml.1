Return-Path: <linux-kernel-owner+w=401wt.eu-S2992718AbXEBE32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992718AbXEBE32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992726AbXEBE3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:29:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:24904 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992728AbXEBE2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:28:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=mdfHR26IDjfn+eiHhJX+9oUTJBTIYQcDyd9m5bz793N+aOdF8Dm7AyzLXLUjcsnUC
	FY+n+u0GjBsU7bvJq3HBQ==
Date: Tue, 1 May 2007 21:28:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Geoff Levand <geoffrey.levand@am.sony.com>, linux-kernel@vger.kernel.org
Subject: [patch 09/10] powerpc: ps3: use __attribute_unused__
In-Reply-To: <Pine.LNX.4.64.0705012123330.19277@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705012124060.19277@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012119370.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120130.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012120470.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012121350.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012122120.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012122480.19277@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0705012123330.19277@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace function instances of __attribute__ ((unused)) with
__attribute_unused__.

Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/powerpc/platforms/ps3/interrupt.c |    4 ++--
 arch/powerpc/platforms/ps3/time.c      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -434,7 +434,7 @@ static void _dump_64_bmp(const char *header, const u64 *p, unsigned cpu,
 		*p & 0xffff);
 }
 
-static void __attribute__ ((unused)) _dump_256_bmp(const char *header,
+static void __attribute_unused__ _dump_256_bmp(const char *header,
 	const u64 *p, unsigned cpu, const char* func, int line)
 {
 	pr_debug("%s:%d: %s %u {%016lx:%016lx:%016lx:%016lx}\n",
@@ -453,7 +453,7 @@ static void _dump_bmp(struct ps3_private* pd, const char* func, int line)
 }
 
 #define dump_mask(_x) _dump_mask(_x, __func__, __LINE__)
-static void __attribute__ ((unused)) _dump_mask(struct ps3_private* pd,
+static void __attribute_unused__ _dump_mask(struct ps3_private* pd,
 	const char* func, int line)
 {
 	unsigned long flags;
diff --git a/arch/powerpc/platforms/ps3/time.c b/arch/powerpc/platforms/ps3/time.c
--- a/arch/powerpc/platforms/ps3/time.c
+++ b/arch/powerpc/platforms/ps3/time.c
@@ -39,7 +39,7 @@ static void _dump_tm(const struct rtc_time *tm, const char* func, int line)
 }
 
 #define dump_time(_a) _dump_time(_a, __func__, __LINE__)
-static void __attribute__ ((unused)) _dump_time(int time, const char* func,
+static void __attribute_unused__ _dump_time(int time, const char* func,
 	int line)
 {
 	struct rtc_time tm;
