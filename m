Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbXGTJRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbXGTJRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 05:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXGTJR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 05:17:29 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:41157 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbXGTJR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 05:17:28 -0400
Date: Fri, 20 Jul 2007 18:17:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Trivial sh64 updates for 2.6.23-rc1
Message-ID: <20070720091707.GA26717@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh64-2.6.git

Which contains:

Paul Mundt (5):
      sh64: Wire up fallocate() syscall.
      sh64: Update cayman defconfig.
      sh64: Fix up PCI section mismatch warnings.
      sh64: Move entry point code to .text.head.
      sh64: Flag sh64_get_page() as __init_refok.

 arch/sh64/configs/cayman_defconfig |  158 ++++++++----------------------------
 arch/sh64/kernel/head.S            |    2 +-
 arch/sh64/kernel/pci_sh5.c         |    4 +-
 arch/sh64/kernel/syscalls.S        |    1 +
 arch/sh64/kernel/vmlinux.lds.S     |    1 +
 arch/sh64/mm/ioremap.c             |    2 +-
 include/asm-sh64/unistd.h          |    3 +-
 7 files changed, 41 insertions(+), 130 deletions(-)
