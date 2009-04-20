Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZDTHwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZDTHwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZDTHwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:52:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:50329 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbZDTHwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:52:16 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Apr 2009 17:52:25 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18924.10681.98103.247886@notabene.brown>
Subject: [PULL REQUEST] a few more md patches for 2.6.30
X-Mailer: VM 7.19 under Emacs 21.4.1
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Cc: Christoph Hellwig <hch@lst.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus, 
 a few more md fixes / enhancements.
 The enhancements are fairly minor and essentially finish off various
 threads begun in previous pull.

Thanks,
NeilBrown


The following changes since commit 0882e8dd3aad33eca41696d463bb896e6c8817eb:
  Linus Torvalds (1):
        Linux 2.6.30-rc2

are available in the git repository at:

  git://neil.brown.name/md for-linus

Christoph Hellwig (1):
      md: tiny md.h cleanups

NeilBrown (4):
      md: allow setting newly added device to 'in_sync' via sysfs.
      md: improve usefulness and accuracy of sysfs file md/sync_completed.
      md: update sync_completed and reshape_position even more often.
      md: support bitmaps on RAID10 arrays larger then 2 terabytes

 drivers/md/bitmap.c |    7 ++++---
 drivers/md/md.c     |   41 ++++++++++++++++++++++++++++-------------
 drivers/md/md.h     |   21 +++++++++++++--------
 drivers/md/raid5.c  |    7 ++++++-
 4 files changed, 51 insertions(+), 25 deletions(-)
