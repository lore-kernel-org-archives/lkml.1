Return-Path: <linux-kernel-owner+w=401wt.eu-S1764920AbZDBPIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764920AbZDBPIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764281AbZDBPF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:05:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:34776 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764164AbZDBPF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:05:27 -0400
Date: Thu, 2 Apr 2009 15:03:54 +0000
From: Kyle McMartin <kyle@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: Geert.Uytterhoeven@sonycom.com, a.zummo@towertech.it,
       David.Woodhouse@intel.com, benh@kernel.crashing.org, dannf@hp.com,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca
Subject: [git patches] rtc{,-parisc} patches for 2.6.30
Message-ID: <20090402150354.GA2220@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 15:03:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 833bb3046b6cb320e775ea2160ddca87d53260d5:
  Alexey Dobriyan (1):
        serial: fixup /proc/tty/driver/serial after proc_fops conversion

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/kyle/rtc-parisc.git master

Geert Uytterhoeven (7):
      parisc: rtc: get_rtc_time() returns unsigned int
      parisc: rtc: platform_driver_probe() fixups
      parisc: rtc: Add missing module alias
      parisc: rtc: Rename rtc-parisc to rtc-generic
      m68k: Hook up rtc-generic
      powerpc: Hook up rtc-generic, and kill rtc-ppc
      powerpc/ps3: Add rtc-ps3

 arch/m68k/include/asm/rtc.h           |    7 ++-
 arch/m68k/kernel/time.c               |   18 ++++++
 arch/parisc/Kconfig                   |    2 +-
 arch/parisc/kernel/time.c             |    6 +-
 arch/powerpc/include/asm/ps3.h        |    3 +
 arch/powerpc/kernel/time.c            |   16 +++++
 arch/powerpc/platforms/ps3/os-area.c  |    2 +
 arch/powerpc/platforms/ps3/platform.h |    2 -
 arch/powerpc/platforms/ps3/setup.c    |    2 -
 arch/powerpc/platforms/ps3/time.c     |   26 ++++-----
 drivers/rtc/Kconfig                   |   31 +++++-----
 drivers/rtc/Makefile                  |    4 +-
 drivers/rtc/rtc-generic.c             |   84 ++++++++++++++++++++++++++
 drivers/rtc/rtc-parisc.c              |   86 ---------------------------
 drivers/rtc/rtc-ppc.c                 |   69 ----------------------
 drivers/rtc/rtc-ps3.c                 |  104 +++++++++++++++++++++++++++++++++
 16 files changed, 267 insertions(+), 195 deletions(-)
 create mode 100644 drivers/rtc/rtc-generic.c
 delete mode 100644 drivers/rtc/rtc-parisc.c
 delete mode 100644 drivers/rtc/rtc-ppc.c
 create mode 100644 drivers/rtc/rtc-ps3.c

