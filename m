Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYIEF7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYIEF7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 01:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYIEF7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 01:59:43 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:51821 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120AbYIEF7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 01:59:42 -0400
Date: Fri, 5 Sep 2008 14:59:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.27-rc6
Message-ID: <20080905055912.GB2051@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.27

Which contains:

Adrian Bunk (2):
      sh64: re-add the __strnlen_user() prototype
      sh: fix ptrace_64.c:user_disable_single_step()

Carmelo Amoroso (1):
      sh: resume_kernel fix for kernel oops built with CONFIG_BKL_PREEMPT=y.

Magnus Damm (6):
      sh: crash kernel resource fix
      sh: fix kexec entry point for crash kernels
      sh: fix platform_resource_setup_memory() section mismatch
      sh: update Migo-R defconfig
      sh: update AP325RXA defconfig
      i2c: fix i2c-sh_mobile timing issues

Paul Mundt (1):
      sh64: resume_kernel fix for kernel oops built with CONFIG_BKL_PREEMPT=y.

Yoshihiro Shimoda (1):
      sh: fix semtimedop syscall

 arch/sh/configs/ap325rxa_defconfig |   22 ++--
 arch/sh/configs/migor_defconfig    |   21 ++-
 arch/sh/include/asm/uaccess_64.h   |    2 +
 arch/sh/kernel/cpu/sh5/entry.S     |   14 +--
 arch/sh/kernel/entry-common.S      |   27 +---
 arch/sh/kernel/machine_kexec.c     |    2 +-
 arch/sh/kernel/ptrace_64.c         |    2 +
 arch/sh/kernel/setup.c             |    6 +-
 arch/sh/kernel/sys_sh.c            |    2 +-
 arch/sh/mm/consistent.c            |    6 +-
 drivers/i2c/busses/i2c-sh_mobile.c |  271 +++++++++++++++++++++++++++---------
 11 files changed, 250 insertions(+), 125 deletions(-)
