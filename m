Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYKBHqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYKBHqU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 02:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYKBHqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 02:46:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44029
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbYKBHqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 02:46:08 -0500
Date: Sun, 02 Nov 2008 00:45:43 -0700 (PDT)
Message-Id: <20081102.004543.74128246.davem@davemloft.net>
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


Couple of fixes:

1) Sparc32 build fix from Al Viro.

2) dbench over tmpfs OOPS fix on sparc64 from Hugh Dickins

3) PCI aperture MMAP fix on sparc64 from Max Dmitrichenko

4) Annoying build warning fix for sparc64 due to TASK_SIZE usage in
   compat ELF code

Please pull, thanks a lot!

The following changes since commit 770a424112cb2c3a3e39221299eaf5244b76479a:
  David S. Miller (1):
        sparc64: Add missing null terminating entry to bq4802_match[].

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Al Viro (1):
      sparc32: kernel/trace/trace.c wants DIE_OOPS

David S. Miller (1):
      sparc64: Kill annoying warning when building compat_binfmt_elf.o

Hugh Dickins (1):
      sparc64: Fix __copy_{to,from}_user_inatomic defines.

Max Dmitrichenko (1):
      sparc64: Fix PCI resource mapping on sparc64

 arch/sparc/include/asm/kdebug_32.h    |    1 +
 arch/sparc/include/asm/processor_64.h |    4 ++--
 arch/sparc/include/asm/uaccess_64.h   |    4 ++--
 arch/sparc64/kernel/pci.c             |   10 +++++++++-
 4 files changed, 14 insertions(+), 5 deletions(-)
