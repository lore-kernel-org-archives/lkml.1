Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbZCMFU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbZCMFU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZCMFUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:20:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:37543 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZCMFUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:20:47 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 16:19:25 +1100
Message-Id: <1236921565.25062.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

So here's the new ps3 nvram driver for 2.6.29 that we discussed earlier

Cheers,
Ben.

The following changes since commit 9ead64974b05501bbac0d63a47c99fa786d064ba:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sam/kbuild-fixes

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Geert Uytterhoeven (1):
      ps3/block: Replace mtd/ps3vram by block/ps3vram

 arch/powerpc/platforms/ps3/Kconfig |    7 +
 drivers/block/Makefile             |    1 +
 drivers/block/ps3vram.c            |  865 ++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/Kconfig        |    7 -
 drivers/mtd/devices/Makefile       |    1 -
 drivers/mtd/devices/ps3vram.c      |  768 --------------------------------
 6 files changed, 873 insertions(+), 776 deletions(-)
 create mode 100644 drivers/block/ps3vram.c
 delete mode 100644 drivers/mtd/devices/ps3vram.c


