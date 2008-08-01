Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbYHADCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbYHADCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 23:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYHADCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 23:02:21 -0400
Received: from mx1.suse.de ([195.135.220.2]:49942 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYHADCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 23:02:21 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Aug 2008 13:02:12 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18578.31924.259887.735206@notabene.brown>
Cc: Arthur Jones <ajones@riverbed.com>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PULL REQUEST] md bug fixes and minor improvements
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 please pull the following bugfixes for drivers/md.

Thanks,
NeilBrown



The following changes since commit 6e86841d05f371b5b9b86ce76c02aaee83352298:
  Linus Torvalds (1):
        Linux 2.6.27-rc1

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Arthur Jones (1):
      md: raid10: wake up frozen array

Dan Williams (5):
      md: move async_tx_issue_pending_all outside spin_lock_irq
      md: fix merge error
      md: delay notification of 'active_idle' to the recovery thread
      md: do not progress the resync process if the stripe was blocked
      md: do not count blocked devices as spares

 drivers/md/md.c           |    8 ++++++--
 drivers/md/raid10.c       |    3 +++
 drivers/md/raid5.c        |   29 ++++++++++++++++++-----------
 include/linux/raid/md_k.h |    1 +
 4 files changed, 28 insertions(+), 13 deletions(-)
