Return-Path: <linux-kernel-owner+w=401wt.eu-S933243AbXHVRVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbXHVRVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 13:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764937AbXHVRUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 13:20:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52575 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762358AbXHVRUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 13:20:47 -0400
Message-Id: <20070822170124.764128591@arndb.de>
User-Agent: quilt/0.45-1
Date: Wed, 22 Aug 2007 19:01:24 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: paulus@samba.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org
Subject: [patch 0/5] (hopefully) final 2.6.23 fixes for cell platform
X-Provags-ID: V01U2FsdGVkX18U93lYIjSvOPMGcqrlS6qW2N50Lz9JXe/WKB4
 Wxm+Ub5yI1YuqQNeR6W42K9bWK8TViqff4V30P5gi12aCX8HLB
 qPN3dOjsZ3exw+3RM2rcA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

A few bugs came up on the cell platform when testing on the lastest
prototype version of a future hardware. The first three patches are
all meant to track changes required for the fixes that have gone
into the firmware. Patch 4 is for a bug that showed up during testing,
and the final patch is the defconfig update that you probably want
to do for the other platforms as well.

Please forward for inclusion in 2.6.23!

	Arnd <><

diffstat:

 platforms/cell/cbe_regs.h    |    8 +
 platforms/cell/cbe_thermal.c |    6 -
 platforms/cell/pervasive.c   |   26 +++++
 platforms/cell/spu_manage.c  |    2
 sysdev/axonram.c             |   46 ++------
 configs/cell_defconfig       |  220 ++++++++++++------------------------
 6 files changed, 121 insertions(+), 187 deletions(-)


--

