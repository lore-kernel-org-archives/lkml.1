Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZERULk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZERULk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZERULc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:11:32 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1932 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZERULc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:11:32 -0400
From: Joe Perches <joe@perches.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Borislav Petkov <petkovbb@gmail.com>
Subject: drivers/ide/ide-core: Convert printk's to pr_<foo> and dev_<foo>
Date: Mon, 18 May 2009 13:11:26 -0700
Message-Id: <cover.1242676752.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize printk's by mostly mechanical conversions of
printk(KERN_<foo> to pr_<foo>(.  The KERN_DEBUG uses are
not done, deferred until a more standard mechanism exists

Standardize pr_<foo> logging uses of drive->name and hwif->name
to use dev_<foo>.

Signed-off-by: Joe Perches <joe@perches.com>

Joe Perches (2):
  drivers/ide/ide-core: Convert printk(KERN_<foo> to pr_<foo>( without KERN_DEBUG
  drivers/ide/ide-core: Convert pr_<foo> to dev_<foo>

 drivers/ide/ide-acpi.c      |   17 +++----
 drivers/ide/ide-atapi.c     |   67 +++++++++++++--------------
 drivers/ide/ide-dma-sff.c   |    6 +-
 drivers/ide/ide-dma.c       |   28 ++++++------
 drivers/ide/ide-eh.c        |   25 +++++-----
 drivers/ide/ide-io.c        |   16 +++----
 drivers/ide/ide-ioctls.c    |    4 +-
 drivers/ide/ide-iops.c      |    9 ++--
 drivers/ide/ide-legacy.c    |    8 ++--
 drivers/ide/ide-lib.c       |   68 +++++++++++++-------------
 drivers/ide/ide-pm.c        |   11 ++--
 drivers/ide/ide-probe.c     |  108 ++++++++++++++++++++++---------------------
 drivers/ide/ide-proc.c      |   16 +++----
 drivers/ide/ide-scan-pci.c  |    4 +-
 drivers/ide/ide-taskfile.c  |   23 ++++-----
 drivers/ide/ide-xfer-mode.c |    6 +-
 drivers/ide/ide.c           |   25 ++++------
 drivers/ide/setup-pci.c     |   87 +++++++++++++++++-----------------
 18 files changed, 258 insertions(+), 270 deletions(-)

