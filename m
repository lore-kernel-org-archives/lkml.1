Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbYAZQEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbYAZQEt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbYAZP4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:56:18 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757083AbYAZP4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:56:14 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 45/52] [microblaze] termbits.h termios.h
Date: Thu, 24 Jan 2008 16:03:20 +0100
Message-Id: <739e189a03021d2804f23d0774637a15038098bc.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
 <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
 <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
 <e173c10560cdf883ba3c7e639ca930f0627a2260.1201107832.git.monstr@monstr.eu>
 <155ee14d990137f7eb6fa76beee06c880c97e790.1201107832.git.monstr@monstr.eu>
 <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
 <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
 <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
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
index 0000000..cdc7ec1
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
+#ifndef _ASM_TERMBITS_H
+#define _ASM_TERMBITS_H
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
+#endif /* _ASM_TERMBITS_H */
diff --git a/include/asm-microblaze/termios.h b/include/asm-microblaze/termios.h
new file mode 100644
index 0000000..05488cf
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
+#ifndef _ASM_TERMIOS_H
+#define _ASM_TERMIOS_H
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
+#endif /* _ASM_TERMIOS_H */
-- 
1.5.4.rc4.14.g6fc74

