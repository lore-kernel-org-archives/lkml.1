Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbZIDSSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbZIDSSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 14:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZIDSSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 14:18:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:44230 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757153AbZIDSSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 14:18:20 -0400
Subject: [PATCH] x86: includecheck fix traps.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 23:44:43 +0530
Message-Id: <1252088083.6385.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/x86/kernel/traps.c: asm/traps.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/traps.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ec13d2a..f91acf9 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -65,7 +65,6 @@
 #else
 #include <asm/processor-flags.h>
 #include <asm/setup.h>
-#include <asm/traps.h>
 
 asmlinkage int system_call(void);
 
-- 
1.6.0.6


