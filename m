Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbZEMUrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbZEMUrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbZEMUrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:47:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57965 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZEMUrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=oH5Hes1riPtJ8/DEwC42CvxiTtIn33ZKHV5mCdg3ELTlVsug1md10i+zsyyOAdxG96
         Fwlw8E75mOrLNAKPEcOjbvnOZsJQuaNAE/DuGHUhnevUvqL5MgIFQ1bwZISDJY7ZLQpj
         BLb6xaE58jqMbztS7ypt4v/PN/hkik7eZq8R0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 13 May 2009 22:51:39 +0200
Message-Id: <20090513205139.28638.87226.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/7] ide: minor improvements/cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On top of for-next branch of ide-2.6.git tree.

* BUG() on impossible conditions
* make ide_host_{alloc,add}() API less magic
* remove 'chipset' field from hw_regs_t
* remove few typedefs

diffstat:
 drivers/ide/at91_ide.c     |    7 +---
 drivers/ide/au1xxx-ide.c   |    8 ++---
 drivers/ide/buddha.c       |    9 ++---
 drivers/ide/cmd640.c       |    7 +---
 drivers/ide/cs5520.c       |    4 +-
 drivers/ide/delkin_cb.c    |    6 +--
 drivers/ide/falconide.c    |    9 ++---
 drivers/ide/gayle.c        |    9 ++---
 drivers/ide/icside.c       |   13 ++++----
 drivers/ide/ide-4drives.c  |    6 +--
 drivers/ide/ide-cd.c       |    8 +----
 drivers/ide/ide-cs.c       |    6 +--
 drivers/ide/ide-disk.c     |   13 +-------
 drivers/ide/ide-eh.c       |    9 ++---
 drivers/ide/ide-floppy.c   |    6 +--
 drivers/ide/ide-generic.c  |    7 +---
 drivers/ide/ide-h8300.c    |   10 +++---
 drivers/ide/ide-io.c       |   69 ++++++++++++++++++---------------------------
 drivers/ide/ide-legacy.c   |    7 +---
 drivers/ide/ide-pnp.c      |    6 +--
 drivers/ide/ide-probe.c    |   25 +++++++---------
 drivers/ide/ide-tape.c     |   10 ------
 drivers/ide/ide-taskfile.c |    2 -
 drivers/ide/ide_platform.c |    9 ++---
 drivers/ide/macide.c       |    9 ++---
 drivers/ide/palm_bk3710.c  |    6 +--
 drivers/ide/pmac.c         |   13 ++++----
 drivers/ide/q40ide.c       |   11 +++----
 drivers/ide/rapide.c       |    8 ++---
 drivers/ide/scc_pata.c     |    6 +--
 drivers/ide/setup-pci.c    |   21 ++++++-------
 drivers/ide/sgiioc4.c      |    7 +---
 drivers/ide/siimage.c      |    4 +-
 drivers/ide/tx4938ide.c    |    5 +--
 drivers/ide/tx4939ide.c    |    5 +--
 include/linux/ide.h        |   37 +++++++++---------------
 36 files changed, 171 insertions(+), 226 deletions(-)
