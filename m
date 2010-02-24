Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab0BXMhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 07:37:09 -0500
Received: from mail-fx0-f216.google.com ([209.85.220.216]:53811 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab0BXMhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 07:37:07 -0500
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 07:37:07 EST
Message-ID: <4B851ACD.8070307@monstr.eu>
Date: Wed, 24 Feb 2010 13:25:49 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.33
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following two patches. Steven's patch just remove one 
semicolon and my patch fix wrong cache loop macro for write-through caches.

Thanks,
Michal

The following changes since commit 75ef7cdda2daa35be9e070ac8e5258759ac03d06:
   Linus Torvalds (1):
         Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

Michal Simek (1):
       microblaze: Fix cache loop function for cache range

Steven J. Magnani (1):
       microblaze: Fix out_le32() macro

  arch/microblaze/include/asm/io.h   |    2 +-
  arch/microblaze/kernel/cpu/cache.c |   27 ++++++++-------------------
  2 files changed, 9 insertions(+), 20 deletions(-)

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
