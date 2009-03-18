Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbZCRVzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbZCRVzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758520AbZCRVn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:58 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758222AbZCRVnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:55 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 44/57] microblaze_v7: termbits.h termios.h
Date: Wed, 18 Mar 2009 21:31:11 +0100
Message-Id: <46a9b066a95fad763f6c12044dbc3cd580681fb9.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <7342f6af4eb95f5bc2cd89a196ab33a3ddc4d5c1.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
 <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
 <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
 <aa044d06327435cee76599fb6220630007f38ba7.1237407249.git.monstr@monstr.eu>
 <99fdae6e9b1da3ae5e2d3ebc841d1afdc694dfae.1237407249.git.monstr@monstr.eu>
 <29d86e7cd1124e596c9dde627f397ca98dccf572.1237407249.git.monstr@monstr.eu>
 <827e2a6a349e009f6c98f31178ce84042b0e2e10.1237407249.git.monstr@monstr.eu>
 <6eb167a9a027d644f10b843b8b1bde66e4c2ee25.1237407249.git.monstr@monstr.eu>
 <592d2a1c72581b6abf73841e640e7b7306c3ec3b.1237407249.git.monstr@monstr.eu>
 <fde2defbb60d9476df3aac0dc7d87241ed247d3e.1237407249.git.monstr@monstr.eu>
 <cde249b42d873cf948bd37d5e997307207de1bd3.1237407249.git.monstr@monstr.eu>
 <1165ce05edc67098d818cf42fd41a621868ab2a6.1237407249.git.monstr@monstr.eu>
 <35b0490d6a70779bdf2e2f55265c7c70a0dcbf1a.1237407249.git.monstr@monstr.eu>
 <1ca9913fc2b9ec220fdb9909f7929abfc38e41b1.1237407249.git.monstr@monstr.eu>
 <4a7e63a56ea0490013724ffddb9f824caafdcbc6.1237407249.git.monstr@monstr.eu>
 <6d67a197ab9f953b93ef151d9a4a198ba0730ef5.1237407249.git.monstr@monstr.eu>
 <d6fb0da1d4e4e5ac85ddca0ee61b81d3da8e95c5.1237407249.git.monstr@monstr.eu>
 <7342f6af4eb95f5bc2cd89a196ab33a3ddc4d5c1.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/termbits.h |  203 ++++++++++++++++++++++++++++++++
 arch/microblaze/include/asm/termios.h  |   88 ++++++++++++++
 2 files changed, 291 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/termbits.h
 create mode 100644 arch/microblaze/include/asm/termios.h

diff --git a/arch/microblaze/include/asm/termbits.h b/arch/microblaze/include/asm/termbits.h
new file mode 100644
index 0000000..a1b64bc
--- /dev/null
+++ b/arch/microblaze/include/asm/termbits.h
@@ -0,0 +1,203 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
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
+#define BOTHER		0010000
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
+#define IBSHIFT	16		/* Shift from CBAUD to CIBAUD */
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
diff --git a/arch/microblaze/include/asm/termios.h b/arch/microblaze/include/asm/termios.h
new file mode 100644
index 0000000..102d772
--- /dev/null
+++ b/arch/microblaze/include/asm/termios.h
@@ -0,0 +1,88 @@
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
+#ifdef __KERNEL__
+
+#include <asm-generic/termios.h>
+
+#endif	/* __KERNEL__ */
+
+#endif /* _ASM_MICROBLAZE_TERMIOS_H */
-- 
1.5.5.1

