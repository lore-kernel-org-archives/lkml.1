Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbYEIQXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbYEIQXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764972AbYEIQWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:22:25 -0400
Received: from saeurebad.de ([85.214.36.134]:37364 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764927AbYEIQWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:22:23 -0400
X-Mailbox-Line: From hannes@saeurebad.de Fri May  9 17:22:46 2008
Message-Id: <20080509152246.109754763@saeurebad.de>
References: <20080509151713.939253437@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 17:17:16 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/3] x86: Migrate X86_32 to bootmem2
Content-Disposition: inline; filename=migrate-x86_32-to-bootmem2.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight-forward migration to bootmem2 for x86 single-node systems.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -25,6 +25,7 @@
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
+	select HAVE_BOOTMEM2 if X86_32
 
 config DEFCONFIG_LIST
 	string

-- 

