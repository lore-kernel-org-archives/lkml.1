Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbZGHOqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbZGHOqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbZGHOqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:46:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757679AbZGHOqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:46:09 -0400
Subject: [PATCH 3/44] includecheck fix: arm, board-dm355-evm.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:03:08 +0530
Message-Id: <1247063588.4382.18.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/mach-davinci/board-dm355-evm.c: mach/common.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/mach-davinci/board-dm355-evm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 5ac2f56..d6ab64c 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -37,7 +37,6 @@
 #include <mach/serial.h>
 #include <mach/nand.h>
 #include <mach/mmc.h>
-#include <mach/common.h>
 
 #define DAVINCI_ASYNC_EMIF_CONTROL_BASE		0x01e10000
 #define DAVINCI_ASYNC_EMIF_DATA_CE0_BASE	0x02000000
-- 
1.6.0.6



