Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYLDT7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYLDT7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYLDT6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:58:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54584
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751844AbYLDT6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:58:48 -0500
Date: Thu, 04 Dec 2008 11:58:49 -0800 (PST)
Message-Id: <20081204.115849.82772519.davem@davemloft.net>
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


Please pull to get these sparc bug fixes, thanks!

The following changes since commit f6f7b52e2f6149d2ee365717afff315b05720162:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../wim/linux-2.6-watchdog

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Chris Torek (1):
      sparc64: Fix bug in PTRACE_SETFPREGS64 handling.

Hong H. Pham (1):
      sparc64: Sync FPU state in VIS emulation handler.

Joseph Myers (1):
      sparc64: Fix VIS emulation bugs

Rusty Russell (1):
      sparc: asm/bitops.h should define __fls

 arch/sparc/include/asm/bitops_32.h |    1 +
 arch/sparc64/kernel/ptrace.c       |    2 +-
 arch/sparc64/kernel/visemul.c      |    6 ++++--
 3 files changed, 6 insertions(+), 3 deletions(-)
