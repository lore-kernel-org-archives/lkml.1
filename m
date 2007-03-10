Return-Path: <linux-kernel-owner+w=401wt.eu-S1750888AbXCJVds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbXCJVds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbXCJVds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:33:48 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:49755 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbXCJVdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:33:47 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 16:31:06 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Delete unused header file.
Message-ID: <Pine.LNX.4.64.0703101629430.27973@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-13.463, required 5, ALL_TRUSTED -1.80, BAYES_00 -15.00,
	FUZZY_XPILL 3.34)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Delete apparently unused header file drivers/char/digi.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  not sure who the proper maintainer is on this one.


diff --git a/drivers/char/digi.h b/drivers/char/digi.h
deleted file mode 100644
index 19df0e8..0000000
--- a/drivers/char/digi.h
+++ /dev/null
@@ -1,71 +0,0 @@
-/*          Definitions for DigiBoard ditty(1) command.                 */
-
-#if !defined(TIOCMODG)
-#define	TIOCMODG	(('d'<<8) | 250)		/* get modem ctrl state	*/
-#define	TIOCMODS	(('d'<<8) | 251)		/* set modem ctrl state	*/
-#endif
-
-#if !defined(TIOCMSET)
-#define	TIOCMSET	(('d'<<8) | 252)		/* set modem ctrl state	*/
-#define	TIOCMGET	(('d'<<8) | 253)		/* set modem ctrl state	*/
-#endif
-
-#if !defined(TIOCMBIC)
-#define	TIOCMBIC	(('d'<<8) | 254)		/* set modem ctrl state */
-#define	TIOCMBIS	(('d'<<8) | 255)		/* set modem ctrl state */
-#endif
-
-#if !defined(TIOCSDTR)
-#define	TIOCSDTR	(('e'<<8) | 0)		/* set DTR		*/
-#define	TIOCCDTR	(('e'<<8) | 1)		/* clear DTR		*/
-#endif
-
-/************************************************************************
- * Ioctl command arguments for DIGI parameters.
- ************************************************************************/
-#define DIGI_GETA	(('e'<<8) | 94)		/* Read params		*/
-
-#define DIGI_SETA	(('e'<<8) | 95)		/* Set params		*/
-#define DIGI_SETAW	(('e'<<8) | 96)		/* Drain & set params	*/
-#define DIGI_SETAF	(('e'<<8) | 97)		/* Drain, flush & set params */
-
-#define	DIGI_GETFLOW	(('e'<<8) | 99)		/* Get startc/stopc flow */
-						/* control characters 	 */
-#define	DIGI_SETFLOW	(('e'<<8) | 100)		/* Set startc/stopc flow */
-						/* control characters	 */
-#define	DIGI_GETAFLOW	(('e'<<8) | 101)		/* Get Aux. startc/stopc */
-						/* flow control chars 	 */
-#define	DIGI_SETAFLOW	(('e'<<8) | 102)		/* Set Aux. startc/stopc */
-						/* flow control chars	 */
-
-struct	digiflow_struct {
-	unsigned char	startc;				/* flow cntl start char	*/
-	unsigned char	stopc;				/* flow cntl stop char	*/
-};
-
-typedef struct digiflow_struct digiflow_t;
-
-
-/************************************************************************
- * Values for digi_flags
- ************************************************************************/
-#define DIGI_IXON	0x0001		/* Handle IXON in the FEP	*/
-#define DIGI_FAST	0x0002		/* Fast baud rates		*/
-#define RTSPACE		0x0004		/* RTS input flow control	*/
-#define CTSPACE		0x0008		/* CTS output flow control	*/
-#define DSRPACE		0x0010		/* DSR output flow control	*/
-#define DCDPACE		0x0020		/* DCD output flow control	*/
-#define DTRPACE		0x0040		/* DTR input flow control	*/
-#define DIGI_FORCEDCD	0x0100		/* Force carrier		*/
-#define	DIGI_ALTPIN	0x0200		/* Alternate RJ-45 pin config	*/
-#define	DIGI_AIXON	0x0400		/* Aux flow control in fep	*/
-
-
-/************************************************************************
- * Structure used with ioctl commands for DIGI parameters.
- ************************************************************************/
-struct digi_struct {
-	unsigned short	digi_flags;		/* Flags (see above)	*/
-};
-
-typedef struct digi_struct digi_t;

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
