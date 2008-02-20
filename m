Return-Path: <linux-kernel-owner+w=401wt.eu-S1763060AbYBTWOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763060AbYBTWOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYBTWNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:13:54 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:3684 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbYBTWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xWZGMscibfo3icidDgxVb44XiRixlBNhpnkGqPNmCP7jXHspmelauXxO10z7Turw0tNskI7JBqBj/VTkO3aG444AThkpIwVayXtFV/8oJELhcZFlWdZFe8we24k4RddjQpTazB41YIkaCw5MXmb3V9DAbtJu61PrGSZEDRTjZec=
Subject: [PATCH 1/2] moxa: make functions static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 14:14:04 -0800
Message-Id: <1203545644.25307.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All were forward declared static already.

Fixes sparse warnings:
drivers/char/moxa.c:1421:6: warning: symbol 'MoxaDriverInit' was not declared. Should it be static?
drivers/char/moxa.c:1464:6: warning: symbol 'MoxaPortFlushData' was not declared. Should it be static?
drivers/char/moxa.c:1477:5: warning: symbol 'MoxaDriverIoctl' was not declared. Should it be static?
drivers/char/moxa.c:1604:5: warning: symbol 'MoxaDriverPoll' was not declared. Should it be static?
drivers/char/moxa.c:1667:5: warning: symbol 'MoxaPortsOfCard' was not declared. Should it be static?
drivers/char/moxa.c:1954:5: warning: symbol 'MoxaPortIsValid' was not declared. Should it be static?
drivers/char/moxa.c:1964:6: warning: symbol 'MoxaPortEnable' was not declared. Should it be static?
drivers/char/moxa.c:1987:6: warning: symbol 'MoxaPortDisable' was not declared. Should it be static?
drivers/char/moxa.c:1997:6: warning: symbol 'MoxaPortGetMaxBaud' was not declared. Should it be static?
drivers/char/moxa.c:2007:6: warning: symbol 'MoxaPortSetBaud' was not declared. Should it be static?
drivers/char/moxa.c:2031:5: warning: symbol 'MoxaPortSetTermio' was not declared. Should it be static?
drivers/char/moxa.c:2087:5: warning: symbol 'MoxaPortGetLineOut' was not declared. Should it be static?
drivers/char/moxa.c:2107:6: warning: symbol 'MoxaPortLineCtrl' was not declared. Should it be static?
drivers/char/moxa.c:2122:6: warning: symbol 'MoxaPortFlowCtrl' was not declared. Should it be static?
drivers/char/moxa.c:2142:5: warning: symbol 'MoxaPortLineStatus' was not declared. Should it be static?
drivers/char/moxa.c:2168:5: warning: symbol 'MoxaPortDCDChange' was not declared. Should it be static?
drivers/char/moxa.c:2180:5: warning: symbol 'MoxaPortDCDON' was not declared. Should it be static?
drivers/char/moxa.c:2193:5: warning: symbol 'MoxaPortWriteData' was not declared. Should it be static?
drivers/char/moxa.c:2257:5: warning: symbol 'MoxaPortReadData' was not declared. Should it be static?
drivers/char/moxa.c:2327:5: warning: symbol 'MoxaPortTxQueue' was not declared. Should it be static?
drivers/char/moxa.c:2341:5: warning: symbol 'MoxaPortTxFree' was not declared. Should it be static?
drivers/char/moxa.c:2355:5: warning: symbol 'MoxaPortRxQueue' was not declared. Should it be static?
drivers/char/moxa.c:2370:6: warning: symbol 'MoxaPortTxDisable' was not declared. Should it be static?
drivers/char/moxa.c:2378:6: warning: symbol 'MoxaPortTxEnable' was not declared. Should it be static?
drivers/char/moxa.c:2387:5: warning: symbol 'MoxaPortResetBrkCnt' was not declared. Should it be static?
drivers/char/moxa.c:2396:6: warning: symbol 'MoxaPortSendBreak' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/moxa.c |   52 +++++++++++++++++++++++++-------------------------
 1 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 64b7b2b..75c957f 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -1418,7 +1418,7 @@ static int moxaloadc320(int, void __iomem *, int, int *);
  *	2. MoxaDriverIoctl(unsigned int cmd, unsigned long arg, int port);   *
  *	3. MoxaDriverPoll(void);					     *
  *****************************************************************************/
-void MoxaDriverInit(void)
+static void MoxaDriverInit(void)
 {
 	struct moxa_port *p;
 	unsigned int i;
@@ -1461,7 +1461,7 @@ struct dl_str {
 
 static struct dl_str dltmp;
 
-void MoxaPortFlushData(int port, int mode)
+static void MoxaPortFlushData(int port, int mode)
 {
 	void __iomem *ofsAddr;
 	if ((mode < 0) || (mode > 2))
@@ -1474,7 +1474,7 @@ void MoxaPortFlushData(int port, int mode)
 	}
 }
 
-int MoxaDriverIoctl(unsigned int cmd, unsigned long arg, int port)
+static int MoxaDriverIoctl(unsigned int cmd, unsigned long arg, int port)
 {
 	int i;
 	int status;
@@ -1601,7 +1601,7 @@ copy:
 	}
 }
 
-int MoxaDriverPoll(void)
+static int MoxaDriverPoll(void)
 {
 	struct moxa_board_conf *brd;
 	register ushort temp;
@@ -1664,7 +1664,7 @@ int MoxaDriverPoll(void)
  *	Card level function:						     *
  *	1. MoxaPortsOfCard(int cardno); 				     *
  *****************************************************************************/
-int MoxaPortsOfCard(int cardno)
+static int MoxaPortsOfCard(int cardno)
 {
 
 	if (moxa_boards[cardno].boardType == 0)
@@ -1951,7 +1951,7 @@ int MoxaPortsOfCard(int cardno)
  *                                send out a about 250 ms BREAK signal.
  *
  */
-int MoxaPortIsValid(int port)
+static int MoxaPortIsValid(int port)
 {
 
 	if (moxaCard == 0)
@@ -1961,7 +1961,7 @@ int MoxaPortIsValid(int port)
 	return (1);
 }
 
-void MoxaPortEnable(int port)
+static void MoxaPortEnable(int port)
 {
 	void __iomem *ofsAddr;
 	int MoxaPortLineStatus(int);
@@ -1984,7 +1984,7 @@ void MoxaPortEnable(int port)
 	MoxaPortLineStatus(port);
 }
 
-void MoxaPortDisable(int port)
+static void MoxaPortDisable(int port)
 {
 	void __iomem *ofsAddr = moxa_ports[port].tableAddr;
 
@@ -1994,7 +1994,7 @@ void MoxaPortDisable(int port)
 	moxafunc(ofsAddr, FC_DisableCH, Magic_code);
 }
 
-long MoxaPortGetMaxBaud(int port)
+static long MoxaPortGetMaxBaud(int port)
 {
 	if ((moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_ISA) ||
 	    (moxa_boards[port / MAX_PORTS_PER_BOARD].boardType == MOXA_BOARD_C320_PCI))
@@ -2004,7 +2004,7 @@ long MoxaPortGetMaxBaud(int port)
 }
 

-long MoxaPortSetBaud(int port, long baud)
+static long MoxaPortSetBaud(int port, long baud)
 {
 	void __iomem *ofsAddr;
 	long max, clock;
@@ -2028,7 +2028,7 @@ long MoxaPortSetBaud(int port, long baud)
 	return (baud);
 }
 
-int MoxaPortSetTermio(int port, struct ktermios *termio, speed_t baud)
+static int MoxaPortSetTermio(int port, struct ktermios *termio, speed_t baud)
 {
 	void __iomem *ofsAddr;
 	tcflag_t cflag;
@@ -2084,7 +2084,7 @@ int MoxaPortSetTermio(int port, struct ktermios *termio, speed_t baud)
 	return (baud);
 }
 
-int MoxaPortGetLineOut(int port, int *dtrState, int *rtsState)
+static int MoxaPortGetLineOut(int port, int *dtrState, int *rtsState)
 {
 
 	if (!MoxaPortIsValid(port))
@@ -2104,7 +2104,7 @@ int MoxaPortGetLineOut(int port, int *dtrState, int *rtsState)
 	return (0);
 }
 
-void MoxaPortLineCtrl(int port, int dtr, int rts)
+static void MoxaPortLineCtrl(int port, int dtr, int rts)
 {
 	void __iomem *ofsAddr;
 	int mode;
@@ -2119,7 +2119,7 @@ void MoxaPortLineCtrl(int port, int dtr, int rts)
 	moxafunc(ofsAddr, FC_LineControl, mode);
 }
 
-void MoxaPortFlowCtrl(int port, int rts, int cts, int txflow, int rxflow, int txany)
+static void MoxaPortFlowCtrl(int port, int rts, int cts, int txflow, int rxflow, int txany)
 {
 	void __iomem *ofsAddr;
 	int mode;
@@ -2139,7 +2139,7 @@ void MoxaPortFlowCtrl(int port, int rts, int cts, int txflow, int rxflow, int tx
 	moxafunc(ofsAddr, FC_SetFlowCtl, mode);
 }
 
-int MoxaPortLineStatus(int port)
+static int MoxaPortLineStatus(int port)
 {
 	void __iomem *ofsAddr;
 	int val;
@@ -2165,7 +2165,7 @@ int MoxaPortLineStatus(int port)
 	return (val);
 }
 
-int MoxaPortDCDChange(int port)
+static int MoxaPortDCDChange(int port)
 {
 	int n;
 
@@ -2177,7 +2177,7 @@ int MoxaPortDCDChange(int port)
 	return (n);
 }
 
-int MoxaPortDCDON(int port)
+static int MoxaPortDCDON(int port)
 {
 	int n;
 
@@ -2190,7 +2190,7 @@ int MoxaPortDCDON(int port)
 	return (n);
 }
 
-int MoxaPortWriteData(int port, unsigned char * buffer, int len)
+static int MoxaPortWriteData(int port, unsigned char * buffer, int len)
 {
 	int c, total, i;
 	ushort tail;
@@ -2254,7 +2254,7 @@ int MoxaPortWriteData(int port, unsigned char * buffer, int len)
 	return (total);
 }
 
-int MoxaPortReadData(int port, struct tty_struct *tty)
+static int MoxaPortReadData(int port, struct tty_struct *tty)
 {
 	register ushort head, pageofs;
 	int i, count, cnt, len, total, remain;
@@ -2324,7 +2324,7 @@ int MoxaPortReadData(int port, struct tty_struct *tty)
 }
 

-int MoxaPortTxQueue(int port)
+static int MoxaPortTxQueue(int port)
 {
 	void __iomem *ofsAddr;
 	ushort rptr, wptr, mask;
@@ -2338,7 +2338,7 @@ int MoxaPortTxQueue(int port)
 	return (len);
 }
 
-int MoxaPortTxFree(int port)
+static int MoxaPortTxFree(int port)
 {
 	void __iomem *ofsAddr;
 	ushort rptr, wptr, mask;
@@ -2352,7 +2352,7 @@ int MoxaPortTxFree(int port)
 	return (len);
 }
 
-int MoxaPortRxQueue(int port)
+static int MoxaPortRxQueue(int port)
 {
 	void __iomem *ofsAddr;
 	ushort rptr, wptr, mask;
@@ -2367,7 +2367,7 @@ int MoxaPortRxQueue(int port)
 }
 

-void MoxaPortTxDisable(int port)
+static void MoxaPortTxDisable(int port)
 {
 	void __iomem *ofsAddr;
 
@@ -2375,7 +2375,7 @@ void MoxaPortTxDisable(int port)
 	moxafunc(ofsAddr, FC_SetXoffState, Magic_code);
 }
 
-void MoxaPortTxEnable(int port)
+static void MoxaPortTxEnable(int port)
 {
 	void __iomem *ofsAddr;
 
@@ -2384,7 +2384,7 @@ void MoxaPortTxEnable(int port)
 }
 

-int MoxaPortResetBrkCnt(int port)
+static int MoxaPortResetBrkCnt(int port)
 {
 	ushort cnt;
 	cnt = moxa_ports[port].breakCnt;
@@ -2393,7 +2393,7 @@ int MoxaPortResetBrkCnt(int port)
 }
 

-void MoxaPortSendBreak(int port, int ms100)
+static void MoxaPortSendBreak(int port, int ms100)
 {
 	void __iomem *ofsAddr;
 
-- 
1.5.4.2.200.g99e75


