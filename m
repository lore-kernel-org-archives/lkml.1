Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZADLCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZADLCD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:02:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbZADLBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:01:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZADLBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:01:53 -0500
Subject: [PATCH -tip] x86: ioport.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:29:32 +0530
Message-Id: <1231066772.27852.26.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems, more readable

Fixes style problems:
ERROR: "foo * bar" should be "foo *bar"

total: 2 errors, 0 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/ioport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 1919143..b12208f 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -35,8 +35,8 @@ static void set_bitmap(unsigned long *bitmap, unsigned int base,
  */
 asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
 {
-	struct thread_struct * t = &current->thread;
-	struct tss_struct * tss;
+	struct thread_struct *t = &current->thread;
+	struct tss_struct *tss;
 	unsigned int i, max_long, bytes, bytes_updated;
 
 	if ((from + num <= from) || (from + num > IO_BITMAP_BITS))
-- 
1.5.5.1



