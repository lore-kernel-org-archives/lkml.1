Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbZEOR75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbZEOR75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 13:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZEOR7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:59:46 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2038 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbZEOR7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:59:45 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] Change #ifdef DEBUG printk(KERN_DEBUG to pr_debug
Date: Fri, 15 May 2009 10:59:34 -0700
Message-Id: <cover.1242407227.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Remove unnecessary #ifdef DEBUG/#endif pairs 
with trivial conversions of:

   #ifdef DEBUG
     printk(KERN_DEBUG foo);
   #endif
to:
   pr_debug(foo);

Signed-off-by: Joe Perches <joe@perches.com>

Joe Perches (11):
      arch/arm: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      arch/h8300: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      arch/m68knommu: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      arch/powerpc: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      arch/um: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      drivers/isdn: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      drivers/macintosh: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      drivers/net: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      drivers/scsi: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      fs/efs: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
      mm: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(

 arch/arm/mach-omap1/id.c                   |   26 +++++++++----------
 arch/h8300/kernel/setup.c                  |   24 +++++++----------
 arch/h8300/mm/init.c                       |    4 +--
 arch/m68knommu/kernel/setup.c              |   16 +++++------
 arch/m68knommu/mm/init.c                   |    4 +--
 arch/powerpc/platforms/pseries/eeh_cache.c |    6 +---
 arch/um/drivers/hostaudio_kern.c           |   38 ++++++++-------------------
 drivers/isdn/i4l/isdn_bsdcomp.c            |    4 +--
 drivers/isdn/pcbit/callbacks.c             |    9 +-----
 drivers/isdn/pcbit/capi.c                  |   16 +++---------
 drivers/isdn/pcbit/drv.c                   |   30 ++++++---------------
 drivers/isdn/pcbit/layer2.c                |   30 ++++++---------------
 drivers/macintosh/ans-lcd.c                |   16 +++---------
 drivers/net/tc35815.c                      |   13 +++------
 drivers/scsi/aha1542.c                     |    8 +----
 fs/efs/dir.c                               |    5 +--
 fs/efs/inode.c                             |   14 +++-------
 mm/oom_kill.c                              |    6 +---
 18 files changed, 88 insertions(+), 181 deletions(-)

