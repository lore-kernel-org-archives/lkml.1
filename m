Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbYLCL3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbYLCL3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYLCL3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:29:09 -0500
Received: from ozlabs.org ([203.10.76.45]:53871 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbYLCL3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:29:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18742.27860.32471.101697@cargo.ozlabs.ibm.com>
Date: Wed, 3 Dec 2008 22:26:12 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get one commit from Ben Herrenschmidt that fixes a regression since
2.6.27.

Thanks,
Paul.

 arch/powerpc/kernel/dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

commit 2434bbb30e79468c49cff3cff6005236f55ed188
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Sun Nov 30 18:53:40 2008 +0000

    powerpc: Fix dma_map_sg() cache flushing on non coherent platforms
    
    On PowerPC 4xx or other non cache-coherent platforms, we lost the
    appropriate cache flushing in dma_map_sg() when merging the 32 and
    64-bit DMA code (commit 4fc665b88a79a45bae8bbf3a05563c27c7337c3d,
    "powerpc: Merge 32 and 64-bit dma code").  This restores it.
    
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Acked-by: Becky Bruce <beckyb@kernel.crashing.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>
