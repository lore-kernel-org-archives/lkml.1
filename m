Return-Path: <linux-kernel-owner+w=401wt.eu-S1030892AbXDQPwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030892AbXDQPwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031040AbXDQPwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:52:13 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:57746 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030892AbXDQPwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:52:12 -0400
Date: Wed, 18 Apr 2007 00:52:10 +0900 (JST)
Message-Id: <20070418.005210.37533591.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ralf@linux-mips.org
Subject: [PATCH 2/2] serial_txx9: Zap changelog from source code
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 509ace7..1deb576 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -15,31 +15,6 @@
  * published by the Free Software Foundation.
  *
  *  Serial driver for TX3927/TX4927/TX4925/TX4938 internal SIO controller
- *
- *  Revision History:
- *	0.30	Initial revision. (Renamed from serial_txx927.c)
- *	0.31	Use save_flags instead of local_irq_save.
- *	0.32	Support SCLK.
- *	0.33	Switch TXX9_TTY_NAME by CONFIG_SERIAL_TXX9_STDSERIAL.
- *		Support TIOCSERGETLSR.
- *	0.34	Support slow baudrate.
- *	0.40	Merge codes from mainstream kernel (2.4.22).
- *	0.41	Fix console checking in rs_shutdown_port().
- *		Disable flow-control in serial_console_write().
- *	0.42	Fix minor compiler warning.
- *	1.00	Kernel 2.6.  Converted to new serial core (based on 8250.c).
- *	1.01	Set fifosize to make tx_empry called properly.
- *		Use standard uart_get_divisor.
- *	1.02	Cleanup. (import 8250.c changes)
- *	1.03	Fix low-latency mode. (import 8250.c changes)
- *	1.04	Remove usage of deprecated functions, cleanup.
- *	1.05	More strict check in verify_port.  Cleanup.
- *	1.06	Do not insert a char caused previous overrun.
- *		Fix some spin_locks.
- *		Do not call uart_add_one_port for absent ports.
- *	1.07	Use CONFIG_SERIAL_TXX9_NR_UARTS.  Cleanup.
- *	1.08	Use platform_device.
- *		Fix and cleanup suspend/resume/initialization codes.
  */
 
 #if defined(CONFIG_SERIAL_TXX9_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
