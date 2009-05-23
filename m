Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbZEWHmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbZEWHmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 03:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZEWHmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 03:42:32 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4470 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZEWHmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 03:42:31 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] drivers/ide/ide-core: Use dev_<level> and pr_<level>
Date: Sat, 23 May 2009 00:41:12 -0700
Message-Id: <cover.1243062772.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly mechanical patches to transform printk calls
to dev_<level> and pr_<level>.

Against linux-next

Joe Perches (3):
  drivers/ide/ide-core: Convert printk(KERN_<level> to dev_<level>
  drivers/ide/ide-core: Convert printk(KERN_<level> to pr_<level>
  drivers/ide/ide-core: Unsplit constant strings for pr_<level> and dev_<level>

 drivers/ide/ide-acpi.c      |   18 +++----
 drivers/ide/ide-atapi.c     |   76 +++++++++++++++----------------
 drivers/ide/ide-dma-sff.c   |    6 +-
 drivers/ide/ide-dma.c       |   28 ++++++------
 drivers/ide/ide-eh.c        |   26 +++++-----
 drivers/ide/ide-io.c        |   19 +++-----
 drivers/ide/ide-ioctls.c    |    4 +-
 drivers/ide/ide-iops.c      |    9 ++--
 drivers/ide/ide-legacy.c    |    7 +--
 drivers/ide/ide-lib.c       |   68 ++++++++++++++--------------
 drivers/ide/ide-pm.c        |    8 ++--
 drivers/ide/ide-probe.c     |  106 ++++++++++++++++++++++---------------------
 drivers/ide/ide-proc.c      |   16 +++----
 drivers/ide/ide-scan-pci.c  |    4 +-
 drivers/ide/ide-taskfile.c  |   23 +++++-----
 drivers/ide/ide-xfer-mode.c |    6 +-
 drivers/ide/ide.c           |   24 ++++------
 drivers/ide/setup-pci.c     |   91 +++++++++++++++++++------------------
 18 files changed, 263 insertions(+), 276 deletions(-)

