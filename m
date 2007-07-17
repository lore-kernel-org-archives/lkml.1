Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbXGQHt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbXGQHt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbXGQHti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:49:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50985 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbXGQHtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:49:36 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] alpha termios.h hadn't been updated
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Message-Id: <E1IAhoN-0001ih-QB@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 17 Jul 2007 08:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


... fortunately, termios and ktermios there are identical, so no
run-time breakage happened.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-alpha/termios.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-alpha/termios.h b/include/asm-alpha/termios.h
index 39e492c..fa13716 100644
--- a/include/asm-alpha/termios.h
+++ b/include/asm-alpha/termios.h
@@ -81,7 +81,7 @@ struct termio {
 
 #define user_termio_to_kernel_termios(a_termios, u_termio)			\
 ({										\
-	struct termios *k_termios = (a_termios);				\
+	struct ktermios *k_termios = (a_termios);				\
 	struct termio k_termio;							\
 	int canon, ret;								\
 										\
@@ -113,7 +113,7 @@ struct termio {
  */
 #define kernel_termios_to_user_termio(u_termio, a_termios)		\
 ({									\
-	struct termios *k_termios = (a_termios);			\
+	struct ktermios *k_termios = (a_termios);			\
 	struct termio k_termio;						\
 	int canon;							\
 									\
-- 
1.5.3.GIT


