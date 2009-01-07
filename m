Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbZAGNfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbZAGNfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZAGNfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:35:39 -0500
Received: from mx1.wp.pl ([212.77.101.5]:51926 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbZAGNfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:35:39 -0500
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ARM / AT91: fix NR_AIC_IRQS undeclared
Date: Wed, 7 Jan 2009 14:35:02 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Victor <linux@maxim.org.za>,
       Russell King <rmk+kernel@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901071435.03123.stf_xl@wp.pl>
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [ceNE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation error:
arch/arm/mach-at91/at91sam9263.c:312: error: 'NR_AIC_IRQS' undeclared here (not in a function)

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

diff --git a/arch/arm/mach-at91/at91sam9263.c b/arch/arm/mach-at91/at91sam9263.c
index ada4b67..24a9e44 100644
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@ -19,6 +19,7 @@
 #include <mach/at91_pmc.h>
 #include <mach/at91_rstc.h>
 #include <mach/at91_shdwc.h>
+#include <mach/irqs.h>
 
 #include "generic.h"
 #include "clock.h"
