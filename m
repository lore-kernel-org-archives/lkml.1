Return-Path: <linux-kernel-owner+w=401wt.eu-S966939AbZLHXtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966939AbZLHXtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937855AbZLHXtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:49:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41014
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937002AbZLHXtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:49:24 -0500
Date: Tue, 08 Dec 2009 15:49:30 -0800 (PST)
Message-Id: <20091208.154930.55611259.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mostly minor cleanups, and an increase in WAIT_DRQ to accomodate
CF cards, SSD drives, and other slow devices.

Also a UDMA fix for the slc90e66 driver which came a bit late
for 2.6.32 and I have thus queued up for -stable.

Please pull, thanks a lot.

The following changes since commit a252e749f1ae17e43ccc5824f7b1b5854417c98b:
  Linus Torvalds (1):
        sctp: fix compile error due to sysctl mismerge

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-next-2.6.git master

Bartlomiej Zolnierkiewicz (9):
      hpt366: remove dead old timing tables
      slc90e66: fix UDMA handling
      cs5535: add pci id for AMD based CS5535 controllers
      alim15x3: remove obsolete and dangerous wdc_udma parameter
      cmd64x: remove no longer needed debugging code
      cy82c693: remove no longer needed debugging code
      pdc202xx_old: remove no longer needed debugging code
      sis5513: remove stale TODO
      sl82c105: remove no longer needed debugging code

Borislav Petkov (1):
      ide-tape: remove the BKL

David S. Miller (4):
      ide: Increase WAIT_DRQ to accomodate some CF cards and SSD drives.
      Merge branch 'master' of master.kernel.org:/.../davem/ide-2.6
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      Merge branch 'ide-dcr' of git://git.kernel.org/.../bart/misc

H Hartley Sweeten (3):
      drivers/ide/au1xxx-ide.c: use resource_size()
      drivers/ide/ide_platform.c: use resource_size()
      drivers/ide/tx4938ide.c: use resource_size()

Robert Hancock (1):
      ide: update Kconfig text to mark as deprecated

Sergei Shtylyov (1):
      hpt366: kill unused #define's

 drivers/ide/Kconfig        |   43 ++++++-----------------------
 drivers/ide/alim15x3.c     |   12 +-------
 drivers/ide/au1xxx-ide.c   |    7 ++---
 drivers/ide/cmd64x.c       |   17 -----------
 drivers/ide/cs5535.c       |    1 +
 drivers/ide/cy82c693.c     |   27 ------------------
 drivers/ide/hpt366.c       |   65 --------------------------------------------
 drivers/ide/ide-tape.c     |   21 ++++++++++----
 drivers/ide/ide_platform.c |    8 +++---
 drivers/ide/pdc202xx_old.c |   15 ----------
 drivers/ide/sis5513.c      |    9 ------
 drivers/ide/sl82c105.c     |   24 +---------------
 drivers/ide/slc90e66.c     |    3 +-
 drivers/ide/tx4938ide.c    |    2 +-
 include/linux/ide.h        |    4 +-
 15 files changed, 38 insertions(+), 220 deletions(-)
