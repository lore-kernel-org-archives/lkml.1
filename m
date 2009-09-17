Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbZIQRyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbZIQRyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758747AbZIQRyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:54:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54727
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbZIQRyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:54:35 -0400
Date: Thu, 17 Sep 2009 10:54:52 -0700 (PDT)
Message-Id: <20090917.105452.168715527.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This kills off the long unnecessary sparc PROM console driver, and
updates the default configs.

Please pull, thanks a lot!

The following changes since commit 0cb583fd2862f19ea88b02eb307d11c09e51e2f8:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-next-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      sparc: Kill PROM console driver.
      sparc: Update defconfigs.

 Documentation/dontdiff               |    1 -
 arch/sparc/configs/sparc32_defconfig |   44 ++-
 arch/sparc/configs/sparc64_defconfig |   51 ++--
 arch/sparc/kernel/setup_32.c         |    2 -
 arch/sparc/kernel/setup_64.c         |    2 -
 drivers/char/vt.c                    |    3 -
 drivers/video/console/.gitignore     |    2 -
 drivers/video/console/Kconfig        |    9 +-
 drivers/video/console/Makefile       |   12 -
 drivers/video/console/prom.uni       |   11 -
 drivers/video/console/promcon.c      |  598 ----------------------------------
 scripts/Makefile                     |    1 -
 12 files changed, 56 insertions(+), 680 deletions(-)
 delete mode 100644 drivers/video/console/.gitignore
 delete mode 100644 drivers/video/console/prom.uni
 delete mode 100644 drivers/video/console/promcon.c
