Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbYBWOEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbYBWOEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYBWOEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:04:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:33567 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbYBWOEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:04:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=QOPW6qjRjMglUVckeJB/n5gl6cAmkte50fTX0Wpr2ZE9nRAPSxpT/MPWP7Xf0RiwIf462asrUQ9jCkSrCI0QXF3D455rXL6sEv4ZR1EYIrHwUEPc8APoPwXOnP/yvlb8EL6MASlKTPHODr9dyw9PXr/1zWEXnJBkYL2p/67oF24=
Date: Sat, 23 Feb 2008 15:04:36 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 00/10] IDE: Coding Style Fixes
Message-ID: <20080223150436.6c09ce54@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,
The following 10 patches remove a huge number of errors and warnings
reported by checkpatch.pl from the IDE subsystem.

All the patches have been compile tested.


Paolo Ciarrocchi (10):
      IDE: Coding Style fixes to drivers/ide/pci/sis5513.c
      IDE: Coding Style fixes to drivers/ide/legacy/umc8672.c
      IDE: Coding Style fixes to drivers/ide/ide-pnp.c
      IDE: Coding Style fixes to drivers/ide/setup-pci.c
      IDE: Coding Style fixes to drivers/ide/ide-proc.c
      IDE: Coding Style fixes to drivers/ide/legacy/ide-4drives.c
      IDE: Coding Style fixes to drivers/ide/pci/slc90e66.c
      IDE: Coding Style fixes to drivers/ide/pci/generic.c
      IDE: Coding Style fixes to drivers/ide/pci/jmicron.c
      IDE: Coding Style fixes to drivers/ide/pci/tc86c001.c

 drivers/ide/ide-pnp.c            |   10 +-
 drivers/ide/ide-proc.c           |  175 +++++++++++++++++------------------
 drivers/ide/legacy/ide-4drives.c |    2 +-
 drivers/ide/legacy/umc8672.c     |   53 +++++------
 drivers/ide/pci/generic.c        |   50 +++++-----
 drivers/ide/pci/jmicron.c        |    3 +-
 drivers/ide/pci/sis5513.c        |  190 +++++++++++++++++++-------------------
 drivers/ide/pci/slc90e66.c       |    6 +-
 drivers/ide/pci/tc86c001.c       |   28 +++---
 drivers/ide/setup-pci.c          |   45 ++++-----
 10 files changed, 274 insertions(+), 288 deletions(-)

Ciao,
            Paolo
