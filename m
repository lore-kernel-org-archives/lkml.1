Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZKQRT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZKQRT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZKQRT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:19:58 -0500
Received: from relay3.sgi.com ([192.48.152.1]:40391 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756109AbZKQRT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:19:57 -0500
Date: Tue, 17 Nov 2009 11:19:58 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <200911171719.nAHHJwjq017993@stout.americas.sgi.com>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.32
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two regressions that have been identified in XFS
in the last few days.  I'm hoping to get these fixes into
2.6.32.

					-Alex

The following changes since commit a9366e61b03f55a6e009e687ad10e706714c9907:
  Linus Torvalds (1):
        Merge git://git.infradead.org/users/dwmw2/iommu-2.6.32

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Jan Rekorajski (1):
      XFS bug in log recover with quota (bugzilla id 855)

Nathaniel W. Turner (1):
      xfs: copy li_lsn before dropping AIL lock

 fs/xfs/xfs_log_recover.c |    4 ++--
 fs/xfs/xfs_trans_ail.c   |   23 ++++++++++++++++++++---
 2 files changed, 22 insertions(+), 5 deletions(-)
