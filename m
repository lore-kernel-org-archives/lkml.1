Return-Path: <linux-kernel-owner+w=401wt.eu-S1763081AbYFZM6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763081AbYFZM6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759584AbYFZMlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:41:24 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:22486 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759613AbYFZMlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:41:16 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 46/60] microblaze_v4: termbits.h termios.h
Date: Thu, 26 Jun 2008 14:30:15 +0200
Message-Id: <1214483429-32360-47-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-46-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
 <1214483429-32360-30-git-send-email-monstr@seznam.cz>
 <1214483429-32360-31-git-send-email-monstr@seznam.cz>
 <1214483429-32360-32-git-send-email-monstr@seznam.cz>
 <1214483429-32360-33-git-send-email-monstr@seznam.cz>
 <1214483429-32360-34-git-send-email-monstr@seznam.cz>
 <1214483429-32360-35-git-send-email-monstr@seznam.cz>
 <1214483429-32360-36-git-send-email-monstr@seznam.cz>
 <1214483429-32360-37-git-send-email-monstr@seznam.cz>
 <1214483429-32360-38-git-send-email-monstr@seznam.cz>
 <1214483429-32360-39-git-send-email-monstr@seznam.cz>
 <1214483429-32360-40-git-send-email-monstr@seznam.cz>
 <1214483429-32360-41-git-send-email-monstr@seznam.cz>
 <1214483429-32360-42-git-send-email-monstr@seznam.cz>
 <1214483429-32360-43-git-send-email-monstr@seznam.cz>
 <1214483429-32360-44-git-send-email-monstr@seznam.cz>
 <1214483429-32360-45-git-send-email-monstr@seznam.cz>
 <1214483429-32360-46-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-generic/termbits.h    |  200 +++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/termbits.h |    1 +
 include/asm-microblaze/termios.h  |   84 ++++++++++++++++
 3 files changed, 285 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/termbits.h
 create mode 100644 include/asm-microblaze/termbits.h
 create mode 100644 include/asm-microblaze/termios.h

diff --git a/include/asm-generic/termbits.h b/include/asm-generic/termbits.h
new file mode 100644
index 0000000..740b044
--- /dev/null
+++ b/include/asm-generic/termbits.h
@@ -0,0 +1,200 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_GENERIC_TERMBITS_H
+#define _ASM_GENERIC_TERMBITS_H
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
+#endif /* _ASM_GENERIC_TERMBITS_H */
diff --git a/include/asm-microblaze/termbits.h b/include/asm-microblaze/termbits.h
new file mode 100644
index 0000000..3935b10
--- /dev/null
+++ b/include/asm-microblaze/termbits.h
@@ -0,0 +1 @@
+#include <asm-generic/termbits.h>
diff --git a/include/asm-microblaze/termios.h b/include/asm-microblaze/termios.h
new file mode 100644
index 0000000..dd72e5d
--- /dev/null
+++ b/include/asm-microblaze/termios.h
@@ -0,0 +1,84 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
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

