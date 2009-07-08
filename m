Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbZGHOqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbZGHOqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbZGHOqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:46:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:60537 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083AbZGHOqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:46:34 -0400
Subject: [PATCH 6/44] includecheck fix: arm, board-dm646x-evm.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:06:42 +0530
Message-Id: <1247063802.4382.23.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/mach-davinci/board-dm646x-evm.c: mach/common.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/mach-davinci/board-dm646x-evm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index e17de63..8657e72 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -47,7 +47,6 @@
 #include <mach/i2c.h>
 #include <mach/mmc.h>
 #include <mach/emac.h>
-#include <mach/common.h>
 
 #define DM646X_EVM_PHY_MASK		(0x2)
 #define DM646X_EVM_MDIO_FREQUENCY	(2200000) /* PHY bus frequency */
-- 
1.6.0.6



