Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYJXAeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYJXAeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 20:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYJXAeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 20:34:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58021
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751221AbYJXAeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:34:12 -0400
Date: Thu, 23 Oct 2008 17:33:49 -0700 (PDT)
Message-Id: <20081023.173349.193701851.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several bug fixes and sparc support for checkstack:

1) Two math-emu fixes, one courtesy of Kumar Gala.

2) Section mismatch fixes for sparc32 from Frederic Weisbecker.

3) CPU startup locking fix from Andrea Shepard.

Please pull, thanks a lot!

The following changes since commit 2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4:
  Paul Mundt (1):
        binfmt_elf_fdpic: Update for cputime changes.

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Andrea Shepard (1):
      sparc64: Fix race in arch/sparc64/kernel/trampoline.S

David S. Miller (1):
      math-emu: Fix thinko in _FP_DIV

Frederic Weisbecker (2):
      sparc: correct section of apc_no_idle
      sparc: correct section of current_pc()

Kumar Gala (1):
      math-emu: Fix signalling of underflow and inexact while packing result.

Martin Habets (1):
      sparc: Add checkstack support

 arch/sparc/kernel/apc.c          |    2 +-
 arch/sparc/kernel/head.S         |    1 +
 arch/sparc64/kernel/trampoline.S |   18 ++++++++++++++----
 include/math-emu/op-common.h     |   19 +++++++++++++++----
 scripts/checkstack.pl            |    4 ++++
 5 files changed, 35 insertions(+), 9 deletions(-)
