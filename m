Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbXJ2BEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbXJ2BEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 21:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXJ2BES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 21:04:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:48332 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401AbXJ2BER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 21:04:17 -0400
Date: Mon, 29 Oct 2007 02:04:29 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.56-rc2
Message-ID: <20071029010429.GH7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.55:
- CVE-2007-3739: Don't allow the stack to grow into hugetlb reserved regions
- CVE-2007-4133: hugetlb: fix prio_tree unit


Location:
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.56-rc1:

Adrian Bunk (1):
      Linux 2.6.16.56-rc2

David Gibson (1):
      hugetlb: check for brk() entering a hugepage region

Hugh Dickins (2):
      hugetlb: fix error return for brk() entering a hugepage region
      hugetlb: fix size=4G parsing

Ken Chen (1):
      [IA64] fix ia64 is_hugepage_only_range


 Makefile                   |    2 +-
 arch/ia64/mm/hugetlbpage.c |    7 +++----
 fs/hugetlbfs/inode.c       |    1 -
 include/asm-ia64/page.h    |    2 +-
 mm/mmap.c                  |    3 +++
 5 files changed, 8 insertions(+), 7 deletions(-)

