Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbYEEIJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbYEEIJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYEEIJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:09:08 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:37319 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752742AbYEEIJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:09:04 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 43/56] microblaze_v2: termbits.h termios.h
Date: Sun,  4 May 2008 13:41:32 +0200
Message-Id: <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
 <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
 <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
 <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
 <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
 <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
 <d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>
 <27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>
 <64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>
 <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/termbits.h |  203 +++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/termios.h  |   86 ++++++++++++++++
 2 files changed, 289 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/termbits.h
 create mode 100644 include/asm-microblaze/termios.h

diff --git a/include/asm-microblaze/termbits.h b/include/asm-microblaze/termbits.h
new file mode 100644
index 0000000..695f370
--- /dev/null
+++ b/include/asm-microblaze/termbits.h
@@ -0,0 +1,203 @@
+/*
+ * include/asm-microblaze/termbits.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_TERMBITS_H
+#define _ASM_MICROBLAZE_TERMBITS_H
+
+#include <linux/posix_types.h>
+
+typedef unsigned char	cc_t;
+typedef unsigned int	speed_t;
+typedef unsigned int	tcflag_t;
+
+#define NCCS 19
+struct termios {
+	tcflag_t c_iflag; /* input mode flags */
+	tcflag_t c_oflag; /* output mode flags */
+	tcflag_t c_cflag; /* control mode flags */
+	tcflag_t c_lflag; /* local mode flags */
+	cc_t c_line; /* line discipline */
+	cc_t c_cc[NCCS]; /* control characters */
+};
+
+struct ktermios {
+	tcflag_t c_iflag; /* input mode flags */
+	tcflag_t c_oflag; /* output mode flags */
+	tcflag_t c_cflag; /* control mode flags */
+	tcflag_t c_lflag; /* local mode flags */
+	cc_t c_line; /* line discipline */
+	cc_t c_cc[NCCS]; /* control characters */
+	speed_t c_ispeed; /* input speed */
+	speed_t c_ospeed; /* output speed */
+};
+
+
+/* c_cc characters */
+
+#define VINTR 0
+#define VQUIT 1
+#define VERASE 2
+#define VKILL 3
+#define VEOF 4
+#define VTIME 5
+#define VMIN 6
+#define VSWTC 7
+#define VSTART 8
+#define VSTOP 9
+#define VSUSP 10
+#define VEOL 11
+#define VREPRINT 12
+#define VDISCARD 13
+#define VWERASE 14
+#define VLNEXT 15
+#define VEOL2 16
+
+/* c_iflag bits */
+
+#define IGNBRK	0000001
+#define BRKINT	0000002
+#define IGNPAR	0000004
+#define PARMRK	0000010
+#define INPCK	0000020
+#define ISTRIP	0000040
+#define INLCR	0000100
+#define IGNCR	0000200
+#define ICRNL	0000400
+#define IUCLC	0001000
+#define IXON	0002000
+#define IXANY	0004000
+#define IXOFF	0010000
+#define IMAXBEL	0020000
+#define IUTF8	0040000
+
+/* c_oflag bits */
+
+#define OPOST	0000001
+#define OLCUC	0000002
+#define ONLCR	0000004
+#define OCRNL	0000010
+#define ONOCR	0000020
+#define ONLRET	0000040
+#define OFILL	0000100
+#define OFDEL	0000200
+#define NLDLY	0000400
+#define NL0	0000000
+#define NL1	0000400
+#define CRDLY	0003000
+#define CR0	0000000
+#define CR1	0001000
+#define CR2	0002000
+#define CR3	0003000
+#define TABDLY	0014000
+#define TAB0	0000000
+#define TAB1	0004000
+#define TAB2	0010000
+#define TAB3	0014000
+#define XTABS	0014000
+#define BSDLY	0020000
+#define BS0	0000000
+#define BS1	0020000
+#define VTDLY	0040000
+#define VT0	0000000
+#define VT1	0040000
+#define FFDLY	0100000
+#define FF0	0000000
+#define FF1	0100000
+
+/* c_cflag bit meaning */
+
+#define CBAUD	0010017
+#define B0	0000000 /* hang up */
+#define B50	0000001
+#define B75	0000002
+#define B110	0000003
+#define B134	0000004
+#define B150	0000005
+#define B200	0000006
+#define B300	0000007
+#define B600	0000010
+#define B1200	0000011
+#define B1800	0000012
+#define B2400	0000013
+#define B4800	0000014
+#define B9600	0000015
+#define B19200	0000016
+#define B38400	0000017
+#define EXTA B19200
+#define EXTB B38400
+#define CSIZE	0000060
+#define CS5	0000000
+#define CS6	0000020
+#define CS7	0000040
+#define CS8	0000060
+#define CSTOPB	0000100
+#define CREAD	0000200
+#define PARENB	0000400
+#define PARODD	0001000
+#define HUPCL	0002000
+#define CLOCAL	0004000
+#define CBAUDEX	0010000
+#define B57600	0010001
+#define B115200	0010002
+#define B230400	0010003
+#define B460800	0010004
+#define B500000	0010005
+#define B576000	0010006
+#define B921600	0010007
+#define B1000000	0010010
+#define B1152000	0010011
+#define B1500000	0010012
+#define B2000000	0010013
+#define B2500000	0010014
+#define B3000000	0010015
+#define B3500000	0010016
+#define B4000000	0010017
+#define CIBAUD		002003600000 /* input baud rate (not used) */
+#define CMSPAR		010000000000 /* mark or space (stick) parity */
+#define CRTSCTS		020000000000 /* flow control */
+
+/* c_lflag bits */
+
+#define ISIG	0000001
+#define ICANON	0000002
+#define XCASE	0000004
+#define ECHO	0000010
+#define ECHOE	0000020
+#define ECHOK	0000040
+#define ECHONL	0000100
+#define NOFLSH	0000200
+#define TOSTOP	0000400
+#define ECHOCTL	0001000
+#define ECHOPRT	0002000
+#define ECHOKE	0004000
+#define FLUSHO	0010000
+#define PENDIN	0040000
+#define IEXTEN	0100000
+
+/* tcflow() and TCXONC use these */
+
+#define	TCOOFF		0
+#define	TCOON		1
+#define	TCIOFF		2
+#define	TCION		3
+
+/* tcflush() and TCFLSH use these */
+
+#define	TCIFLUSH	0
+#define	TCOFLUSH	1
+#define	TCIOFLUSH	2
+
+/* tcsetattr uses these */
+
+#define	TCSANOW		0
+#define	TCSADRAIN	1
+#define	TCSAFLUSH	2
+
+#endif /* _ASM_MICROBLAZE_TERMBITS_H */
diff --git a/include/asm-microblaze/termios.h b/include/asm-microblaze/termios.h
new file mode 100644
index 0000000..61ac2cf
--- /dev/null
+++ b/include/asm-microblaze/termios.h
@@ -0,0 +1,86 @@
+/*
+ * include/asm-microblaze/termios.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_TERMIOS_H
+#define _ASM_MICROBLAZE_TERMIOS_H
+
+#include <linux/string.h>
+#include <asm/termbits.h>
+#include <asm/ioctls.h>
+
+struct winsize {
+	unsigned short ws_row;
+	unsigned short ws_col;
+	unsigned short ws_xpixel;
+	unsigned short ws_ypixel;
+};
+
+#define NCC 8
+struct termio {
+	unsigned short c_iflag; /* input mode flags */
+	unsigned short c_oflag; /* output mode flags */
+	unsigned short c_cflag; /* control mode flags */
+	unsigned short c_lflag; /* local mode flags */
+	unsigned char c_line; /* line discipline */
+	unsigned char c_cc[NCC]; /* control characters */
+};
+
+#ifdef __KERNEL__
+/*	intr=^C		quit=^|		erase=del	kill=^U
+	eof=^D		vtime=\0	vmin=\1		sxtc=\0
+	start=^Q	stop=^S		susp=^Z		eol=\0
+	reprint=^R	discard=^U	werase=^W	lnext=^V
+	eol2=\0
+*/
+#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
+#endif
+
+/* Modem lines */
+
+#define TIOCM_LE	0x001
+#define TIOCM_DTR	0x002
+#define TIOCM_RTS	0x004
+#define TIOCM_ST	0x008
+#define TIOCM_SR	0x010
+#define TIOCM_CTS	0x020
+#define TIOCM_CAR	0x040
+#define TIOCM_RNG	0x080
+#define TIOCM_DSR	0x100
+#define TIOCM_CD	TIOCM_CAR
+#define TIOCM_RI	TIOCM_RNG
+#define TIOCM_OUT1	0x2000
+#define TIOCM_OUT2	0x4000
+#define TIOCM_LOOP	0x8000
+
+/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
+
+/* Line disciplines */
+
+#define N_TTY		0
+#define N_SLIP		1
+#define N_MOUSE		2
+#define N_PPP		3
+#define N_STRIP		4
+#define N_AX25		5
+#define N_X25		6 /* X.25 async */
+#define N_6PACK		7
+#define N_MASC		8 /* Reserved for Mobitex module <kaz@cafe.net> */
+#define N_R3964		9 /* Reserved for Simatic R3964 module */
+#define N_PROFIBUS_FDL	10 /* Reserved for Profibus <Dave@mvhi.com> */
+#define N_IRDA		11 /* Linux IR - http://irda.sourceforge.net/ */
+#define N_SMSBLOCK	12 /* SMS block mode - for talking to GSM data cards
+				about SMS messages */
+#define N_HDLC		13 /* synchronous HDLC */
+#define N_SYNC_PPP	14
+#define N_HCI		15 /* Bluetooth HCI UART */
+
+#include <asm-generic/termios.h>
+
+#endif /* _ASM_MICROBLAZE_TERMIOS_H */
-- 
1.5.4.GIT

