Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbZGHOtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbZGHOtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758986AbZGHOsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:48:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:52275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759290AbZGHOsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:48:11 -0400
Subject: [PATCH 14/44] includecheck fix: powerpc, mpc7450-pmu.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: benh@kernel.crashing.org, paulus@samba.org,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:17:27 +0530
Message-Id: <1247064447.4382.36.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/powerpc/kernel/mpc7450-pmu.c: linux/string.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/powerpc/kernel/mpc7450-pmu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/mpc7450-pmu.c b/arch/powerpc/kernel/mpc7450-pmu.c
index 75ff47f..c244133 100644
--- a/arch/powerpc/kernel/mpc7450-pmu.c
+++ b/arch/powerpc/kernel/mpc7450-pmu.c
@@ -10,7 +10,6 @@
  */
 #include <linux/string.h>
 #include <linux/perf_counter.h>
-#include <linux/string.h>
 #include <asm/reg.h>
 #include <asm/cputable.h>
 
-- 
1.6.0.6



