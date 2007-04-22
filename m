Return-Path: <linux-kernel-owner+w=401wt.eu-S1030955AbXDVXOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030955AbXDVXOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030954AbXDVXOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:14:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59229 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030955AbXDVXOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:14:44 -0400
Date: Mon, 23 Apr 2007 01:14:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.49
Message-ID: <20070422231455.GA3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.48:

Adrian Bunk (2):
      Linux 2.6.16.49-rc1
      Linux 2.6.16.49

Ard van Breemen (1):
      start_kernel: test if irq's got enabled early, barf, and disable them again

Aristeu Sergio Rozanski Filho (1):
      tty_io: fix race in master pty close/slave pty close path

Aubrey Li (1):
      [NET]: Fix UDP checksum issue in net poll mode.

David S. Miller (3):
      [SCSI] QLOGICPTI: Do not unmap DMA unless we actually mapped something.
      [SPARC64]: Fix SBUS IOMMU allocation code.
      [SPARC64]: Fix arg passing to compat_sys_ipc().

Jean Delvare (1):
      hwmon/w83627ehf: Fix the fan5 clock divider write

Linas Vepstas (1):
      elevator: move clearing of unplug flag earlier

Olaf Kirch (1):
      [IrDA]: Correctly handling socket error

Tom Callaway (1):
      [SPARC64]: Fix inline directive in pci_iommu.c


 Makefile                        |    2 
 arch/sparc64/kernel/pci_iommu.c |    2 
 arch/sparc64/kernel/sbus.c      |  560 +++++++++++++-------------------
 arch/sparc64/kernel/sys32.S     |    1 
 arch/sparc64/kernel/systbls.S   |    2 
 block/elevator.c                |   11 
 drivers/char/tty_io.c           |   14 
 drivers/hwmon/w83627ehf.c       |    6 
 drivers/scsi/qlogicpti.c        |    2 
 init/main.c                     |    5 
 net/core/netpoll.c              |    7 
 net/irda/af_irda.c              |    3 
 12 files changed, 272 insertions(+), 343 deletions(-)

