Return-Path: <linux-kernel-owner+w=401wt.eu-S934293AbYBNAWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293AbYBNAWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764934AbYBNAV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:21:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:24524 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762616AbYBNAVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:21:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=wrrBMLq5igqazH8AOORzAmEWqgm24jY7CCkvqzZBTGNg/yBuuH9wjq92drHZqN3YgM3Jy9ftlOLiZahPFq5ODpNYx01PRrJNEH4QzFxhYekuEJJwfi432ICd2k9fiGGLYGli9x79y61FxMqf39imsr7Kn8fGH45UmKPrtDGrF0g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2008 01:36:21 +0100
Message-Id: <20080214003621.12879.33868.sendpatchset@localhost.localdomain>
Subject: [PATCH 00/11] ide/ppc: remove PPC specific IDE hacks
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previous patchset adding warm-plug support allows the removal of PPC specific
IDE hacks (500 LOC gone)...

[ Ben, please take a look when you have some time, thanks! ]

diffstat:

 arch/powerpc/kernel/setup_32.c          |    8 --
 arch/powerpc/platforms/powermac/pci.c   |   22 -------
 arch/powerpc/platforms/powermac/pmac.h  |    5 -
 arch/powerpc/platforms/powermac/setup.c |    8 --
 arch/ppc/configs/sandpoint_defconfig    |    2 
 arch/ppc/kernel/ppc_ksyms.c             |    5 -
 arch/ppc/kernel/setup.c                 |    2 
 arch/ppc/platforms/4xx/bamboo.c         |    1 
 arch/ppc/platforms/4xx/ebony.c          |    1 
 arch/ppc/platforms/4xx/luan.c           |    1 
 arch/ppc/platforms/4xx/ocotea.c         |    1 
 arch/ppc/platforms/4xx/taishan.c        |    1 
 arch/ppc/platforms/4xx/yucca.c          |    1 
 arch/ppc/platforms/chestnut.c           |    1 
 arch/ppc/platforms/cpci690.c            |    1 
 arch/ppc/platforms/ev64260.c            |    1 
 arch/ppc/platforms/hdpu.c               |   36 -----------
 arch/ppc/platforms/lopec.c              |   85 ----------------------------
 arch/ppc/platforms/mvme5100.c           |    1 
 arch/ppc/platforms/powerpmc250.c        |    1 
 arch/ppc/platforms/pplus.c              |   58 -------------------
 arch/ppc/platforms/prep_setup.c         |   38 ------------
 arch/ppc/platforms/prpmc750.c           |    1 
 arch/ppc/platforms/prpmc800.c           |    1 
 arch/ppc/platforms/radstone_ppc7d.c     |    1 
 arch/ppc/platforms/residual.c           |    1 
 arch/ppc/platforms/sandpoint.c          |   94 -------------------------------
 arch/ppc/platforms/sandpoint.h          |    3 
 arch/ppc/platforms/spruce.c             |    1 
 arch/ppc/syslib/m8xx_setup.c            |    6 -
 arch/ppc/syslib/ppc4xx_setup.c          |   23 -------
 drivers/ide/ide.c                       |    6 -
 drivers/ide/pci/sl82c105.c              |    6 +
 drivers/ide/ppc/mpc8xx.c                |   86 +++++++---------------------
 drivers/ide/ppc/pmac.c                  |   97 +++-----------------------------
 include/asm-powerpc/ide.h               |   47 ++++++++++-----
 36 files changed, 72 insertions(+), 581 deletions(-)
