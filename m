Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZEIBxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZEIBxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 21:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZEIBxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 21:53:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:54569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbZEIBxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 21:53:36 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com, dan.j.williams@gmail.com
Subject: [GIT PATCH] block,scsi,libata: implement alt_size, take#2
Date: Sat,  9 May 2009 09:13:19 +0900
Message-Id: <1241828002-12742-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 09 May 2009 00:13:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Upon ack, please pull from the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-alt_size

This is the second take of implement-alt_size patchset.  Other than
being refreshed to apply on the current block tree, there's no real
change from the last take[L].

Jeff reluctantly acked it and Dan Williams is gonna handle mdadm part
of userland, so I guess it's about time to push this in.

This patchset is on top of the current block#for-2.6.31(f68adec3) and
can be automatically merged with block-peek-fetch branch by pulling.
diffstat follows.

 block/genhd.c              |   26 ++++++++++++++++++++++++++
 drivers/ata/libata-core.c  |    2 ++
 drivers/ata/libata-scsi.c  |    2 ++
 drivers/scsi/sd.c          |    1 +
 include/linux/genhd.h      |   13 ++++++++++++-
 include/linux/libata.h     |    1 +
 include/scsi/scsi_device.h |    1 +
 7 files changed, 45 insertions(+), 1 deletion(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/7235
