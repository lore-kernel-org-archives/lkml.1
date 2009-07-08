Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZGHOr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZGHOr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758496AbZGHOq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:46:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:52208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758559AbZGHOq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:46:58 -0400
Subject: [PATCH 7/44] includecheck fix: arm, board-sffsdr.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:07:26 +0530
Message-Id: <1247063846.4382.24.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/mach-davinci/board-sffsdr.c: mach/common.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/mach-davinci/board-sffsdr.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-sffsdr.c b/arch/arm/mach-davinci/board-sffsdr.c
index 748a8e4..7acdfd8 100644
--- a/arch/arm/mach-davinci/board-sffsdr.c
+++ b/arch/arm/mach-davinci/board-sffsdr.c
@@ -52,7 +52,6 @@
 #include <mach/serial.h>
 #include <mach/psc.h>
 #include <mach/mux.h>
-#include <mach/common.h>
 
 #define SFFSDR_PHY_MASK		(0x2)
 #define SFFSDR_MDIO_FREQUENCY	(2200000) /* PHY bus frequency */
-- 
1.6.0.6



