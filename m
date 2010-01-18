Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059Ab0ARPnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab0ARPnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007Ab0ARPnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:43:35 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:61985 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab0ARPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:43:34 -0500
Message-ID: <4B548141.70008@monstr.eu>
Date: Mon, 18 Jan 2010 16:41:53 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.33-rc5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal


The following changes since commit 7dc9c484a71525794ca05cf7a47f283f1b54cd12:
   Linus Torvalds (1):
         Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

Michal Simek (5):
       microblaze: Wire up recvmmsg syscall
       microblaze: Enable accept4 syscall
       microblaze: Add PT_ macros for special purpose regs
       microblaze: Add missing double apostrophe in Kconfig
       microblaze: pci_controller->arch_data really is a struct 
device_node *

  arch/microblaze/Kconfig                |    2 +-
  arch/microblaze/include/asm/ptrace.h   |   14 ++++++++++++++
  arch/microblaze/include/asm/unistd.h   |    5 +++--
  arch/microblaze/kernel/prom_parse.c    |    2 +-
  arch/microblaze/kernel/syscall_table.S |    2 +-
  5 files changed, 20 insertions(+), 5 deletions(-)

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
