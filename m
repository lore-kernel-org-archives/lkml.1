Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZBARs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZBARs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbZBARsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:48:18 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:45568 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZBARsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:48:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=i3b4Xu5sgUOb00gBh3gkdhU4wa4lM3wtSHTFmdO7/eRdKmFhs7s2cDVz/vwqSsZVwD
         s3jQWBsvLwEeRdhQnnQdt+7LfjTmKdN6RAKT8SZhjvUvcplO0I1j/2gjPoBRrEJq4vUG
         7MGLqFiIdRVoM/3eN+sdrW4SNerqvhgkiC2cU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:49:09 +0100
Message-Id: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/15] weekly IDE updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The weekly IDE updates on top of pata-2.6 tree... [ What else did you expect? ]

Fix some minor bugs (memleak on device probing failure and incorrect error
message on multi-PIO write failure), limit proliferation of <asm/ide.h>, allow
host drivers to specify IRQ flags that they want and do a few cleanups...

diffstat:
 drivers/ide/buddha.c        |    1 
 drivers/ide/delkin_cb.c     |    1 
 drivers/ide/dtc2278.c       |    3 -
 drivers/ide/falconide.c     |    1 
 drivers/ide/gayle.c         |    1 
 drivers/ide/ide-4drives.c   |    3 -
 drivers/ide/ide-cs.c        |    1 
 drivers/ide/ide-disk.c      |    3 -
 drivers/ide/ide-disk_proc.c |    4 +
 drivers/ide/ide-eh.c        |   11 ++++-
 drivers/ide/ide-floppy.c    |    2 
 drivers/ide/ide-h8300.c     |    4 -
 drivers/ide/ide-io-std.c    |   13 ++++--
 drivers/ide/ide-io.c        |   95 +++++++++++++-------------------------------
 drivers/ide/ide-park.c      |    2 
 drivers/ide/ide-pm.c        |    9 +++-
 drivers/ide/ide-probe.c     |   56 +++++++++----------------
 drivers/ide/ide-tape.c      |    2 
 drivers/ide/ide-taskfile.c  |   56 ++++++++++++++-----------
 drivers/ide/macide.c        |    1 
 drivers/ide/ns87415.c       |    2 
 drivers/ide/q40ide.c        |    1 
 drivers/ide/scc_pata.c      |   28 +++++-------
 drivers/ide/setup-pci.c     |    4 +
 drivers/ide/sgiioc4.c       |    1 
 drivers/ide/tx4938ide.c     |    6 +-
 drivers/ide/tx4939ide.c     |    6 +-
 include/linux/ide.h         |   93 ++++++++++++++++++++++---------------------
 28 files changed, 202 insertions(+), 208 deletions(-)
