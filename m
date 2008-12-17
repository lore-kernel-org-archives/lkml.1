Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754229AbYLQQJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYLQQJV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYLQQJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:09:07 -0500
Received: from gate.crashing.org ([63.228.1.57]:38431 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYLQQJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:09:07 -0500
Date: Wed, 17 Dec 2008 10:08:25 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Paul Mackerras <paulus@samba.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Please pull from 'merge' for 2.6.28
Message-ID: <Pine.LNX.4.64.0812171006580.12026@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 23e0e8afafd9ac065d81506524adf3339584044b:
  Arnd Bergmann (1):
        powerpc/cell/axon-msi: Fix MSI after kexec

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git merge

Dave Liu (1):
      powerpc/fsl-booke: Fix the miss interrupt restore

Guillaume Knispel (1):
      powerpc: Fix corruption error in rh_alloc_fixed()

 arch/powerpc/kernel/misc_32.S |    4 ++--
 arch/powerpc/lib/rheap.c      |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

--

Dave's patch fixes a stupid issue I introduced with my previous commit and
Guillaume is a simple fix for some oops's he was seeing.

- k
