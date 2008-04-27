Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbYD0EA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbYD0EA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 00:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbYD0EAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 00:00:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:61081 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYD0EAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 00:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=s9zaB8LCZc8LIkgvEpWNOssYSgnCyBB5781KEUebrSfWHtU8eIMJzJXH2bNFpUZtVdcEbrGG69FIuRVJ59rxshVD0Wmw2wK+XF7gY4M/GbIn7g9u/CD/oBt+dc9FKXhhIAagE4bo7J5q9ZRiGGBy5f1u4zGnle0CMcmEEXFSJd0=
Subject: [PATCH] x86: !x & y typo in mtrr code
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 21:00:17 -0700
Message-Id: <1209268817.14173.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As written, this can never be true.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 353efe4..5d241ce 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -90,7 +90,7 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	 * Look of multiple ranges matching this address and pick type
 	 * as per MTRR precedence
 	 */
-	if (!mtrr_state.enabled & 2) {
+	if (!(mtrr_state.enabled & 2)) {
 		return mtrr_state.def_type;
 	}
 
-- 
1.5.5.1.270.g89765



