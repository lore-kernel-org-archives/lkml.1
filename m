Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbZD3Pqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbZD3Pqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762497AbZD3PmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:57798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbZD3PmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:06 -0400
Message-Id: <6c161ff4d3b30207c754420dc569df0013fae59a.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 15 Apr 2009 17:28:25 +0200
Subject: [PATCH 22/27] microblaze: don't include asm/mmu.h in hw_exception_handler
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX18nehLN6Hpw6Ixaza34ke1W6RZ0PcEQm7VVHlR
 OcY7G7BdtEIEOaLp0IG53yC1uPiE3NL9TOzcWgTbttJJiSaOpu
 aqoR/9GeRdixWeZCMLg7A==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic mmu.h is not safe for use in assembly, but
also doesn't contain anything that microblaze needs
there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/kernel/hw_exception_handler.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/hw_exception_handler.S b/arch/microblaze/kernel/hw_exception_handler.S
index cf9486d..2c01e80 100644
--- a/arch/microblaze/kernel/hw_exception_handler.S
+++ b/arch/microblaze/kernel/hw_exception_handler.S
@@ -66,7 +66,6 @@
 #include <asm/current.h>
 #include <linux/linkage.h>
 
-#include <asm/mmu.h>
 #include <asm/pgtable.h>
 #include <asm/asm-offsets.h>
 
-- 
1.5.6.3


