Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbZGHQBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbZGHQBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZGHQBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:01:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:47136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZGHQBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:01:47 -0400
Subject: [PATCH 15/44] includecheck fix: powerpc, ppc970-pmu.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: benh@kernel.crashing.org, paulus@samba.org,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:20:22 +0530
Message-Id: <1247064622.4382.39.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



fix the following 'make includecheck' warning:

  arch/powerpc/kernel/ppc970-pmu.c: linux/string.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/powerpc/kernel/ppc970-pmu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index 6637c87..833097a 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -10,7 +10,6 @@
  */
 #include <linux/string.h>
 #include <linux/perf_counter.h>
-#include <linux/string.h>
 #include <asm/reg.h>
 #include <asm/cputable.h>
 
-- 
1.6.0.6



