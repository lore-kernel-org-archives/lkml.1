Return-Path: <linux-kernel-owner+w=401wt.eu-S1751053AbYKMJjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbYKMJjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYKMJi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:38:57 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:25366 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751635AbYKMJiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:38:55 -0500
Date: Thu, 13 Nov 2008 18:37:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.28-rc5
Message-ID: <20081113093755.GA25999@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.28

Which contains:

Francesco VIRLINZI (1):
      sh: Fixed the TMU0 reload value on resume

Magnus Damm (2):
      i2c: fix i2c-sh_mobile rx underrun
      sh: early printk port type fix

Paul Mundt (4):
      sh: Handle fixmap TLB eviction more coherently.
      sh: Provide a sane valid_phys_addr_range() to prevent TLB reset with PMB.
      sh: Don't factor in PAGE_OFFSET for valid_phys_addr_range() check.
      serial: sh-sci: Reorder the SCxTDR write after the TDxE clear.

Stuart MENEFY (1):
      sh: __copy_user function can corrupt the stack in case of exception

Yoshihiro Shimoda (3):
      serial: sh-sci: fix cannot work SH7723 SCIFA
      fix sci type for SH7723
      usb: r8a66597-hcd: fix wrong data access in SuperH on-chip USB

 arch/sh/include/asm/io.h               |    4 ++++
 arch/sh/include/asm/pgtable.h          |    6 ++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c |    6 +++---
 arch/sh/kernel/early_printk.c          |    3 ++-
 arch/sh/kernel/timers/timer-tmu.c      |    2 +-
 arch/sh/lib/copy_page.S                |   11 ++++++++---
 arch/sh/mm/Makefile_32                 |    2 +-
 arch/sh/mm/Makefile_64                 |    2 +-
 arch/sh/mm/init.c                      |   12 +++++++++---
 arch/sh/mm/mmap.c                      |   31 +++++++++++++++++++++++++++++++
 arch/sh/mm/pg-sh4.c                    |   17 +++++++++++++++++
 drivers/i2c/busses/i2c-sh_mobile.c     |    3 ++-
 drivers/serial/sh-sci.c                |   22 ++++++++++++----------
 drivers/serial/sh-sci.h                |   16 ++++++++--------
 drivers/usb/host/r8a66597-hcd.c        |    5 +++--
 include/linux/serial_core.h            |    3 +++
 16 files changed, 111 insertions(+), 34 deletions(-)
 create mode 100644 arch/sh/mm/mmap.c
