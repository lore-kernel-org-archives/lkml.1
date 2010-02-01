Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab0BAOIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:08:44 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:58995 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0BAOIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:08:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=N7Mu7BbLJxhDCYN7zIR6axOE3iVslFpM8CBWAgANq9ZCmXhfz5Xy3QZVBIq9uC3ljj
         rJ6thRhwash+/2UMxeXsJIpRSleg41Y68FYOhA3qYTB8kgj4xbiGsKRjxvuoSaYOoDzH
         HbIRnYrgJjcTfqzWK58mZQmJMWYJoydSWtHfg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 01 Feb 2010 15:08:32 +0100
Message-Id: <20100201140832.15716.393.sendpatchset@localhost>
Subject: [PATCH 0/4] small atang update
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On top of atang-v4.1:
- port opti621 over ide2libata
- remove obsolete /proc/ide/ interface


The following changes since commit 3f5a01832c9a81e77bdb748d0b3c578e87280ed9:
  Bartlomiej Zolnierkiewicz (1):
        siimage: convert to ide2libata

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.2

Bartlomiej Zolnierkiewicz (4):
      pata_opti: move code to be re-used by ide2libata to pata_opti.h
      opti621: convert to ide2libata
      ide: remove obsolete /proc/ide/hdx/ settings
      ide: remove obsolete /proc/ide/ interface

 drivers/ata/pata_opti.c       |   90 +-----
 drivers/ata/pata_opti.h       |  141 ++++++++
 drivers/ide/Kconfig           |   11 -
 drivers/ide/Makefile          |    7 -
 drivers/ide/ide-cd.c          |   54 ---
 drivers/ide/ide-disk.c        |    3 -
 drivers/ide/ide-disk.h        |    9 -
 drivers/ide/ide-disk_proc.c   |  174 ---------
 drivers/ide/ide-floppy.c      |    3 -
 drivers/ide/ide-floppy.h      |    9 -
 drivers/ide/ide-floppy_proc.c |   45 ---
 drivers/ide/ide-gd.c          |   18 -
 drivers/ide/ide-probe.c       |    9 -
 drivers/ide/ide-proc.c        |  789 -----------------------------------------
 drivers/ide/ide-tape.c        |   98 -----
 drivers/ide/ide.c             |    4 -
 drivers/ide/opti621.c         |  114 +------
 include/linux/ide.h           |   73 ----
 18 files changed, 151 insertions(+), 1500 deletions(-)
 create mode 100644 drivers/ata/pata_opti.h
 delete mode 100644 drivers/ide/ide-disk_proc.c
 delete mode 100644 drivers/ide/ide-floppy_proc.c
 delete mode 100644 drivers/ide/ide-proc.c
