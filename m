Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbYLIEOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbYLIEOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 23:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYLIENy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 23:13:54 -0500
Received: from ozlabs.org ([203.10.76.45]:45991 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbYLIENx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 23:13:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18749.61556.325147.855082@cargo.ozlabs.ibm.com>
Date: Tue, 9 Dec 2008 15:13:40 +1100
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

to get two more small commits for powerpc; one is a very small
defconfig update, and the other fixes a bug that can lead to an oops
on some 440-family embedded powerpc processors.

Thanks,
Paul.

 arch/powerpc/configs/83xx/mpc834x_itx_defconfig |    2 +-
 arch/powerpc/configs/mpc83xx_defconfig          |    2 +-
 arch/powerpc/kernel/cpu_setup_44x.S             |    1 +
 arch/powerpc/kernel/cputable.c                  |    3 +++
 4 files changed, 6 insertions(+), 2 deletions(-)

Anton Vorontsov (1):
      powerpc/83xx: Enable FIXED_PHY in mpc834x_itx and mpc83xx defconfigs

Grant Likely (1):
      powerpc/virtex5: Fix Virtex5 machine check handling

