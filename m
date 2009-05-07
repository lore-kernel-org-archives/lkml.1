Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbZEGFMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbZEGFMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 01:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZEGFMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 01:12:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbZEGFMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 01:12:00 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 May 2009 15:12:06 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18946.28070.563110.755463@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] md updates for 2.6.30
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
  a few more fixes for md.  A couple relate to v.large raid10 arrays.
  several are tagged for -stable.

Thanks,
NeilBrown

 

The following changes since commit b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs

are available in the git repository at:

  git://neil.brown.name/md for-linus

Jan Engelhardt (1):
      md: constify VFTs

NeilBrown (6):
      md: fix loading of out-of-date bitmap.
      md/raid10: don't clear bitmap during recovery if array will still be degraded.
      md: fix some (more) errors with bitmaps on devices larger than 2TB.
      md: tidy up status_resync to handle large arrays.
      md: remove ability to explicit set an inactive array to 'clean'.
      md: remove rd%d links immediately after stopping an array.

 drivers/md/bitmap.c |   29 +++++++++++----------
 drivers/md/md.c     |   70 ++++++++++++++++++++++++++++----------------------
 drivers/md/raid10.c |   12 ++++----
 3 files changed, 60 insertions(+), 51 deletions(-)
