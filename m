Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0CKVMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:12:19 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:55003 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0CKVMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:12:18 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 11 Mar 2010 14:11:57 -0700
X-Google-Sender-Auth: 98b9c5e7c198554b
Message-ID: <fa686aa41003111311w2a2c2707yddfe90c953b92be@mail.gmail.com>
Subject: [git pull] driver bug fixes and mpc5200 defconfig updates
To: linuxppc-dev@lists.ozlabs.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Scott Ellis <scott@jumpnowtek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are some driver bug fixes, and the requisite powerpc-mpc5200
defconfig updates.  The defconfig updates would normally go through
Ben's tree, but since that is the only change I have that would go
through his tree I'm hoping that it is okay to have it here.

Cheers,
g.

The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge

David Miller (1):
      uartlite: Fix build on sparc.

Grant Likely (1):
      powerpc/52xx: update defconfigs

Scott Ellis (2):
      spi/omap2_mcspi: fix NULL pointer dereference
      spi/omap2_mcspi: Use transaction speed if provided

 arch/powerpc/configs/52xx/cm5200_defconfig    |   24 ++--
 arch/powerpc/configs/52xx/lite5200b_defconfig |   28 +++--
 arch/powerpc/configs/52xx/motionpro_defconfig |   25 +++--
 arch/powerpc/configs/52xx/pcm030_defconfig    |   27 +++---
 arch/powerpc/configs/52xx/tqm5200_defconfig   |   28 +++---
 arch/powerpc/configs/mpc5200_defconfig        |  134 ++++++++++++++++---------
 drivers/serial/uartlite.c                     |   10 +-
 drivers/spi/omap2_mcspi.c                     |   18 ++-
 8 files changed, 177 insertions(+), 117 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
