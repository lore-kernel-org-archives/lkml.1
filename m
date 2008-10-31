Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbYJaELV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbYJaELV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 00:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYJaELL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 00:11:11 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43526 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbYJaELK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 00:11:10 -0400
Subject: [GIT PULL] ext4 fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1KvlLo-0000tO-6m@closure.thunk.org>
Date: Fri, 31 Oct 2008 00:11:08 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This fixes some regressions that have been reported.

						- Ted


Eric Sandeen (2):
      merge ext4_claim_free_blocks & ext4_has_free_blocks
      delay capable() check in ext4_has_free_blocks()

Hidehiro Kawai (2):
      ext3: fix a bug accessing freed memory in ext3_abort
      ext4: fix a bug accessing freed memory in ext4_abort

Theodore Ts'o (1):
      jbd2: Call the commit callback before the transaction could get dropped

 fs/ext3/super.c  |   10 +++++--
 fs/ext4/balloc.c |   77 +++++++++++++++++++-----------------------------------
 fs/ext4/ext4.h   |    3 +-
 fs/ext4/super.c  |   11 +++++---
 fs/jbd2/commit.c |    8 +++---
 5 files changed, 46 insertions(+), 63 deletions(-)
