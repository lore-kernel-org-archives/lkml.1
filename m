Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbZBYCac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbZBYCac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbZBYCaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:30:22 -0500
Received: from ns.suse.de ([195.135.220.2]:59338 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945AbZBYCaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:30:21 -0500
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Feb 2009 13:30:06 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18852.44334.513936.123107@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL-REQUEST]  3 md fixes suitable for 2.6.29 and -stable
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus, 
 Recently discovered bugs, mostly affecting raid10 (though with a
 raid1 connection).
 Can cause Oops or data corruption.

Thanks,
NeilBrown



The following changes since commit 2ec77fc93ca8731368fbe8e71f805c0569d4bcee:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (3):
      md/raid10:  Don't skip more than 1 bitmap-chunk at a time during recovery.
      md/raid10:  Don't call bitmap_cond_end_sync when we are doing recovery.
      md: avoid races when stopping resync.

 drivers/md/raid1.c  |    3 ++-
 drivers/md/raid10.c |   19 ++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)
