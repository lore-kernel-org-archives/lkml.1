Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYK3AHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYK3AHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 19:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYK3AHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 19:07:30 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:33803 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYK3AHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 19:07:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:content-type:organization:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=ujslHYkTilBspoyVAa5hao/aWsTIG8fRMM1yDxuad3uVf+DJKke0IoeD5c8Y2wJVFe
         Y4R+WPKHGspt6oAr4zeRZNrRqHrXDBepU4LQgGCIhOPp7TrGT4hrXDyQ1a4Opralyl/c
         b0kc/MVXuXwdhWGQISb3wVtFPZRR5vV7542JQ=
Subject: [RESEND take 2][PATCH 0/2] Add /proc/mempool to display mempools
From: Remi Colinet <remi.colinet@gmail.com>
Reply-To: remi.colinet@gmail.com
To: Kernel <linux-kernel@vger.kernel.org>,
       Remi Colinet <remi.colinet@gmail.com>
Content-Type: text/plain
Organization: Personal
Date: Sun, 30 Nov 2008 01:04:05 +0100
Message-Id: <1228003445.13070.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a new /proc/mempool file to display mempools.

Patch againt 2.6.28-rc6.

Signed-off-by: Remi Colinet <remi.colinet@gmail.com>
---
Add /proc/mempool to display mempools.

Resend #1 : cosmetic cleaning.

Resend #2 : remove config option for /proc/mempool file. Add a missing
file (fs/proc/mempool.c). Correct mempool_XXX function calls by drivers
(s390, ibmvfs, qla4xxx). Cosmetic stuff found with
scripts/checkpatch.pl.

 block/blk-core.c               |    3 -
 drivers/block/pktcdvd.c        |    4 -
 drivers/block/virtio_blk.c     |    3 -
 drivers/md/dm-crypt.c          |    5 +-
 drivers/md/dm-io.c             |    3 -
 drivers/md/dm-raid1.c          |    2
 drivers/md/dm-region-hash.c    |    2
 drivers/md/multipath.c         |    2
 drivers/md/raid1.c             |    7 +-
 drivers/md/raid10.c            |    5 +-
 drivers/s390/scsi/zfcp_aux.c   |    2
 drivers/scsi/ibmvscsi/ibmvfc.c |    2
 drivers/scsi/lpfc/lpfc_mem.c   |    5 +-
 drivers/scsi/qla4xxx/ql4_os.c  |    2
 fs/bio.c                       |    2
 fs/proc/Makefile               |    1
 fs/proc/mempool.c              |   99 +++++++++++++++++++++++++++++++++
 include/linux/mempool.h        |   40 ++++++++++++----
 mm/bounce.c                    |    4 -
 mm/mempool.c                   |   43 ++++++++++++++++-
 20 files changed, 200 insertions(+), 36 deletions(-)





