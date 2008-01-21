Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbYAUXRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbYAUXRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYAUXRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:17:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43625 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244AbYAUXRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:17:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=VMbN9R2BhB4fo+pNo2QfsVcaE0cpsiU300kE90uLeJqpzmL2NKJyJ2sycMQt19XYnFsD4wFFCUXG4ZUCWpIuIOtNgrzrBkpqmarn7mcZ8xN3ypsXSjYkJsvqPMEhOZ5O+nYBJUV3n+SzLM6Jb7xnl01YNGbuP4uyxLBHjj1G27Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:30:36 +0100
Message-Id: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/16] ide: various fixes/cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Easy stuff done as relax from more hard-core changes...

diffstat:

 drivers/ide/cris/ide-cris.c |    6 -
 drivers/ide/ide-dma.c       |   20 ++++++
 drivers/ide/ide-iops.c      |  145 ++++++++++----------------------------------
 drivers/ide/ide-probe.c     |   35 ++++++----
 drivers/ide/ide-tape.c      |    4 -
 drivers/ide/ide-taskfile.c  |   11 ++-
 drivers/ide/ide.c           |    5 -
 drivers/ide/pci/siimage.c   |   25 ++++---
 drivers/ide/pci/trm290.c    |    5 -
 drivers/scsi/ide-scsi.c     |    7 --
 include/linux/hdreg.h       |    4 -
 include/linux/ide.h         |   15 ----
 12 files changed, 113 insertions(+), 169 deletions(-)
