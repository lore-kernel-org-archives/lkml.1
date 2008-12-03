Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYLCXXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYLCXXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbYLCXWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:22:52 -0500
Received: from ozlabs.org ([203.10.76.45]:54354 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbYLCXWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:22:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18743.5311.794489.670294@cargo.ozlabs.ibm.com>
Date: Thu, 4 Dec 2008 10:22:39 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] Please pull powerpc.git merge branch
In-Reply-To: <18742.27860.32471.101697@cargo.ozlabs.ibm.com>
References: <18742.27860.32471.101697@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

> Please pull from the 'merge' branch of
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge
> 
> to get one commit from Ben Herrenschmidt that fixes a regression since
> 2.6.27.

I have just added one more commit from Kumar's merge branch, so when
you pull the diffstat should be:

 arch/powerpc/boot/dts/mpc8349emitx.dts |   16 ++++++++--------
 arch/powerpc/kernel/dma.c              |    1 +
 2 files changed, 9 insertions(+), 8 deletions(-)

If you had already pulled, please pull again, or pull Kumar's merge
branch directly.

Thanks,
Paul.

Anton Vorontsov (1):
      powerpc/83xx: Fix MCU support merge issue in mpc8349emitx.dts

Benjamin Herrenschmidt (1):
      powerpc: Fix dma_map_sg() cache flushing on non coherent platforms

