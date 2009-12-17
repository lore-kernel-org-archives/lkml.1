Return-Path: <linux-kernel-owner+w=401wt.eu-S1764492AbZLQLj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764492AbZLQLj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZLQLjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:39:54 -0500
Received: from mswedge2.sunplus.com ([124.219.29.227]:39984 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbZLQLjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:39:54 -0500
Subject: [GIT PULL] score patches for 2.6.33
From: Chen Liqin <liqin.chen@sunplusct.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       liqin.gnu@gmail.com
Content-Type: text/plain
Date: Thu, 17 Dec 2009 19:19:28 +0800
Message-Id: <1261048768.25208.12.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi linus,

Please pull from 'for-linus' branch of
  git://gitserver.sunplusct.com/linux-2.6-score for-linus
to receive following updates.

These bugs fix are base on recent comment and other part of
kernel's update.

The following changes since commit 718deb6b61e34c200c1f2b706176d9aac334cb2d:
  Al Viro (1):
        Fix breakage in shmem.c

are available in the git repository at:

  git://gitserver.sunplusct.com/linux-2.6-score.git for-linus

Chen Liqin (3):
      score: add flush_dcahce_page and PG_dcache_dirty define
      score: fixed pfn_valid define.
      score: include asm-generic/param.h in asm/delay.h.

 arch/score/include/asm/cacheflush.h |    4 +++-
 arch/score/include/asm/delay.h      |    2 ++
 arch/score/include/asm/page.h       |    2 +-
 arch/score/kernel/setup.c           |    1 +
 arch/score/mm/cache.c               |   26 ++++++++++++++++++++++++--
 arch/score/mm/init.c                |    5 -----
 6 files changed, 31 insertions(+), 9 deletions(-)


