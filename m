Return-Path: <linux-kernel-owner+w=401wt.eu-S1756963AbZJ1AXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbZJ1AXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 20:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbZJ1AXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 20:23:49 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54338 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbZJ1AXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 20:23:48 -0400
Date: Wed, 28 Oct 2009 09:23:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.32-rc6, part 2.
Message-ID: <20091028002345.GB27042@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.32

Which contains:

Lubomir Rintel (1):
      sh: Build fix: define more __movmem* symbols

Magnus Damm (2):
      sh: rsk7203 CONFIG_MTD=n fix
      sh: add uImage.bin target

Matt Fleming (1):
      sh: Check for return_to_handler when unwinding the stack

Paul Mundt (3):
      sh: __irq_entry annotate do_IRQ().
      sh: Document uImage.bin target in archhelp.
      sh: Fix hugetlbfs dependencies for SH-3 && MMU configurations.

 arch/sh/Kconfig                           |    5 +++++
 arch/sh/Makefile                          |    3 ++-
 arch/sh/boards/mach-rsk/devices-rsk7203.c |    4 ----
 arch/sh/boards/mach-rsk/setup.c           |   23 ++++++++++++++---------
 arch/sh/boot/Makefile                     |    6 +++++-
 arch/sh/kernel/dwarf.c                    |   22 ++++++++++++++++++++++
 arch/sh/kernel/irq.c                      |    3 ++-
 arch/sh/kernel/sh_ksyms_32.c              |   14 ++++++++++++++
 arch/sh/mm/Kconfig                        |    2 +-
 fs/Kconfig                                |    4 ++--
 10 files changed, 67 insertions(+), 19 deletions(-)
