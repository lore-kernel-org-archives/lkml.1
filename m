Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0BBR1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:27:14 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:52784 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab0BBR1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:27:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=xkBS+1gDM0Bn6jAv4IucFsx0os03aoBSU+8DUl+ALVb3U2ymFEDwZPvVEI3hFRdlA/
         D7iQSQyzWcjx7lX126Vq3/S195tqc+OIBRASnkAqL8NMkfk2T0dN6JNR/DjahGpG2WTX
         rwx/d6ykdUceklvXZ4k5aIRVaa2zPuuF7vFuc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 02 Feb 2010 18:27:01 +0100
Message-Id: <20100202172701.7599.2028.sendpatchset@localhost>
Subject: [PATCH 0/2] atang update for 02/02/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On top of atang-v4.2:
- nobody has IDE VLB controllers nowadays so move support for them
  to staging/out and schedule for removal in 2.6.36 (unless somebody
  steps in to work on it)
- do a small cleanup

The following changes since commit 7119919586b313e5dfe9c146f616550406040b7a:
  Bartlomiej Zolnierkiewicz (1):
        ide: remove obsolete /proc/ide/ interface

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.3

Bartlomiej Zolnierkiewicz (2):
      move host drivers for VLB IDE controllers to staging/out
      ide: remove hwif_chipset_t type

 drivers/ide/Kconfig                            |   72 ------------------------
 drivers/ide/Makefile                           |    7 --
 drivers/ide/at91_ide.c                         |    1 -
 drivers/ide/au1xxx-ide.c                       |    1 -
 drivers/ide/buddha.c                           |    1 -
 drivers/ide/cmd640.c                           |    1 -
 drivers/ide/delkin_cb.c                        |    1 -
 drivers/ide/falconide.c                        |    1 -
 drivers/ide/gayle.c                            |    1 -
 drivers/ide/icside.c                           |    2 -
 drivers/ide/ide-cs.c                           |    1 -
 drivers/ide/ide-dma.c                          |    2 +-
 drivers/ide/ide-generic.c                      |    1 -
 drivers/ide/ide-h8300.c                        |    1 -
 drivers/ide/ide-pnp.c                          |    1 -
 drivers/ide/ide-probe.c                        |    2 -
 drivers/ide/ide_platform.c                     |    1 -
 drivers/ide/macide.c                           |    1 -
 drivers/ide/palm_bk3710.c                      |    1 -
 drivers/ide/pmac.c                             |    1 -
 drivers/ide/q40ide.c                           |    1 -
 drivers/ide/rapide.c                           |    1 -
 drivers/ide/scc_pata.c                         |    1 -
 drivers/ide/sgiioc4.c                          |    1 -
 drivers/ide/tx4938ide.c                        |    1 -
 drivers/ide/tx4939ide.c                        |    1 -
 drivers/staging/Kconfig                        |    2 +
 drivers/staging/Makefile                       |    1 +
 drivers/staging/ide-vlb/Kconfig                |   69 +++++++++++++++++++++++
 drivers/staging/ide-vlb/Makefile               |    7 ++
 drivers/staging/ide-vlb/TODO                   |    5 ++
 drivers/{ide => staging/ide-vlb}/ali14xx.c     |    1 -
 drivers/{ide => staging/ide-vlb}/dtc2278.c     |    1 -
 drivers/{ide => staging/ide-vlb}/ht6560b.c     |   17 +++---
 drivers/{ide => staging/ide-vlb}/ide-4drives.c |    1 -
 drivers/{ide => staging/ide-vlb}/qd65xx.c      |    3 +-
 drivers/{ide => staging/ide-vlb}/qd65xx.h      |    0
 drivers/{ide => staging/ide-vlb}/umc8672.c     |    1 -
 include/linux/ide.h                            |   17 ------
 39 files changed, 94 insertions(+), 137 deletions(-)
 create mode 100644 drivers/staging/ide-vlb/Kconfig
 create mode 100644 drivers/staging/ide-vlb/Makefile
 create mode 100644 drivers/staging/ide-vlb/TODO
 rename drivers/{ide => staging/ide-vlb}/ali14xx.c (99%)
 rename drivers/{ide => staging/ide-vlb}/dtc2278.c (99%)
 rename drivers/{ide => staging/ide-vlb}/ht6560b.c (99%)
 rename drivers/{ide => staging/ide-vlb}/ide-4drives.c (98%)
 rename drivers/{ide => staging/ide-vlb}/qd65xx.c (99%)
 rename drivers/{ide => staging/ide-vlb}/qd65xx.h (100%)
 rename drivers/{ide => staging/ide-vlb}/umc8672.c (99%)
