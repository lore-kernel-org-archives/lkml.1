Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZGHOqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZGHOqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbZGHOpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:45:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:60497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbZGHOpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:45:52 -0400
Subject: [PATCH 1/44] includecheck fix: arm, misc.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:00:15 +0530
Message-Id: <1247063415.4382.14.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/arm/boot/compressed/misc.c: linux/compiler.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/arm/boot/compressed/misc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
index 9e6e512..17153b5 100644
--- a/arch/arm/boot/compressed/misc.c
+++ b/arch/arm/boot/compressed/misc.c
@@ -29,7 +29,6 @@ unsigned int __machine_arch_type;
 
 static void putstr(const char *ptr);
 
-#include <linux/compiler.h>
 #include <mach/uncompress.h>
 
 #ifdef CONFIG_DEBUG_ICEDCC
-- 
1.6.0.6



