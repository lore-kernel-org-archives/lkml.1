Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0BJDxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 22:53:13 -0500
Received: from gate.crashing.org ([63.228.1.57]:39884 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab0BJDxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 22:53:11 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@lists.ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Feb 2010 14:52:45 +1100
Message-ID: <1265773965.8287.291.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's a fix for a nasty regression that went in this release cycle
and breaks 64K pages on HW that only does 4K such as 970's.

Cheers,
Ben.

The following changes since commit ac73fddfc523bf3c3525d16356b44527c44fae6d:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://neil.brown.name/md

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

David Gibson (1):
      powerpc: Fix address masking bug in hpte_need_flush()

 arch/powerpc/mm/tlb_hash64.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)


