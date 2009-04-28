Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbZD1DxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbZD1DxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 23:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZD1Dwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 23:52:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:46125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbZD1Dwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 23:52:36 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, donari75@gmail.com,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: [GIT PATCH linux-2.6-block#for-linus] block: fix hd and mg_disk
Date: Tue, 28 Apr 2009 12:52:16 +0900
Message-Id: <1240890740-3462-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 03:52:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Upon ack, please pull from the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-block-for-linus

to receive the following patches.

 0001-mg_disk-fix-locking.patch
 0002-mg_disk-fix-CONFIG_LBD-y-warning.patch
 0003-hd-fix-locking.patch

0001 and 0003 fix locking problem in mg_disk and hd.  mg_disk is only
compile tested but hd received almost identical changes and is
verified to work so I'm relatively confident regarding the mg_disk.

0002 removes a build warning.

This patchset is on top of the current linux-2.6-block#for-linus[1]
and contains the following changes.

 drivers/block/hd.c      |   17 +++++++----------
 drivers/block/mg_disk.c |   19 ++++++++++++++-----
 2 files changed, 21 insertions(+), 15 deletions(-)

Thanks.

--
tejun

[1] f2d1f0ae7851be5ebd9613a80dac139270938809
