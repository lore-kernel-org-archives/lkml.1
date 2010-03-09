Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0CIWwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 17:52:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:55782 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0CIWwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 17:52:09 -0500
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Mar 2010 09:52:02 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19350.53522.385933.467438@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] minor md updates for 2.6.34
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Yes, I know I missed the boat, and I won't lose any sleep if this
doesn't get accepted, but here are a few minor improvements that I
would rather were in than not.

I have another bugfix coming (relating to merge_bvec_fn handling) but
I'm not confident I have that right yet so it'll some later as a
separate 'bugfix'.

Thanks,
NeilBrown


The following changes since commit 25cf84cf377c0aae5dbcf937ea89bc7893db5176:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../amit/virtio-console

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

H Hartley Sweeten (1):
      drivers/md: Remove unnecessary casts of void *

NeilBrown (1):
      md: remove some dead fields from mddev_s

Paul Clements (1):
      md: expose max value of behind writes counter

 drivers/md/bitmap.c    |   37 ++++++++++++++++++++++++++++++++-----
 drivers/md/bitmap.h    |    1 +
 drivers/md/faulty.c    |    6 +++---
 drivers/md/md.h        |    3 ---
 drivers/md/multipath.c |    2 +-
 drivers/md/raid1.c     |    8 ++++----
 drivers/md/raid10.c    |    8 ++++----
 drivers/md/raid5.c     |   10 +++++-----
 8 files changed, 50 insertions(+), 25 deletions(-)
