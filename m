Return-Path: <linux-kernel-owner+w=401wt.eu-S966961AbZLIAT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966961AbZLIAT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966900AbZLIATz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:19:55 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:59172 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966710AbZLIATy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:19:54 -0500
To: apkm@linux-foundation.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Please pull bjdooks' i2c tree
From: Ben Dooks <ben-linux@fluff.org>
Message-Id: <E1NIAIw-0008IA-3S@teyla.home.fluff.org>
Date: Wed, 09 Dec 2009 00:21:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6035ccd8e9e40bb654fbfdef325902ab531679a5:
  Linus Torvalds (1):
        Merge branch 'for-2.6.33' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git next-i2c

Kevin Wells (1):
      i2c-pnx: Map I2C adapter number to platform ID number

Rajendra Nayak (1):
      i2c-omap: OMAP3: PM: (re)init for every transfer to support off-mode

Shinya Kuribayashi (23):
      i2c-designware: Consolidate to use 32-bit word accesses
      i2c-designware: Don't use the IC_CLR_INTR register to clear interrupts
      i2c-designware: Use platform_get_irq helper
      i2c-designware: i2c_dw_read: Use "struct dw_i2c_dev" pointer
      i2c-designware: i2c_dw_xfer_msg: Use "struct dw_i2c_dev" pointer
      i2c-designware: Remove an useless local variable "num"
      i2c-designware: Improved _HCNT/_LCNT calculation
      i2c-designware: i2c_dw_xfer_msg: Fix i2c_msg search bug
      i2c-designware: Process i2c_msg messages in the interrupt handler
      i2c-designware: Set Tx/Rx FIFO threshold levels
      i2c-designware: Enable RX_FULL interrupt
      i2c-designware: Divide i2c_dw_xfer_msg into two functions
      i2c-designware: i2c_dw_xfer_msg: Introduce a local "buf" pointer
      i2c-designware: Initialize byte count variables just prior to being used
      i2c-designware: i2c_dw_func: Set I2C_FUNC_SMBUS_foo bits
      i2c-designware: i2c_dw_read: Remove redundant target address checker
      i2c-designware: Process all i2c_msg messages in the interrupt handler
      i2c-designware: Disable TX_EMPTY when all i2c_msg msgs has been processed
      i2c-designware: i2c_dw_xfer_msg: Fix error handling procedures
      i2c-designware: Skip RX_FULL and TX_EMPTY bits on tx abort errors
      i2c-designware: Tx abort cleanups
      i2c-designware: Cosmetic cleanups
      i2c-designware: i2c_dw_handle_tx_abort: Use dev_dbg() for NOACK cases

 drivers/i2c/busses/i2c-designware.c |  488 +++++++++++++++++++++++++----------
 drivers/i2c/busses/i2c-omap.c       |   64 +++--
 drivers/i2c/busses/i2c-pnx.c        |    3 +-
 3 files changed, 398 insertions(+), 157 deletions(-)
