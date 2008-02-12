Return-Path: <linux-kernel-owner+w=401wt.eu-S1764132AbYBLUf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764132AbYBLUf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbYBLUfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:35:20 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:2340 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYBLUfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:35:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tKU+jtdX3TCSykyPJBl9tU9fMkkdgsg26Zd55QXBZ8rnKcscbB3TTyHWlvpxhiX2UBqnEwXzPpiSw9ASqO5PL27jR40NrE452Zl/5ATe8FaSIrrxvWaf0No7i5mFxNlOk8n3UxNzwzwqNkzlMyesCupDO8vF0NnQj4u0lw0JW+c=
Subject: [PATCH] x86: include prototype for no_broadcast in
	mach-default/setup.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 12:35:17 -0800
Message-Id: <1202848517.28953.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warning:
arch/x86/mach-default/setup.c:19:5: warning: symbol 'no_broadcast' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/mach-default/setup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
index 0c28a07..ba1e7bd 100644
--- a/arch/x86/mach-default/setup.c
+++ b/arch/x86/mach-default/setup.c
@@ -9,6 +9,7 @@
 #include <asm/arch_hooks.h>
 #include <asm/e820.h>
 #include <asm/setup.h>
+#include <asm/mach-default/mach_ipi.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 #define DEFAULT_SEND_IPI	(1)
-- 
1.5.4.1.1278.gc75be



