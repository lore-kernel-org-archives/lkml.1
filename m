Return-Path: <linux-kernel-owner+w=401wt.eu-S1765100AbYAaHlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765100AbYAaHlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754110AbYAaHlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:41:40 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56261 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYAaHlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:41:39 -0500
Date: Wed, 30 Jan 2008 23:48:37 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: PATCH] x86_64: fix comments in vmlinux_64.lds
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Message-id: <200801302348.37990.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: fix comments in vmlinux_64.lds

for bzImage, the vmlinux_64.lds still have s32 bit code, and startup_32 should
bt 0. fix the comment

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/boot/compressed/vmlinux_64.lds b/arch/x86/boot/compressed/vmlinux_64.lds
index f6e5b44..7e5c720 100644
--- a/arch/x86/boot/compressed/vmlinux_64.lds
+++ b/arch/x86/boot/compressed/vmlinux_64.lds
@@ -3,7 +3,7 @@ OUTPUT_ARCH(i386:x86-64)
 ENTRY(startup_64)
 SECTIONS
 {
-	/* Be careful parts of head_64.S assume startup_64 is at
+	/* Be careful parts of head_64.S assume startup_32 is at
 	 * address 0.
 	 */
 	. = 0;
