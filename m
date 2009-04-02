Return-Path: <linux-kernel-owner+w=401wt.eu-S935110AbZDBGd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935110AbZDBGd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935191AbZDBGdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:33:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:57830 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296AbZDBGdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:33:05 -0400
Subject: [PATCH 0/2][git-pull scsi-misc] SCSI firmware patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jes Sorensen <jes@sgi.com>, Matthew Wilcox <matthew@wil.cx>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 12:02:43 +0530
Message-Id: <1238653963.4940.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello James,

These SCSI firmware patches are from linux-next in working condition
with ACKs:
qla1280: use request_firmware:
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=13bd5cd718e046e8bb9c1b43af4c57dbfb78d6e7

advansys: use request_firmware:
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=6e8dcf26cc2fe0672f01fe5b97374fc57ecd7f72

No code is changed only following comments are changed:
1. My email address
2. License of advansys as suggested by Matthew Wilcox.

The following changes since commit becfd7588ce32c4a94ef8ecebafded161c72dcce:
  Jean Delvare (1):
        [SCSI] libiscsi: fix iscsi pool error path

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/scsi-misc-2.6.git master

Jaswinder Singh Rajput (2):
      qla1280: use request_firmware
      advansys: use request_firmware

 drivers/scsi/advansys.c            | 1731 ++---------------------------
 drivers/scsi/ql1040_fw.h           | 2130 ------------------------------------
 drivers/scsi/ql12160_fw.h          | 1811 ------------------------------
 drivers/scsi/ql1280_fw.h           | 2048 ----------------------------------
 drivers/scsi/qla1280.c             |  114 ++-
 drivers/scsi/qla1280.h             |    6 +
 firmware/Makefile                  |    4 +
 firmware/WHENCE                    |   26 +
 firmware/advansys/3550.bin.ihex    |  317 ++++++
 firmware/advansys/38C0800.bin.ihex |  336 ++++++
 firmware/advansys/38C1600.bin.ihex |  398 +++++++
 firmware/advansys/mcode.bin.ihex   |  147 +++
 firmware/qlogic/1040.bin.ihex      | 2111 +++++++++++++++++++++++++++++++++++
 firmware/qlogic/12160.bin.ihex     | 1771 ++++++++++++++++++++++++++++++
 firmware/qlogic/1280.bin.ihex      | 2008 +++++++++++++++++++++++++++++++++
 15 files changed, 7299 insertions(+), 7659 deletions(-)
 delete mode 100644 drivers/scsi/ql1040_fw.h
 delete mode 100644 drivers/scsi/ql12160_fw.h
 delete mode 100644 drivers/scsi/ql1280_fw.h
 create mode 100644 firmware/advansys/3550.bin.ihex
 create mode 100644 firmware/advansys/38C0800.bin.ihex
 create mode 100644 firmware/advansys/38C1600.bin.ihex
 create mode 100644 firmware/advansys/mcode.bin.ihex
 create mode 100644 firmware/qlogic/1040.bin.ihex
 create mode 100644 firmware/qlogic/12160.bin.ihex
 create mode 100644 firmware/qlogic/1280.bin.ihex


