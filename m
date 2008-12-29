Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbYL2Qoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbYL2Qoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYL2Qoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:44:46 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46104 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYL2Qoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:44:46 -0500
Subject: [PATCH] x86: bios_uv.c uv_systab should be static
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 22:12:50 +0530
Message-Id: <1230568970.26564.20.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
arch/x86/kernel/bios_uv.c:28:18: warning: symbol 'uv_systab' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/bios_uv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/bios_uv.c b/arch/x86/kernel/bios_uv.c
index 2a0a2a3..f638827 100644
--- a/arch/x86/kernel/bios_uv.c
+++ b/arch/x86/kernel/bios_uv.c
@@ -25,7 +25,7 @@
 #include <asm/uv/bios.h>
 #include <asm/uv/uv_hub.h>
 
-struct uv_systab uv_systab;
+static struct uv_systab uv_systab;
 
 s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
 {
-- 
1.5.5.1



