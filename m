Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136AbYFIMK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbYFIMK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 08:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbYFIMKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 08:10:42 -0400
Received: from ozlabs.org ([203.10.76.45]:51624 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217AbYFIMKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 08:10:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18509.7599.970933.555379@cargo.ozlabs.ibm.com>
Date: Mon, 9 Jun 2008 22:10:23 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get 4 more bug-fix commits, plus one from Stephen Rothwell that
changes one place where we do sprintf(pci_name(dev), ... to use
dev_set_name() instead, so that we don't end up with an error when a
change that is in Greg KH's tree (changing pci_name(dev) to be const)
hits your tree.

Thanks,
Paul.

 arch/powerpc/boot/Makefile      |    4 ++--
 arch/powerpc/kernel/pci_64.c    |    2 +-
 arch/powerpc/kernel/signal_64.c |    4 +++-
 arch/powerpc/mm/mem.c           |    3 +--
 drivers/net/Kconfig             |    2 +-
 include/linux/memory_hotplug.h  |   16 ++++++++--------
 6 files changed, 16 insertions(+), 15 deletions(-)

Adrian Bunk (1):
      [POWERPC] boot/Makefile CONFIG_ variable fixes

Benjamin Herrenschmidt (1):
      [POWERPC] Fix incorrect enabling of VMX when building signal or user context

Nathan Lynch (2):
      [POWERPC] Make walk_memory_resource available with MEMORY_HOTPLUG=n
      [POWERPC] ehea: Remove dependency on MEMORY_HOTPLUG

Stephen Rothwell (1):
      [POWERPC] Use dev_set_name in pci_64.c

