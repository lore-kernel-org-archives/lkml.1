Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbYL3QiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbYL3QiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 11:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYL3QiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 11:38:03 -0500
Received: from casper.infradead.org ([85.118.1.10]:53771 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYL3QiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 11:38:02 -0500
Subject: [PATCH] x86: xsave.c: restore_user_xstate should be static
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Content-Type: text/plain
Date: Tue, 30 Dec 2008 22:05:55 +0530
Message-Id: <1230654955.13363.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
arch/x86/kernel/xsave.c:162:5: warning: symbol 'restore_user_xstate' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/xsave.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 15c3e69..2b54fe0 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -159,7 +159,7 @@ int save_i387_xstate(void __user *buf)
  * Restore the extended state if present. Otherwise, restore the FP/SSE
  * state.
  */
-int restore_user_xstate(void __user *buf)
+static int restore_user_xstate(void __user *buf)
 {
 	struct _fpx_sw_bytes fx_sw_user;
 	u64 mask;
-- 
1.6.0.4



