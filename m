Return-Path: <linux-kernel-owner+w=401wt.eu-S1763074AbZFPVp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763074AbZFPVp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757122AbZFPVpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:45:19 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:33813 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753381AbZFPVpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:45:18 -0400
To: apkm@linux-foundation.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Please pull bjdooks' i2c tree
From: Ben Dooks <ben-linux@fluff.org>
Message-Id: <E1MGgSs-00047f-5Z@kira.home.fluff.org>
Date: Tue, 16 Jun 2009 22:45:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 300df7dc89cc276377fc020704e34875d5c473b6:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jlbec/ocfs2

are available in the git repository at:

  git://aeryn.fluff.org.uk/bjdooks/linux.git next-i2c

Ben Dooks (1):
      i2c-s3c2410: use resource_size()

Linus Walleij (3):
      i2c: ST DDC I2C U300 bus driver v3
      i2c: Use resource_size macro
      i2c-stu300: Make driver depend on MACH_U300

Mike Frysinger (1):
      i2c-bfin-twi: pull in io.h for ioremap()

 drivers/i2c/busses/Kconfig            |   13 +
 drivers/i2c/busses/Makefile           |    1 +
 drivers/i2c/busses/i2c-at91.c         |    8 +-
 drivers/i2c/busses/i2c-au1550.c       |    2 +-
 drivers/i2c/busses/i2c-bfin-twi.c     |    3 +-
 drivers/i2c/busses/i2c-highlander.c   |    2 +-
 drivers/i2c/busses/i2c-mv64xxx.c      |    2 +-
 drivers/i2c/busses/i2c-ocores.c       |    8 +-
 drivers/i2c/busses/i2c-omap.c         |    2 +-
 drivers/i2c/busses/i2c-pca-platform.c |   10 +-
 drivers/i2c/busses/i2c-pmcmsp.c       |    8 +-
 drivers/i2c/busses/i2c-pxa.c          |    9 +-
 drivers/i2c/busses/i2c-s3c2410.c      |    4 +-
 drivers/i2c/busses/i2c-stu300.c       | 1029 +++++++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-versatile.c    |    6 +-
 15 files changed, 1074 insertions(+), 33 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-stu300.c
