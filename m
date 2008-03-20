Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbYCTRBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbYCTRBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 13:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbYCTRBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 13:01:44 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58224 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757188AbYCTRBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 13:01:42 -0400
Subject: [GIT PATCH] SCSI fixes for 2.6.25-rc6
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 20 Mar 2008 12:01:39 -0500
Message-Id: <1206032499.3038.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is basically a round of small bug fixes.  The patch is available
here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Akinobu Mita (1):
      a100u2w: fix bitmap lookup routine

Boaz Harrosh (1):
      isd200: Allocate sense_buffer for hacked up scsi_cmnd

James Bottomley (1):
      Fix dependency problems in SCSI drivers

Kay Sievers (2):
      fix media change events for polled devices
      sd, sr: do not emit change event at device add

Matthew Wilcox (1):
      advansys: Fix bug in AdvLoadMicrocode

Mike Christie (1):
      fix bsg queue oops with iscsi logout

Prakash, Sathya (1):
      mpt fusion: Power Management fixes for MPT SAS PCI-E controllers

Sven Schnelle (1):
      gdth: Allocate sense_buffer to prevent NULL pointer dereference

nickcheng (1):
      arcmsr: fix iounmap error for Type B adapter


And the diffstat:

 drivers/message/fusion/mptbase.c  |  276 +++++++++++++++++++++-----------------
 drivers/message/fusion/mptscsih.c |   11 +
 drivers/scsi/Kconfig              |    2 
 drivers/scsi/a100u2w.c            |    9 -
 drivers/scsi/advansys.c           |    2 
 drivers/scsi/arcmsr/arcmsr.h      |   14 -
 drivers/scsi/gdth.c               |    7 
 drivers/scsi/scsi_lib.c           |    5 
 drivers/scsi/scsi_sysfs.c         |    2 
 drivers/scsi/sd.c                 |    1 
 drivers/scsi/sr.c                 |    1 
 drivers/usb/storage/isd200.c      |    5 
 12 files changed, 199 insertions(+), 136 deletions(-)

James


