Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbZGHOrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbZGHOrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758554AbZGHOrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:47:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:52227 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758536AbZGHOrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:47:13 -0400
Subject: [PATCH 9/44] includecheck fix: arm, mach-omap1/mcbsp.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Kevin Hilman <khilman@deeprootsystems.com>, tony@atomide.com
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:10:02 +0530
Message-Id: <1247064002.4382.27.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/mach-omap1/mcbsp.c: mach/irqs.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/mach-omap1/mcbsp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap1/mcbsp.c b/arch/arm/mach-omap1/mcbsp.c
index a2d7814..505d98c 100644
--- a/arch/arm/mach-omap1/mcbsp.c
+++ b/arch/arm/mach-omap1/mcbsp.c
@@ -19,7 +19,6 @@
 
 #include <mach/irqs.h>
 #include <mach/dma.h>
-#include <mach/irqs.h>
 #include <mach/mux.h>
 #include <mach/cpu.h>
 #include <mach/mcbsp.h>
-- 
1.6.0.6



