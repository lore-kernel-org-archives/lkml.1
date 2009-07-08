Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbZGHOsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbZGHOsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758766AbZGHOrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:47:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:52246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758880AbZGHOrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:47:35 -0400
Subject: [PATCH 10/44] includecheck fix: arm, mach-omap2/mcbsp.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       tony@atomide.com
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:11:05 +0530
Message-Id: <1247064065.4382.28.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/mach-omap2/mcbsp.c: mach/irqs.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/mach-omap2/mcbsp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/mcbsp.c b/arch/arm/mach-omap2/mcbsp.c
index a5c0f04..99b6e15 100644
--- a/arch/arm/mach-omap2/mcbsp.c
+++ b/arch/arm/mach-omap2/mcbsp.c
@@ -19,7 +19,6 @@
 
 #include <mach/irqs.h>
 #include <mach/dma.h>
-#include <mach/irqs.h>
 #include <mach/mux.h>
 #include <mach/cpu.h>
 #include <mach/mcbsp.h>
-- 
1.6.0.6



