Return-Path: <linux-kernel-owner+w=401wt.eu-S932519Ab0AFSMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab0AFSMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318Ab0AFSMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:12:01 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47945 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab0AFSMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:12:01 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       davinci-linux-open-source@linux.davincidsp.com
Subject: [GIT PULL] davinci platform fixes for 2.6.33-rc4
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 06 Jan 2010 10:11:58 -0800
Message-ID: <87k4vvf6hd.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the fixes for the ARM/DaVinci platform for 2.6.33-rc4.

Thanks,

Kevin


The following changes since commit 74d2e4f8d79ae0c4b6ec027958d5b18058662eea:
  Linus Torvalds (1):
        Linux 2.6.33-rc3

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-fixes

or

  git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-fixes

Miguel Aguilar (1):
      DaVinci: DM365: Add the device_enable for the DaVinci Keyscan

Sekhar Nori (3):
      davinci: cp_intc: provide set_wake function
      davinci: da8xx/omap-l1: mark RTC as a wakeup source
      davinci: enable ARCH_HAS_HOLES_MEMORYMODEL for DaVinci

Vaibhav Hiremath (1):
      Davinci VPFE Capture: Take i2c adapter id through platform data

 arch/arm/Kconfig                         |    1 +
 arch/arm/mach-davinci/board-dm355-evm.c  |    1 +
 arch/arm/mach-davinci/board-dm365-evm.c  |   11 ++++++-----
 arch/arm/mach-davinci/board-dm644x-evm.c |    1 +
 arch/arm/mach-davinci/cp_intc.c          |   11 +++++++++++
 arch/arm/mach-davinci/devices-da8xx.c    |    9 ++++++++-
 arch/arm/mach-davinci/dm365.c            |    1 -
 7 files changed, 28 insertions(+), 7 deletions(-)
