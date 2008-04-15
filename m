Return-Path: <linux-kernel-owner+w=401wt.eu-S1764652AbYDORYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764652AbYDORYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbYDORYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:24:11 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:37372 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757721AbYDORYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:24:09 -0400
Date: Wed, 16 Apr 2008 02:23:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.25
Message-ID: <20080415172333.GA29489@linux-sh.org>
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
      sh64: add missing #include <asm/fpu.h>'s

Andrew Morton (2):
      sh: arch/sh/kernel/traps_32.c needs asm/fpu.h
      sh: export empty_zero_page

Manuel Lauss (1):
      sh: fix compressed kernel build

 arch/sh/boot/compressed/head_32.S |    1 -
 arch/sh/boot/compressed/head_64.S |    1 -
 arch/sh/kernel/process_64.c       |    1 +
 arch/sh/kernel/ptrace_64.c        |    1 +
 arch/sh/kernel/sh_ksyms_32.c      |    1 +
 arch/sh/kernel/sh_ksyms_64.c      |    1 +
 arch/sh/kernel/signal_64.c        |    1 +
 arch/sh/kernel/traps_32.c         |    1 +
 arch/sh/kernel/traps_64.c         |    1 +
 9 files changed, 7 insertions(+), 2 deletions(-)
