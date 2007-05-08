Return-Path: <linux-kernel-owner+w=401wt.eu-S966662AbXEHSwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966662AbXEHSwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966222AbXEHSwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:52:00 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:29866 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754870AbXEHSvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:51:51 -0400
X-YMail-OSG: _2Qf54gVM1nOWvelbGJO5wl6l2SBlJ3F2AcaXljivlOyAW3p7eQjADNa.PpCYm76F9IrzFYDdg--
From: Chris Wedgwood <cw@f00f.org>
Date: Tue, 8 May 2007 11:37:26 -0700
Subject: [PATCH] [x86-64] Add getcpu and epoll_pwait system calls.
To: linux-kernel@vger.kernel.org
Message-Id: <20070508185145.B9A8E1827261@tuatara.stupidest.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Wedgwood <cw@f00f.org>
---
 include/asm-x86_64/unistd.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86_64/unistd.h b/include/asm-x86_64/unistd.h
index 26e23e0..aa7d4bf 100644
--- a/include/asm-x86_64/unistd.h
+++ b/include/asm-x86_64/unistd.h
@@ -619,6 +619,10 @@ __SYSCALL(__NR_sync_file_range, sys_sync_file_range)
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_getcpu		280
+__SYSCALL(__NR_getcpu, sys_getcpu)
+#define __NR_epoll_pwait	281
+__SYSCALL(__NR_epoll_pwait, sys_epoll_pwait)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
-- 
1.5.1.3

