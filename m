Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbZFRRtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbZFRRtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758177AbZFRRtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:49:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:52295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbZFRRtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:49:05 -0400
Subject: [PATCH 3/4 -tip V2] x86: asm/termios.h remove irrelevant comment
 for userspace
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1245347118.2481.13.camel@ht.satnam>
References: <1245314365.31204.7.camel@ht.satnam>
	 <1245346986.2481.10.camel@ht.satnam>  <1245347082.2481.12.camel@ht.satnam>
	 <1245347118.2481.13.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 23:15:57 +0530
Message-Id: <1245347157.2481.14.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


following comment is irrelevant at usr/include/asm/termios.h :

"ioctl (fd, TIOCSERGETLSR, &result) where result may be as below"

Also fixed some alignment and space issues.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/termios.h |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/termios.h b/arch/x86/include/asm/termios.h
index c4ee805..ee6f0c8 100644
--- a/arch/x86/include/asm/termios.h
+++ b/arch/x86/include/asm/termios.h
@@ -5,20 +5,20 @@
 #include <asm/ioctls.h>
 
 struct winsize {
-	unsigned short ws_row;
-	unsigned short ws_col;
-	unsigned short ws_xpixel;
-	unsigned short ws_ypixel;
+	unsigned short	ws_row;
+	unsigned short	ws_col;
+	unsigned short	ws_xpixel;
+	unsigned short	ws_ypixel;
 };
 
 #define NCC 8
 struct termio {
-	unsigned short c_iflag;		/* input mode flags */
-	unsigned short c_oflag;		/* output mode flags */
-	unsigned short c_cflag;		/* control mode flags */
-	unsigned short c_lflag;		/* local mode flags */
-	unsigned char c_line;		/* line discipline */
-	unsigned char c_cc[NCC];	/* control characters */
+	unsigned short	c_iflag;	/* input mode flags	*/
+	unsigned short	c_oflag;	/* output mode flags	*/
+	unsigned short	c_cflag;	/* control mode flags	*/
+	unsigned short	c_lflag;	/* local mode flags	*/
+	unsigned char	c_line;		/* line discipline	*/
+	unsigned char	c_cc[NCC];	/* control characters	*/
 };
 
 /* modem lines */
@@ -37,10 +37,10 @@ struct termio {
 #define TIOCM_OUT2	0x4000
 #define TIOCM_LOOP	0x8000
 
-/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
-
 #ifdef __KERNEL__
 
+/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
+
 #include <asm/uaccess.h>
 
 /*	intr=^C		quit=^\		erase=del	kill=^U
@@ -110,5 +110,4 @@ static inline int kernel_termios_to_user_termios_1(struct termios __user *u,
 }
 
 #endif	/* __KERNEL__ */
-
 #endif /* _ASM_X86_TERMIOS_H */
-- 
1.6.0.6



