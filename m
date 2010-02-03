Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0BCMVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 07:21:33 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39179 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab0BCMVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 07:21:32 -0500
Message-ID: <4B6969C8.20502@monstr.eu>
Date: Wed, 03 Feb 2010 13:19:20 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.33-rc7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these two patches. One is simple defconfig update and
the second is bugfix for noMMU version.

Thanks,
Michal


The following changes since commit c80d292f137275a1ed88e6ed515ecb457051f1a4:
   Linus Torvalds (1):
         Merge branch 'for-linus' of 
git://git.kernel.org/.../jmorris/security-testing-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

Michal Simek (1):
       microblaze: Defconfig update

Steven J. Magnani (1):
       microblaze: fix interrupt state restore

  arch/microblaze/configs/mmu_defconfig   |  112 
++++++++++++++++++++++++-------
  arch/microblaze/configs/nommu_defconfig |  101 ++++++++++++++++++++++-----
  arch/microblaze/kernel/entry-nommu.S    |   10 ++-
  3 files changed, 175 insertions(+), 48 deletions(-)



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
