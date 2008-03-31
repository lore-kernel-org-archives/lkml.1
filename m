Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYCaHUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYCaHUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 03:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYCaHUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 03:20:22 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:19683 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753344AbYCaHUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 03:20:20 -0400
Date: Mon, 31 Mar 2008 16:20:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.25-rc8
Message-ID: <20080331072009.GC16398@linux-sh.org>
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

Adrian Bunk (1):
      remove include/asm-sh/floppy.h

Paul Mundt (2):
      sh: Fix occasional FPU register corruption under preempt.
      sh: Fix TIF_USEDFPU clearing under FPU emulation.

Yoshihiro Shimoda (1):
      sh: Fix up uImage compression type

 arch/sh/Kconfig               |    3 -
 arch/sh/boot/Makefile         |    2 +-
 arch/sh/kernel/cpu/sh2a/fpu.c |    1 +
 arch/sh/kernel/cpu/sh4/fpu.c  |    1 +
 arch/sh/kernel/cpu/sh5/fpu.c  |    1 +
 arch/sh/kernel/dump_task.c    |    1 +
 arch/sh/kernel/process_32.c   |    1 +
 arch/sh/kernel/signal_32.c    |    1 +
 include/asm-sh/floppy.h       |  268 -----------------------------------------
 include/asm-sh/fpu.h          |   39 ++++---
 include/asm-sh/processor.h    |    1 -
 include/asm-sh/processor_32.h |    1 +
 include/asm-sh/processor_64.h |    1 +
 13 files changed, 33 insertions(+), 288 deletions(-)
 delete mode 100644 include/asm-sh/floppy.h
