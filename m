Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZBFEUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZBFEUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 23:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZBFEUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 23:20:30 -0500
Received: from mail.suse.de ([195.135.220.2]:35664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZBFEU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 23:20:29 -0500
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Feb 2009 15:20:13 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18827.47741.271010.507719@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
Subject: [PULL REQUEST] 2 bug fixes for drives/md in 2.6.29
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two small patches for md.
The first is marked for -stable.

Thanks,
NeilBrown


The following changes since commit eda58a85ec3fc05855a26654d97a2b53f0e715b9:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../cooloney/blackfin-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Andre Noll (1):
      md: Fix a bug in linear.c causing which_dev() to return the wrong device.

NeilBrown (1):
      md: Allow read error in a single drive raid1 to be passed up.

 drivers/md/linear.c |    6 +++---
 drivers/md/raid1.c  |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)
