Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYCUDlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYCUDlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 23:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYCUDlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 23:41:44 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:26954 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752954AbYCUDln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 23:41:43 -0400
Date: Fri, 21 Mar 2008 12:41:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.25-rc7
Message-ID: <20080321034124.GB16295@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.25.git

Which contains:

Franck Bui-Huu (1):
      sh: Use relative paths for mach/cpu symlinks.

Kieran Bingham (1):
      sh: Fix up the address error exception handler for SH-2.

Paul Mundt (3):
      sh: Fix up the timer IRQ definition for SH7203.
      sh: Fix uImage build error.
      sh: Fix more user header breakage from sh64 integration.

Robert P. J. Day (1):
      SH: Use newer, non-deprecated __SPIN_LOCK_UNLOCKED macro.

Yutaro Ebihara (1):
      serial: sh-sci: Fix fifo stall on SH7760/SH7780/SH7785 SCIF.

 arch/sh/Kconfig                |    1 +
 arch/sh/Makefile               |    8 ++++++--
 arch/sh/boot/Makefile          |    4 ++--
 arch/sh/kernel/cpu/sh2/entry.S |    1 -
 arch/sh/kernel/smp.c           |    2 +-
 drivers/serial/sh-sci.c        |    4 ++--
 include/asm-sh/byteorder.h     |   15 +++++++--------
 include/asm-sh/posix_types.h   |    6 ++++++
 8 files changed, 25 insertions(+), 16 deletions(-)
