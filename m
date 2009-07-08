Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZGHQCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZGHQCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732AbZGHQCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:02:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:53060 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756238AbZGHQCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:02:39 -0400
Subject: [PATCH 19/44] includecheck fix: x86, traps.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:28:14 +0530
Message-Id: <1247065094.4382.49.camel@ht.satnam>
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
index 5204332..de96b50 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -64,7 +64,6 @@
 #else
 #include <asm/processor-flags.h>
 #include <asm/setup.h>
-#include <asm/traps.h>
 
 asmlinkage int system_call(void);
 
-- 
1.6.0.6



