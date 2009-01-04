Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZADLAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZADLAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZADLAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:00:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:52062 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZADLAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:00:43 -0500
Subject: [PATCH -tip] x86: time_64.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:28:22 +0530
Message-Id: <1231066702.27852.23.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problem

Fixes style problem:
WARNING: Use #include <linux/nmi.h> instead of <asm/nmi.h>

total: 0 errors, 1 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/time_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index 891e7a7..e6e695a 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -17,10 +17,10 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/mca.h>
+#include <linux/nmi.h>
 
 #include <asm/i8253.h>
 #include <asm/hpet.h>
-#include <asm/nmi.h>
 #include <asm/vgtod.h>
 #include <asm/time.h>
 #include <asm/timer.h>
-- 
1.5.5.1



