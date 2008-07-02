Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbYGBWY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbYGBWY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYGBWYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:24:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:46273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbYGBWYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:24:44 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Jul 2008 08:24:36 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18540.36.610609.783148@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL-REQUEST] md bugfixes for 2.6.26
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,
 please pull as follows:  three bugfixs that also need to go to
 -stable.

Thanks,
NeilBrown



The following changes since commit 543cf4cb3fe6f6cae3651ba918b9c56200b257d0:
  Linus Torvalds (1):
        Linux 2.6.26-rc8

are available in the git repository at:

  git://neil.brown.name/md for-2.6.26

Neil Brown (3):
      Ensure interrupted recovery completed properly (v1 metadata plus bitmap)
      Don't acknowlege that stripe-expand is complete until it really is.
      Fix error paths if md_probe fails.

 drivers/md/md.c     |    6 ++++--
 drivers/md/raid10.c |    2 ++
 drivers/md/raid5.c  |    7 ++++++-
 3 files changed, 12 insertions(+), 3 deletions(-)
