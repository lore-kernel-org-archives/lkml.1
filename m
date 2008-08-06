Return-Path: <linux-kernel-owner+w=401wt.eu-S1762388AbYHFUbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762388AbYHFUbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbYHFUaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:30:05 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:29884 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030325AbYHFU3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:29:39 -0400
X-Belgacom-Dynamic: yes
Date: Wed, 6 Aug 2008 22:29:18 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [WATCHDOG] v2.6.27-rc patches
Message-ID: <20080806202918.GA29386@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig               |   16 -
 drivers/watchdog/Makefile              |    4 
 drivers/watchdog/acquirewdt.c          |  130 ++++-----
 drivers/watchdog/advantechwdt.c        |  162 +++++------
 drivers/watchdog/alim1535_wdt.c        |  189 ++++++-------
 drivers/watchdog/alim7101_wdt.c        |  228 ++++++++--------
 drivers/watchdog/ar7_wdt.c             |    8 
 drivers/watchdog/at32ap700x_wdt.c      |   43 +--
 drivers/watchdog/at91rm9200_wdt.c      |  108 +++----
 drivers/watchdog/bfin_wdt.c            |  147 +++++-----
 drivers/watchdog/booke_wdt.c           |   44 +--
 drivers/watchdog/cpu5wdt.c             |  144 +++++-----
 drivers/watchdog/davinci_wdt.c         |   19 -
 drivers/watchdog/ep93xx_wdt.c          |   27 +
 drivers/watchdog/eurotechwdt.c         |   95 +++---
 drivers/watchdog/geodewdt.c            |   96 +++----
 drivers/watchdog/hpwdt.c               |    6 
 drivers/watchdog/i6300esb.c            |  366 +++++++++++++-------------
 drivers/watchdog/iTCO_vendor.h         |   15 +
 drivers/watchdog/iTCO_vendor_support.c |   62 ++--
 drivers/watchdog/iTCO_wdt.c            |  310 +++++++++++-----------
 drivers/watchdog/ib700wdt.c            |  123 ++++-----
 drivers/watchdog/ibmasr.c              |  151 ++++++-----
 drivers/watchdog/indydog.c             |  114 ++++----
 drivers/watchdog/iop_wdt.c             |   62 ++--
 drivers/watchdog/it8712f_wdt.c         |    6 
 drivers/watchdog/ixp2000_wdt.c         |   60 ++--
 drivers/watchdog/ixp4xx_wdt.c          |   66 ++--
 drivers/watchdog/ks8695_wdt.c          |  119 ++++----
 drivers/watchdog/machzwd.c             |  108 ++-----
 drivers/watchdog/mixcomwd.c            |  133 ++++-----
 drivers/watchdog/mpc5200_wdt.c         |   24 +
 drivers/watchdog/mpc83xx_wdt.c         |  230 ----------------
 drivers/watchdog/mpc8xx_wdt.c          |   37 +-
 drivers/watchdog/mpc8xxx_wdt.c         |  316 +++++++++++++++++++++++
 drivers/watchdog/mpcore_wdt.c          |   73 +++--
 drivers/watchdog/mtx-1_wdt.c           |  111 +++-----
 drivers/watchdog/mv64x60_wdt.c         |   21 -
 drivers/watchdog/omap_wdt.c            |   42 +--
 drivers/watchdog/pc87413_wdt.c         |  249 +++++++-----------
 drivers/watchdog/pcwd.c                |  191 +++++++-------
 drivers/watchdog/pcwd_pci.c            |  161 +++++------
 drivers/watchdog/pcwd_usb.c            |  168 ++++++------
 drivers/watchdog/pnx4008_wdt.c         |   28 --
 drivers/watchdog/rm9k_wdt.c            |   34 +-
 drivers/watchdog/s3c2410_wdt.c         |    4 
 drivers/watchdog/sa1100_wdt.c          |   42 +--
 drivers/watchdog/sb_wdog.c             |   92 +++---
 drivers/watchdog/sbc60xxwdt.c          |  223 ++++++++--------
 drivers/watchdog/sbc7240_wdt.c         |   70 ++---
 drivers/watchdog/sbc8360.c             |   46 +--
 drivers/watchdog/sbc_epx_c3.c          |   22 -
 drivers/watchdog/sc1200wdt.c           |   39 +-
 drivers/watchdog/sc520_wdt.c           |  162 ++++++-----
 drivers/watchdog/scx200_wdt.c          |   65 ++--
 drivers/watchdog/shwdt.c               |  139 ++++++----
 drivers/watchdog/smsc37b787_wdt.c      |  448 ++++++++++++++++-----------------
 drivers/watchdog/softdog.c             |   87 +++---
 drivers/watchdog/txx9wdt.c             |   37 +-
 drivers/watchdog/w83627hf_wdt.c        |  190 ++++++-------
 drivers/watchdog/w83697hf_wdt.c        |  189 ++++++-------
 drivers/watchdog/w83877f_wdt.c         |  199 +++++++-------
 drivers/watchdog/w83977f_wdt.c         |  239 ++++++++---------
 drivers/watchdog/wafer5823wdt.c        |  132 +++++----
 drivers/watchdog/wd501p.h              |    2 
 drivers/watchdog/wdrtas.c              |  105 +++----
 drivers/watchdog/wdt.c                 |    4 
 drivers/watchdog/wdt285.c              |   31 +-
 drivers/watchdog/wdt977.c              |  162 +++++------
 drivers/watchdog/wdt_pci.c             |    8 
 70 files changed, 3837 insertions(+), 3746 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Aug 6 20:19:41 2008 +0000

    [WATCHDOG] more coding style clean-up's
    
    More coding style clean-up's.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 18 19:59:48 2008 +0000

    [WATCHDOG] sbc8360.c - move stop code into a function
    
    Move the sbc8360.c watchdog stop code into a seperate function.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Jul 18 11:41:17 2008 +0000

    [WATCHDOG] Coding style - Indentation - part 2
    
    This brings the watchdog drivers into line with coding style.
    This patch takes cares of the indentation as described in chapter 1.
    Main changes:
    * Re-structure the ioctl switch call for all drivers as follows:
    	switch (cmd) {
    	case WDIOC_GETSUPPORT:
    	case WDIOC_GETSTATUS:
    	case WDIOC_GETBOOTSTATUS:
    	case WDIOC_GETTEMP:
    	case WDIOC_SETOPTIONS:
    	case WDIOC_KEEPALIVE:
    	case WDIOC_SETTIMEOUT:
    	case WDIOC_GETTIMEOUT:
    	case WDIOC_GETTIMELEFT:
    	default:
    	}
    
    This to make the migration from the drivers to the uniform watchdog
    device driver easier in the future.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Jul 17 18:08:47 2008 +0000

    [WATCHDOG] Coding style - Indentation - part 1
    
    This brings the watchdog drivers into line with coding style.
    This patch takes cares of the indentation as described in chapter 1:
      The preferred way to ease multiple indentation levels in a switch
      statement is to align the "switch" and its subordinate "case"
      labels in the same column instead of "double-indenting" the "case"
      labels.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Thu Jul 3 23:51:36 2008 -0700

    [WATCHDOG] mpc8xxx_wdt: add support for MPC8xx watchdogs
    
    The mpc8xxx_wdt driver is using two registers: SWSRR to push magic
    numbers, and SWCRR to control the watchdog.  Both registers are available
    on the MPC8xx, and seem to have the same offsets and semantics as in
    MPC83xx/MPC86xx watchdogs.  The only difference is prescale value.  So
    this driver simply works on the MPC8xx CPUs.
    
    One quirk is needed for the MPC8xx, though.  It has small prescale value
    and slow CPU, so the watchdog resets board prior to the driver has time to
    load.  To solve this we should split initialization in two steps: start
    ping the watchdog early, and register the watchdog userspace interface
    later.
    
    MPC823 seem to be the first CPU in MPC8xx line, so we use fsl,mpc823-wdt
    compatible matching.
    
    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Tested-by: Jochen Friedrich <jochen@scram.de>
    Cc: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Thu Jul 3 23:51:36 2008 -0700

    [WATCHDOG] mpc8xxx_wdt: fix build
    
      CC      drivers/watchdog/mpc8xxx_wdt.o
    drivers/watchdog/mpc8xxx_wdt.c: In function 'mpc8xxx_wdt_ioctl':
    drivers/watchdog/mpc8xxx_wdt.c:156: error: 'cmd' undeclared (first use in this function)
    drivers/watchdog/mpc8xxx_wdt.c:156: error: (Each undeclared identifier is reported only once
    drivers/watchdog/mpc8xxx_wdt.c:156: error: for each function it appears in.)
    drivers/watchdog/mpc8xxx_wdt.c: At top level:
    drivers/watchdog/mpc8xxx_wdt.c:176: warning: initialization from incompatible pointer type
    
    This patch ought to be folded into
    mpc8xxx_wdt-various-renames-mostly-s-mpc83xx-mpc8xxx-g.patch
    
    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Cc: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Thu Jul 3 23:51:35 2008 -0700

    [WATCHDOG] mpc8xxx_wdt: various renames, mostly s/mpc83xx/mpc8xxx/g
    
    mpc83xx_wdt.c renamed to mpc8xxx_wdt.c, now we can do various renames in
    the file itself.
    
    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Cc: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Thu Jul 3 23:51:34 2008 -0700

    [WATCHDOG] mpc83xx_wdt: rename to mpc8xxx_wdt
    
    Rename the driver because now we support some MPC86xx processors.
    
    There are no changes to the mpc83xx_wdt.c file, yet.  When possible, we do
    file renames and changes separately (because Linus once asked so, because
    it helps git to track the renamed files).
    
    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Cc: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Thu Jul 3 23:51:34 2008 -0700

    [WATCHDOG] mpc83xx_wdt: add support for MPC86xx CPUs
    
    On MPC86xx the watchdog could be enabled only at power-on-reset, and could
    not be disabled afterwards.  We must ping the watchdog from the kernel
    until the userspace handles it.
    
    MPC83xx CPUs are only differ in a way that watchdog could be disabled
    once, but after it was enabled via software it becomes just the same as
    MPC86xx.
    
    Thus, to support MPC86xx I added the kernel timer which pings the watchdog
    until the userspace opens it.
    
    Since we implemented the timer, now we're able to implement proper
    handling for the CONFIG_WATCHDOG_NOWAYOUT case, for MPC83xx and MPC86xx.
    
    Also move the probe code into subsys_initcall, because we want start
    pinging the watchdog ASAP, and misc devices are available in
    subsys_initcall.
    
    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Cc: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Thu Jul 3 23:51:32 2008 -0700

    [WATCHDOG] mpc83xx_wdt: convert to the OF platform driver
    
    This patch simply converts mpc83xx_wdt to the OF platform driver so we can
    directly work with the device tree without passing various stuff through
    platform data.
    
    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Cc: Kumar Gala <galak@kernel.crashing.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Alan Cox <alan@redhat.com>
Date:   Thu Jul 3 23:51:32 2008 -0700

    [WATCHDOG] pcwd: a couple of watchdogs escaped conversion
    
    Fix them up.  Once we know the long term plan the watchdogs can all get
    shrunk massively anyway
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Jul 15 11:46:11 2008 +0000

    [WATCHDOG] Clean-up includes
    
    Use #include <linux/io.h> instead of <asm/io.h>
    Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
    Clean-up includes.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Jul 15 11:18:04 2008 +0000

    [WATCHDOG] hpwdt.c - fix double includes
    
    The last clean-up created 2 times the same include. delete the doubles.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Merge: 0967d61... 7c4be5a...
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Aug 6 11:58:26 2008 +0000

    [WATCHDOG] Merge code clean-up's from Alan Cox.
    
    Merge branch 'alan' of ../linux-2.6-watchdog-mm
    Fixed Conflicts in the following files:
    	drivers/watchdog/booke_wdt.c
    	drivers/watchdog/mpc5200_wdt.c
    	drivers/watchdog/sc1200wdt.c
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:10:02 2008 +0100

    [WATCHDOG 57/57] wdt501/pci: Clean up, coding style and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:57 2008 +0100

    [WATCHDOG 56/57] wdt977: clean up, coding style and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:51 2008 +0100

    [WATCHDOG 55/57] wdt285: switch to unlocked_ioctl and tidy up oddments of coding style
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:45 2008 +0100

    [WATCHDOG 54/57] wdrtas: clean up, coding style, switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:40 2008 +0100

    [WATCHDOG 53/57] wafer5823wdt: Clean up, coding style, switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:34 2008 +0100

    [WATCHDOG 52/57] w83977f_wdt: clean up, coding style and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:29 2008 +0100

    [WATCHDOG 51/57] w83877f_wdt: clean up code, coding style, switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:23 2008 +0100

    [WATCHDOG 50/57] w83697hf_wdt: cleanup, coding style and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:18 2008 +0100

    [WATCHDOG 49/57] w83627hf: coding style, clean up and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:12 2008 +0100

    [WATCHDOG 48/57] txx9: Fix locking, switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:06 2008 +0100

    [WATCHDOG 47/57] softdog: clean up, coding style and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:09:00 2008 +0100

    [WATCHDOG 46/57] smsc37b787_wdt: coding style, switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:55 2008 +0100

    [WATCHDOG 45/57] shwdt: coding style, cleanup, switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:49 2008 +0100

    [WATCHDOG 44/57] scx200_wdt: clean up and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:44 2008 +0100

    [WATCHDOG 43/57] sc520_wdt: Clean up and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:38 2008 +0100

    [WATCHDOG 42/57] sc1200_wdt: clean up, fix locking and use unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:33 2008 +0100

    [WATCHDOG 41/57] sb_wdog: Clean up and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:27 2008 +0100

    [WATCHDOG 40/57] sbc_epx_c3_wdt: switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:22 2008 +0100

    [WATCHDOG 39/57] sbc8360: clean up
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:16 2008 +0100

    [WATCHDOG 38/57] stg7240_wdt: unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:11 2008 +0100

    [WATCHDOG 37/57] sbc60xxwdt: clean up and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:05 2008 +0100

    [WATCHDOG 36/57] sa1100_wdt: Switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:08:00 2008 +0100

    [WATCHDOG 35/57] s3c2410: watchdog cleanup and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:07:54 2008 +0100

    [WATCHDOG 34/57] rm9k_wdt: clean up
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:07:48 2008 +0100

    [WATCHDOG 33/57] pnx4008_wdt: unlocked_ioctl setup
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:07:43 2008 +0100

    [WATCHDOG 32/57] pcwd: clean up, unlocked_ioctl usage
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:07:37 2008 +0100

    [WATCHDOG 31/57] pc87413_wdt: clean up, coding style, unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:07:32 2008 +0100

    [WATCHDOG 30/57] omap_wdt: locking, unlocked_ioctl, tidy
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:07:26 2008 +0100

    [WATCHDOG 29/57] mv64x60_wdt: clean up and locking checks
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:07:21 2008 +0100

    [WATCHDOG 28/57] mtx-1_wdt: clean up, coding style, unlocked ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:07:15 2008 +0100

    [WATCHDOG 27/57] mpcore watchdog: unlocked_ioctl and BKl work
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:07:09 2008 +0100

    [WATCHDOG 26/57] mpc watchdog: clean up and locking
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:07:04 2008 +0100

    [WATCHDOG 25/57] mixcomwd: coding style locking, unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:59 2008 +0100

    [WATCHDOG 24/57] machzwd: clean up, coding style, unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:53 2008 +0100

    [WATCHDOG 23/57] ks8695_wdt: clean up, coding style, unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:48 2008 +0100

    [WATCHDOG 22/57] ixp4xx_wdt: unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:42 2008 +0100

    [WATCHDOG 21/57] ixp2000_wdt: clean up and unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:36 2008 +0100

    [WATCHDOG 20/57] booke watchdog: clean up and unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:30 2008 +0100

    [WATCHDOG 19/57] bfin: watchdog cleanup and unlocked_ioctl
    
    Scan, tidy and check for unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:25 2008 +0100

    [WATCHDOG 18/57] iTCO: unlocked_ioctl, coding style and cleanup
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:19 2008 +0100

    [WATCHDOG 17/57] it8712f: unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:14 2008 +0100

    [WATCHDOG 16/57] iop: watchdog switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:08 2008 +0100

    [WATCHDOG 15/57] indydog: Clean up and tidy
    
    Switch to unlocked_ioctl as well
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:06:03 2008 +0100

    [WATCHDOG 14/57] ibmasr: coding style, locking verify
    
    There is a new #if 0 section here which is a suggested fix for the horrible
    PCI hack in the existing code. Would be good if someone with a box that uses
    this device could test it.
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:05:57 2008 +0100

    [WATCHDOG 13/57] i6300esb: Style, unlocked_ioctl, cleanup
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:05:52 2008 +0100

    [WATCHDOG 12/57] ib700wdt: clean up and switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:05:46 2008 +0100

    [WATCHDOG 11/57] hpwdt: couple of include cleanups
    
    clean-up includes
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:05:41 2008 +0100

    [WATCHDOG 10/57] eurotechwdt: unlocked_ioctl, code lock check and tidy
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:05:35 2008 +0100

    [WATCHDOG 09/57] ep93xx_wdt: unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:05:30 2008 +0100

    [WATCHDOG 08/57] davinci_wdt: unlocked_ioctl and check locking
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:05:24 2008 +0100

    [WATCHDOG 07/57] cpu5_wdt: switch to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:05:19 2008 +0100

    [WATCHDOG 06/57] at91: watchdog to unlocked_ioctl
    
    Review and switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:05:13 2008 +0100

    [WATCHDOG 05/57] atp watchdog
    
    Switch to unlocked_ioctl
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:05:07 2008 +0100

    [WATCHDOG 04/57] AR7 watchdog
    
    Fix locking
    Use unlocked_ioctl
    Remove semaphores
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:04:57 2008 +0100

    [WATCHDOG 03/57] ali: watchdog locking and style
    
    Clean up and check locking
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:04:51 2008 +0100

    [WATCHDOG 02/57] clean up and check advantech watchdog
    
    Clean up the advantech watchdog code and inspect for BKL problems
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Alan Cox <alan@redhat.com>
Date:   Mon May 19 14:04:46 2008 +0100

    [WATCHDOG 01/57] Clean acquirewdt and check for BKL dependancies
    
    This brings the file into line with coding style.
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 48399e1..32b9fe1 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -463,7 +463,7 @@ config PC87413_WDT
 	  module will be called pc87413_wdt.
 
 	  Most people will say N.
- 
+
 config 60XX_WDT
 	tristate "SBC-60XX Watchdog Timer"
 	depends on X86
@@ -695,9 +695,17 @@ config 8xx_WDT
 	tristate "MPC8xx Watchdog Timer"
 	depends on 8xx
 
-config 83xx_WDT
-	tristate "MPC83xx Watchdog Timer"
-	depends on PPC_83xx
+config 8xxx_WDT
+	tristate "MPC8xxx Platform Watchdog Timer"
+	depends on PPC_8xx || PPC_83xx || PPC_86xx
+	help
+	  This driver is for a SoC level watchdog that exists on some
+	  Freescale PowerPC processors. So far this driver supports:
+	  - MPC8xx watchdogs
+	  - MPC83xx watchdogs
+	  - MPC86xx watchdogs
+
+	  For BookE processors (MPC85xx) use the BOOKE_WDT driver instead.
 
 config MV64X60_WDT
 	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index edd305a..049c918 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -92,7 +92,7 @@ obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 
 # MIPS Architecture
 obj-$(CONFIG_INDYDOG) += indydog.o
-obj-$(CONFIG_WDT_MTX1)	+= mtx-1_wdt.o
+obj-$(CONFIG_WDT_MTX1) += mtx-1_wdt.o
 obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
 obj-$(CONFIG_SIBYTE_WDOG) += sb_wdog.o
 obj-$(CONFIG_AR7_WDT) += ar7_wdt.o
@@ -103,7 +103,7 @@ obj-$(CONFIG_TXX9_WDT) += txx9wdt.o
 # POWERPC Architecture
 obj-$(CONFIG_8xx_WDT) += mpc8xx_wdt.o
 obj-$(CONFIG_MPC5200_WDT) += mpc5200_wdt.o
-obj-$(CONFIG_83xx_WDT) += mpc83xx_wdt.o
+obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
 obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
 
diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 85269c3..6e46a55 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -58,39 +58,45 @@
 #include <linux/types.h>		/* For standard types (like size_t) */
 #include <linux/errno.h>		/* For the -ENODEV/... values */
 #include <linux/kernel.h>		/* For printk/panic/... */
-#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
+							(WATCHDOG_MINOR) */
 #include <linux/watchdog.h>		/* For the watchdog specific items */
 #include <linux/fs.h>			/* For file operations */
 #include <linux/ioport.h>		/* For io-port access */
 #include <linux/platform_device.h>	/* For platform_driver framework */
 #include <linux/init.h>			/* For __init/__exit/... */
-
-#include <asm/uaccess.h>		/* For copy_to_user/put_user/... */
-#include <asm/io.h>			/* For inb/outb/... */
+#include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
+#include <linux/io.h>			/* For inb/outb/... */
 
 /* Module information */
 #define DRV_NAME "acquirewdt"
 #define PFX DRV_NAME ": "
 #define WATCHDOG_NAME "Acquire WDT"
-#define WATCHDOG_HEARTBEAT 0	/* There is no way to see what the correct time-out period is */
+/* There is no way to see what the correct time-out period is */
+#define WATCHDOG_HEARTBEAT 0
 
 /* internal variables */
-static struct platform_device *acq_platform_device;	/* the watchdog platform device */
+/* the watchdog platform device */
+static struct platform_device *acq_platform_device;
 static unsigned long acq_is_open;
 static char expect_close;
 
 /* module parameters */
-static int wdt_stop = 0x43;	/* You must set this - there is no sane way to probe for this board. */
+/* You must set this - there is no sane way to probe for this board. */
+static int wdt_stop = 0x43;
 module_param(wdt_stop, int, 0);
 MODULE_PARM_DESC(wdt_stop, "Acquire WDT 'stop' io port (default 0x43)");
 
-static int wdt_start = 0x443;	/* You must set this - there is no sane way to probe for this board. */
+/* You must set this - there is no sane way to probe for this board. */
+static int wdt_start = 0x443;
 module_param(wdt_start, int, 0);
 MODULE_PARM_DESC(wdt_start, "Acquire WDT 'start' io port (default 0x443)");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Watchdog Operations
@@ -112,18 +118,18 @@ static void acq_stop(void)
  *	/dev/watchdog handling
  */
 
-static ssize_t acq_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t acq_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count) {
+	if (count) {
 		if (!nowayout) {
 			size_t i;
-
 			/* note: just in case someone wrote the magic character
-			 * five months ago... */
+			   five months ago... */
 			expect_close = 0;
-
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			   magic character */
 			for (i = 0; i != count; i++) {
 				char c;
 				if (get_user(c, buf + i))
@@ -132,64 +138,55 @@ static ssize_t acq_write(struct file *file, const char __user *buf, size_t count
 					expect_close = 42;
 			}
 		}
-
-		/* Well, anyhow someone wrote to us, we should return that favour */
+		/* Well, anyhow someone wrote to us, we should
+				return that favour */
 		acq_keepalive();
 	}
 	return count;
 }
 
-static int acq_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long acq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident =
-	{
+	static struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = WATCHDOG_NAME,
 	};
 
-	switch(cmd)
-	{
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
-
-	case WDIOC_KEEPALIVE:
-	  acq_keepalive();
-	  return 0;
-
-	case WDIOC_GETTIMEOUT:
-	  return put_user(WATCHDOG_HEARTBEAT, p);
+		return put_user(0, p);
 
 	case WDIOC_SETOPTIONS:
 	{
-	    if (get_user(options, p))
-	      return -EFAULT;
-
-	    if (options & WDIOS_DISABLECARD)
-	    {
-	      acq_stop();
-	      retval = 0;
-	    }
-
-	    if (options & WDIOS_ENABLECARD)
-	    {
-	      acq_keepalive();
-	      retval = 0;
-	    }
-
-	    return retval;
+		if (get_user(options, p))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			acq_stop();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			acq_keepalive();
+			retval = 0;
+		}
+		return retval;
 	}
+	case WDIOC_KEEPALIVE:
+		acq_keepalive();
+		return 0;
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(WATCHDOG_HEARTBEAT, p);
 
 	default:
-	  return -ENOTTY;
+		return -ENOTTY;
 	}
 }
 
@@ -211,7 +208,8 @@ static int acq_close(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		acq_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		acq_keepalive();
 	}
 	clear_bit(0, &acq_is_open);
@@ -227,7 +225,7 @@ static const struct file_operations acq_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= acq_write,
-	.ioctl		= acq_ioctl,
+	.unlocked_ioctl	= acq_ioctl,
 	.open		= acq_open,
 	.release	= acq_close,
 };
@@ -248,32 +246,29 @@ static int __devinit acq_probe(struct platform_device *dev)
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				wdt_stop);
+			printk(KERN_ERR PFX
+			    "I/O address 0x%04x already in use\n", wdt_stop);
 			ret = -EIO;
 			goto out;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
-
 	ret = misc_register(&acq_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-
-	printk (KERN_INFO PFX "initialized. (nowayout=%d)\n",
-		nowayout);
+	printk(KERN_INFO PFX "initialized. (nowayout=%d)\n", nowayout);
 
 	return 0;
-
 unreg_regions:
 	release_region(wdt_start, 1);
 unreg_stop:
@@ -286,9 +281,9 @@ out:
 static int __devexit acq_remove(struct platform_device *dev)
 {
 	misc_deregister(&acq_miscdev);
-	release_region(wdt_start,1);
-	if(wdt_stop != wdt_start)
-		release_region(wdt_stop,1);
+	release_region(wdt_start, 1);
+	if (wdt_stop != wdt_start)
+		release_region(wdt_stop, 1);
 
 	return 0;
 }
@@ -313,18 +308,19 @@ static int __init acq_init(void)
 {
 	int err;
 
-	printk(KERN_INFO "WDT driver for Acquire single board computer initialising.\n");
+	printk(KERN_INFO
+	      "WDT driver for Acquire single board computer initialising.\n");
 
 	err = platform_driver_register(&acquirewdt_driver);
 	if (err)
 		return err;
 
-	acq_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	acq_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(acq_platform_device)) {
 		err = PTR_ERR(acq_platform_device);
 		goto unreg_platform_driver;
 	}
-
 	return 0;
 
 unreg_platform_driver:
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index 8121cc2..a5110f9 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -37,9 +37,9 @@
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define DRV_NAME "advantechwdt"
@@ -47,7 +47,8 @@
 #define WATCHDOG_NAME "Advantech WDT"
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
-static struct platform_device *advwdt_platform_device;	/* the watchdog platform device */
+/* the watchdog platform device */
+static struct platform_device *advwdt_platform_device;
 static unsigned long advwdt_is_open;
 static char adv_expect_close;
 
@@ -72,35 +73,35 @@ MODULE_PARM_DESC(wdt_start, "Advantech WDT 'start' io port (default 0x443)");
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=63, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<= timeout <=63, default="
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Watchdog Operations
  */
 
-static void
-advwdt_ping(void)
+static void advwdt_ping(void)
 {
 	/* Write a watchdog value */
 	outb_p(timeout, wdt_start);
 }
 
-static void
-advwdt_disable(void)
+static void advwdt_disable(void)
 {
 	inb_p(wdt_stop);
 }
 
-static int
-advwdt_set_heartbeat(int t)
+static int advwdt_set_heartbeat(int t)
 {
-	if ((t < 1) || (t > 63))
+	if (t < 1 || t > 63)
 		return -EINVAL;
-
 	timeout = t;
 	return 0;
 }
@@ -109,8 +110,8 @@ advwdt_set_heartbeat(int t)
  *	/dev/watchdog handling
  */
 
-static ssize_t
-advwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t advwdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -120,7 +121,7 @@ advwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *pp
 
 			for (i = 0; i != count; i++) {
 				char c;
-				if (get_user(c, buf+i))
+				if (get_user(c, buf + i))
 					return -EFAULT;
 				if (c == 'V')
 					adv_expect_close = 42;
@@ -131,9 +132,7 @@ advwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *pp
 	return count;
 }
 
-static int
-advwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long advwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
@@ -146,57 +145,50 @@ advwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  if (copy_to_user(argp, &ident, sizeof(ident)))
-	    return -EFAULT;
-	  break;
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
-
-	case WDIOC_KEEPALIVE:
-	  advwdt_ping();
-	  break;
-
-	case WDIOC_SETTIMEOUT:
-	  if (get_user(new_timeout, p))
-		  return -EFAULT;
-	  if (advwdt_set_heartbeat(new_timeout))
-		  return -EINVAL;
-	  advwdt_ping();
-	  /* Fall */
-
-	case WDIOC_GETTIMEOUT:
-	  return put_user(timeout, p);
+		return put_user(0, p);
 
 	case WDIOC_SETOPTIONS:
 	{
-	  int options, retval = -EINVAL;
-
-	  if (get_user(options, p))
-	    return -EFAULT;
-
-	  if (options & WDIOS_DISABLECARD) {
-	    advwdt_disable();
-	    retval = 0;
-	  }
+		int options, retval = -EINVAL;
 
-	  if (options & WDIOS_ENABLECARD) {
-	    advwdt_ping();
-	    retval = 0;
-	  }
-
-	  return retval;
+		if (get_user(options, p))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			advwdt_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			advwdt_ping();
+			retval = 0;
+		}
+		return retval;
 	}
+	case WDIOC_KEEPALIVE:
+		advwdt_ping();
+		break;
 
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (advwdt_set_heartbeat(new_timeout))
+			return -EINVAL;
+		advwdt_ping();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
 	default:
-	  return -ENOTTY;
+		return -ENOTTY;
 	}
 	return 0;
 }
 
-static int
-advwdt_open(struct inode *inode, struct file *file)
+static int advwdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &advwdt_is_open))
 		return -EBUSY;
@@ -208,13 +200,13 @@ advwdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static int
-advwdt_close(struct inode *inode, struct file *file)
+static int advwdt_close(struct inode *inode, struct file *file)
 {
 	if (adv_expect_close == 42) {
 		advwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+				"Unexpected close, not stopping watchdog!\n");
 		advwdt_ping();
 	}
 	clear_bit(0, &advwdt_is_open);
@@ -230,7 +222,7 @@ static const struct file_operations advwdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= advwdt_write,
-	.ioctl		= advwdt_ioctl,
+	.unlocked_ioctl	= advwdt_ioctl,
 	.open		= advwdt_open,
 	.release	= advwdt_close,
 };
@@ -245,23 +237,24 @@ static struct miscdevice advwdt_miscdev = {
  *	Init & exit routines
  */
 
-static int __devinit
-advwdt_probe(struct platform_device *dev)
+static int __devinit advwdt_probe(struct platform_device *dev)
 {
 	int ret;
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				wdt_stop);
+			printk(KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								wdt_stop);
 			ret = -EIO;
 			goto out;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_start);
+		printk(KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
@@ -269,20 +262,19 @@ advwdt_probe(struct platform_device *dev)
 	/* Check that the heartbeat value is within it's range ; if not reset to the default */
 	if (advwdt_set_heartbeat(timeout)) {
 		advwdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk (KERN_INFO PFX "timeout value must be 1<=x<=63, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+			"timeout value must be 1<=x<=63, using %d\n", timeout);
 	}
 
 	ret = misc_register(&advwdt_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-
-	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
-
 out:
 	return ret;
 unreg_regions:
@@ -293,19 +285,17 @@ unreg_stop:
 	goto out;
 }
 
-static int __devexit
-advwdt_remove(struct platform_device *dev)
+static int __devexit advwdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&advwdt_miscdev);
-	release_region(wdt_start,1);
-	if(wdt_stop != wdt_start)
-		release_region(wdt_stop,1);
+	release_region(wdt_start, 1);
+	if (wdt_stop != wdt_start)
+		release_region(wdt_stop, 1);
 
 	return 0;
 }
 
-static void
-advwdt_shutdown(struct platform_device *dev)
+static void advwdt_shutdown(struct platform_device *dev)
 {
 	/* Turn the WDT off if we have a soft shutdown */
 	advwdt_disable();
@@ -321,18 +311,19 @@ static struct platform_driver advwdt_driver = {
 	},
 };
 
-static int __init
-advwdt_init(void)
+static int __init advwdt_init(void)
 {
 	int err;
 
-	printk(KERN_INFO "WDT driver for Advantech single board computer initialising.\n");
+	printk(KERN_INFO
+	     "WDT driver for Advantech single board computer initialising.\n");
 
 	err = platform_driver_register(&advwdt_driver);
 	if (err)
 		return err;
 
-	advwdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	advwdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(advwdt_platform_device)) {
 		err = PTR_ERR(advwdt_platform_device);
 		goto unreg_platform_driver;
@@ -345,8 +336,7 @@ unreg_platform_driver:
 	return err;
 }
 
-static void __exit
-advwdt_exit(void)
+static void __exit advwdt_exit(void)
 {
 	platform_device_unregister(advwdt_platform_device);
 	platform_driver_unregister(&advwdt_driver);
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 2b1fbdb..2a7690e 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -18,9 +18,8 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/pci.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define WATCHDOG_NAME "ALi_M1535"
 #define PFX WATCHDOG_NAME ": "
@@ -30,17 +29,21 @@
 static unsigned long ali_is_open;
 static char ali_expect_release;
 static struct pci_dev *ali_pci;
-static u32 ali_timeout_bits;	/* stores the computed timeout */
+static u32 ali_timeout_bits;		/* stores the computed timeout */
 static DEFINE_SPINLOCK(ali_lock);	/* Guards the hardware */
 
 /* module parameters */
 static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (0<timeout<18000, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds. (0 < timeout < 18000, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	ali_start	-	start watchdog countdown
@@ -103,15 +106,16 @@ static void ali_keepalive(void)
 
 static int ali_settimer(int t)
 {
-	if(t < 0)
+	if (t < 0)
 		return -EINVAL;
-	else if(t < 60)
+	else if (t < 60)
 		ali_timeout_bits = t|(1<<6);
-	else if(t < 3600)
+	else if (t < 3600)
 		ali_timeout_bits = (t/60)|(1<<7);
-	else if(t < 18000)
+	else if (t < 18000)
 		ali_timeout_bits = (t/300)|(1<<6)|(1<<7);
-	else return -EINVAL;
+	else
+		return -EINVAL;
 
 	timeout = t;
 	return 0;
@@ -134,21 +138,22 @@ static int ali_settimer(int t)
  */
 
 static ssize_t ali_write(struct file *file, const char __user *data,
-			      size_t len, loff_t * ppos)
+			      size_t len, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
 	if (len) {
 		if (!nowayout) {
 			size_t i;
 
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
+			/* note: just in case someone wrote the
+			   magic character five months ago... */
 			ali_expect_release = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got
+			   the magic character */
 			for (i = 0; i != len; i++) {
 				char c;
-				if(get_user(c, data+i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					ali_expect_release = 42;
@@ -163,7 +168,6 @@ static ssize_t ali_write(struct file *file, const char __user *data,
 
 /*
  *	ali_ioctl	-	handle watchdog ioctls
- *	@inode: VFS inode
  *	@file: VFS file pointer
  *	@cmd: ioctl number
  *	@arg: arguments to the ioctl
@@ -172,8 +176,7 @@ static ssize_t ali_write(struct file *file, const char __user *data,
  *	we want an extension to enable irq ack monitoring and the like
  */
 
-static int ali_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long ali_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -186,57 +189,45 @@ static int ali_ioctl(struct inode *inode, struct file *file,
 	};
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof (ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_KEEPALIVE:
-			ali_keepalive();
-			return 0;
-
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
-
-			if (get_user (new_options, p))
-				return -EFAULT;
-
-			if (new_options & WDIOS_DISABLECARD) {
-				ali_stop();
-				retval = 0;
-			}
-
-			if (new_options & WDIOS_ENABLECARD) {
-				ali_start();
-				retval = 0;
-			}
-
-			return retval;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+	{
+		int new_options, retval = -EINVAL;
+
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			ali_stop();
+			retval = 0;
 		}
-
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_timeout;
-
-			if (get_user(new_timeout, p))
-				return -EFAULT;
-
-			if (ali_settimer(new_timeout))
-			    return -EINVAL;
-
-			ali_keepalive();
-			/* Fall */
+		if (new_options & WDIOS_ENABLECARD) {
+			ali_start();
+			retval = 0;
 		}
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
-
-		default:
-			return -ENOTTY;
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		ali_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (ali_settimer(new_timeout))
+			return -EINVAL;
+		ali_keepalive();
+		/* Fall */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -274,10 +265,11 @@ static int ali_release(struct inode *inode, struct file *file)
 	/*
 	 *      Shut off the timer.
 	 */
-	if (ali_expect_release == 42) {
+	if (ali_expect_release == 42)
 		ali_stop();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+				"Unexpected close, not stopping watchdog!\n");
 		ali_keepalive();
 	}
 	clear_bit(0, &ali_is_open);
@@ -292,13 +284,11 @@ static int ali_release(struct inode *inode, struct file *file)
  */
 
 
-static int ali_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int ali_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
-	if (code==SYS_DOWN || code==SYS_HALT) {
-		/* Turn the WDT off */
-		ali_stop();
-	}
-
+	if (code == SYS_DOWN || code == SYS_HALT)
+		ali_stop();		/* Turn the WDT off */
 	return NOTIFY_DONE;
 }
 
@@ -340,10 +330,10 @@ static int __init ali_find_watchdog(void)
 
 	/* Check for the a 7101 PMU */
 	pdev = pci_get_device(PCI_VENDOR_ID_AL, 0x7101, NULL);
-	if(pdev == NULL)
+	if (pdev == NULL)
 		return -ENODEV;
 
-	if(pci_enable_device(pdev)) {
+	if (pci_enable_device(pdev)) {
 		pci_dev_put(pdev);
 		return -EIO;
 	}
@@ -355,9 +345,12 @@ static int __init ali_find_watchdog(void)
 	 */
 	pci_read_config_dword(pdev, 0xCC, &wdog);
 
-	wdog &= ~0x3F;		/* Timer bits */
-	wdog &= ~((1<<27)|(1<<26)|(1<<25)|(1<<24));	/* Issued events */
-	wdog &= ~((1<<16)|(1<<13)|(1<<12)|(1<<11)|(1<<10)|(1<<9));	/* No monitor bits */
+	/* Timer bits */
+	wdog &= ~0x3F;
+	/* Issued events */
+	wdog &= ~((1<<27)|(1<<26)|(1<<25)|(1<<24));
+	/* No monitor bits */
+	wdog &= ~((1<<16)|(1<<13)|(1<<12)|(1<<11)|(1<<10)|(1<<9));
 
 	pci_write_config_dword(pdev, 0xCC, wdog);
 
@@ -369,12 +362,12 @@ static int __init ali_find_watchdog(void)
  */
 
 static const struct file_operations ali_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	no_llseek,
-	.write =	ali_write,
-	.ioctl =	ali_ioctl,
-	.open =		ali_open,
-	.release =	ali_release,
+	.owner 		=	THIS_MODULE,
+	.llseek 	=	no_llseek,
+	.write		=	ali_write,
+	.unlocked_ioctl =	ali_ioctl,
+	.open 		=	ali_open,
+	.release 	=	ali_release,
 };
 
 static struct miscdevice ali_miscdev = {
@@ -399,15 +392,16 @@ static int __init watchdog_init(void)
 	int ret;
 
 	/* Check whether or not the hardware watchdog is there */
-	if (ali_find_watchdog() != 0) {
+	if (ali_find_watchdog() != 0)
 		return -ENODEV;
-	}
 
-	/* Check that the timeout value is within it's range ; if not reset to the default */
+	/* Check that the timeout value is within it's range;
+	   if not reset to the default */
 	if (timeout < 1 || timeout >= 18000) {
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX "timeout value must be 0<timeout<18000, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+		     "timeout value must be 0 < timeout < 18000, using %d\n",
+							timeout);
 	}
 
 	/* Calculate the watchdog's timeout */
@@ -415,15 +409,16 @@ static int __init watchdog_init(void)
 
 	ret = register_reboot_notifier(&ali_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto out;
 	}
 
 	ret = misc_register(&ali_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 238273c..a045ef8 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -31,9 +31,9 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define OUR_NAME "alim7101_wdt"
@@ -60,13 +60,17 @@
  */
 
 #define WATCHDOG_TIMEOUT 30            /* 30 sec default timeout */
-static int timeout = WATCHDOG_TIMEOUT; /* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
-static int use_gpio = 0; /* Use the pic (for a1d revision alim7101) */
+static int use_gpio; /* Use the pic (for a1d revision alim7101) */
 module_param(use_gpio, int, 0);
-MODULE_PARM_DESC(use_gpio, "Use the gpio watchdog.  (required by old cobalt boards)");
+MODULE_PARM_DESC(use_gpio,
+		"Use the gpio watchdog (required by old cobalt boards).");
 
 static void wdt_timer_ping(unsigned long);
 static DEFINE_TIMER(timer, wdt_timer_ping, 0, 1);
@@ -77,8 +81,9 @@ static struct pci_dev *alim7101_pmu;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
-		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Whack the dog
@@ -89,23 +94,26 @@ static void wdt_timer_ping(unsigned long data)
 	/* If we got a heartbeat pulse within the WDT_US_INTERVAL
 	 * we agree to ping the WDT
 	 */
-	char	tmp;
+	char tmp;
 
-	if(time_before(jiffies, next_heartbeat))
-	{
+	if (time_before(jiffies, next_heartbeat)) {
 		/* Ping the WDT (this is actually a disarm/arm sequence) */
 		pci_read_config_byte(alim7101_pmu, 0x92, &tmp);
-		pci_write_config_byte(alim7101_pmu, ALI_7101_WDT, (tmp & ~ALI_WDT_ARM));
-		pci_write_config_byte(alim7101_pmu, ALI_7101_WDT, (tmp | ALI_WDT_ARM));
+		pci_write_config_byte(alim7101_pmu,
+					ALI_7101_WDT, (tmp & ~ALI_WDT_ARM));
+		pci_write_config_byte(alim7101_pmu,
+					ALI_7101_WDT, (tmp | ALI_WDT_ARM));
 		if (use_gpio) {
-			pci_read_config_byte(alim7101_pmu, ALI_7101_GPIO_O, &tmp);
-			pci_write_config_byte(alim7101_pmu, ALI_7101_GPIO_O, tmp
-					| 0x20);
-			pci_write_config_byte(alim7101_pmu, ALI_7101_GPIO_O, tmp
-					& ~0x20);
+			pci_read_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, &tmp);
+			pci_write_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, tmp | 0x20);
+			pci_write_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, tmp & ~0x20);
 		}
 	} else {
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
+		printk(KERN_WARNING PFX
+			"Heartbeat lost! Will not ping the watchdog\n");
 	}
 	/* Re-set the timer interval */
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
@@ -117,21 +125,27 @@ static void wdt_timer_ping(unsigned long data)
 
 static void wdt_change(int writeval)
 {
-	char	tmp;
+	char tmp;
 
 	pci_read_config_byte(alim7101_pmu, ALI_7101_WDT, &tmp);
 	if (writeval == WDT_ENABLE) {
-		pci_write_config_byte(alim7101_pmu, ALI_7101_WDT, (tmp | ALI_WDT_ARM));
+		pci_write_config_byte(alim7101_pmu,
+					ALI_7101_WDT, (tmp | ALI_WDT_ARM));
 		if (use_gpio) {
-			pci_read_config_byte(alim7101_pmu, ALI_7101_GPIO_O, &tmp);
-			pci_write_config_byte(alim7101_pmu, ALI_7101_GPIO_O, tmp & ~0x20);
+			pci_read_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, &tmp);
+			pci_write_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, tmp & ~0x20);
 		}
 
 	} else {
-		pci_write_config_byte(alim7101_pmu, ALI_7101_WDT, (tmp & ~ALI_WDT_ARM));
+		pci_write_config_byte(alim7101_pmu,
+					ALI_7101_WDT, (tmp & ~ALI_WDT_ARM));
 		if (use_gpio) {
-			pci_read_config_byte(alim7101_pmu, ALI_7101_GPIO_O, &tmp);
-			pci_write_config_byte(alim7101_pmu, ALI_7101_GPIO_O, tmp | 0x20);
+			pci_read_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, &tmp);
+			pci_write_config_byte(alim7101_pmu,
+					ALI_7101_GPIO_O, tmp | 0x20);
 		}
 	}
 }
@@ -169,10 +183,11 @@ static void wdt_keepalive(void)
  * /dev/watchdog handling
  */
 
-static ssize_t fop_write(struct file * file, const char __user * buf, size_t count, loff_t * ppos)
+static ssize_t fop_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count) {
+	if (count) {
 		if (!nowayout) {
 			size_t ofs;
 
@@ -183,7 +198,7 @@ static ssize_t fop_write(struct file * file, const char __user * buf, size_t cou
 			/* now scan */
 			for (ofs = 0; ofs != count; ofs++) {
 				char c;
-				if (get_user(c, buf+ofs))
+				if (get_user(c, buf + ofs))
 					return -EFAULT;
 				if (c == 'V')
 					wdt_expect_close = 42;
@@ -195,119 +210,116 @@ static ssize_t fop_write(struct file * file, const char __user * buf, size_t cou
 	return count;
 }
 
-static int fop_open(struct inode * inode, struct file * file)
+static int fop_open(struct inode *inode, struct file *file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 	/* Good, fire up the show */
 	wdt_startup();
 	return nonseekable_open(inode, file);
 }
 
-static int fop_close(struct inode * inode, struct file * file)
+static int fop_close(struct inode *inode, struct file *file)
 {
-	if(wdt_expect_close == 42)
+	if (wdt_expect_close == 42)
 		wdt_turnoff();
 	else {
 		/* wim: shouldn't there be a: del_timer(&timer); */
-		printk(KERN_CRIT PFX "device file closed unexpectedly. Will not stop the WDT!\n");
+		printk(KERN_CRIT PFX
+		  "device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
 	return 0;
 }
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident =
-	{
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "ALiM7101",
 	};
 
-	switch(cmd)
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
 	{
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident))?-EFAULT:0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			wdt_keepalive();
-			return 0;
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
-
-			if(get_user(new_options, p))
-				return -EFAULT;
-
-			if(new_options & WDIOS_DISABLECARD) {
-				wdt_turnoff();
-				retval = 0;
-			}
+		int new_options, retval = -EINVAL;
 
-			if(new_options & WDIOS_ENABLECARD) {
-				wdt_startup();
-				retval = 0;
-			}
-
-			return retval;
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			wdt_turnoff();
+			retval = 0;
 		}
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_timeout;
-
-			if(get_user(new_timeout, p))
-				return -EFAULT;
-
-			if(new_timeout < 1 || new_timeout > 3600) /* arbitrary upper limit */
-				return -EINVAL;
-
-			timeout = new_timeout;
-			wdt_keepalive();
-			/* Fall through */
+		if (new_options & WDIOS_ENABLECARD) {
+			wdt_startup();
+			retval = 0;
 		}
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
-		default:
-			return -ENOTTY;
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
+
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		/* arbitrary upper limit */
+		if (new_timeout < 1 || new_timeout > 3600)
+			return -EINVAL;
+		timeout = new_timeout;
+		wdt_keepalive();
+		/* Fall through */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
 static const struct file_operations wdt_fops = {
-	.owner=		THIS_MODULE,
-	.llseek=	no_llseek,
-	.write=		fop_write,
-	.open=		fop_open,
-	.release=	fop_close,
-	.ioctl=		fop_ioctl,
+	.owner		=	THIS_MODULE,
+	.llseek		=	no_llseek,
+	.write		=	fop_write,
+	.open		=	fop_open,
+	.release	=	fop_close,
+	.unlocked_ioctl	=	fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
-	.minor=WATCHDOG_MINOR,
-	.name="watchdog",
-	.fops=&wdt_fops,
+	.minor	=	WATCHDOG_MINOR,
+	.name	=	"watchdog",
+	.fops	=	&wdt_fops,
 };
 
 /*
  *	Notifier for system down
  */
 
-static int wdt_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int wdt_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
-	if (code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 
-	if (code==SYS_RESTART) {
+	if (code == SYS_RESTART) {
 		/*
-		 * Cobalt devices have no way of rebooting themselves other than
-		 * getting the watchdog to pull reset, so we restart the watchdog on
-		 * reboot with no heartbeat
+		 * Cobalt devices have no way of rebooting themselves other
+		 * than getting the watchdog to pull reset, so we restart the
+		 * watchdog on reboot with no heartbeat
 		 */
 		wdt_change(WDT_ENABLE);
 		printk(KERN_INFO PFX "Watchdog timer is now enabled with no heartbeat - should reboot in ~1 second.\n");
@@ -320,8 +332,7 @@ static int wdt_notify_sys(struct notifier_block *this, unsigned long code, void
  *	turn the timebomb registers off.
  */
 
-static struct notifier_block wdt_notifier=
-{
+static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
@@ -354,7 +365,8 @@ static int __init alim7101_wdt_init(void)
 	ali1543_south = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533,
 		NULL);
 	if (!ali1543_south) {
-		printk(KERN_INFO PFX "ALi 1543 South-Bridge not present - WDT not set\n");
+		printk(KERN_INFO PFX
+			"ALi 1543 South-Bridge not present - WDT not set\n");
 		goto err_out;
 	}
 	pci_read_config_byte(ali1543_south, 0x5e, &tmp);
@@ -363,24 +375,25 @@ static int __init alim7101_wdt_init(void)
 		if (!use_gpio) {
 			printk(KERN_INFO PFX "Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.\n");
 			goto err_out;
-		} 
+		}
 		nowayout = 1;
 	} else if ((tmp & 0x1e) != 0x12 && (tmp & 0x1e) != 0x00) {
 		printk(KERN_INFO PFX "ALi 1543 South-Bridge does not have the correct revision number (???1001?) - WDT not set\n");
 		goto err_out;
 	}
 
-	if(timeout < 1 || timeout > 3600) /* arbitrary upper limit */
-	{
+	if (timeout < 1 || timeout > 3600) {
+		/* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX "timeout value must be 1<=x<=3600, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+			"timeout value must be 1 <= x <= 3600, using %d\n",
+								timeout);
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out;
 	}
 
@@ -391,9 +404,8 @@ static int __init alim7101_wdt_init(void)
 		goto err_out_reboot;
 	}
 
-	if (nowayout) {
+	if (nowayout)
 		__module_get(THIS_MODULE);
-	}
 
 	printk(KERN_INFO PFX "WDT driver for ALi M7101 initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index ef7b0d6..55dcbfe 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -213,7 +213,7 @@ static int ar7_wdt_notify_sys(struct notifier_block *this,
 }
 
 static struct notifier_block ar7_wdt_notifier = {
-	.notifier_call = ar7_wdt_notify_sys
+	.notifier_call = ar7_wdt_notify_sys,
 };
 
 static ssize_t ar7_wdt_write(struct file *file, const char *data,
@@ -230,7 +230,7 @@ static ssize_t ar7_wdt_write(struct file *file, const char *data,
 		expect_close = 0;
 		for (i = 0; i < len; ++i) {
 			char c;
-			if (get_user(c, data+i))
+			if (get_user(c, data + i))
 				return -EFAULT;
 			if (c == 'V')
 				expect_close = 1;
@@ -251,8 +251,6 @@ static long ar7_wdt_ioctl(struct file *file,
 	int new_margin;
 
 	switch (cmd) {
-	default:
-		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
 		if (copy_to_user((struct watchdog_info *)arg, &ident,
 				sizeof(ident)))
@@ -281,6 +279,8 @@ static long ar7_wdt_ioctl(struct file *file,
 		if (put_user(margin, (int *)arg))
 			return -EFAULT;
 		return 0;
+	default:
+		return -ENOTTY;
 	}
 }
 
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index ae0fca5..e8ae638 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -212,8 +212,8 @@ static struct watchdog_info at32_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static int at32_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long at32_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -221,27 +221,10 @@ static int at32_wdt_ioctl(struct inode *inode, struct file *file,
 	int __user *p = argp;
 
 	switch (cmd) {
-	case WDIOC_KEEPALIVE:
-		at32_wdt_pat();
-		ret = 0;
-		break;
 	case WDIOC_GETSUPPORT:
 		ret = copy_to_user(argp, &at32_wdt_info,
 				sizeof(at32_wdt_info)) ? -EFAULT : 0;
 		break;
-	case WDIOC_SETTIMEOUT:
-		ret = get_user(time, p);
-		if (ret)
-			break;
-		ret = at32_wdt_settimeout(time);
-		if (ret)
-			break;
-		/* Enable new time value */
-		at32_wdt_start();
-		/* fall through */
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(wdt->timeout, p);
-		break;
 	case WDIOC_GETSTATUS:
 		ret = put_user(0, p);
 		break;
@@ -258,6 +241,23 @@ static int at32_wdt_ioctl(struct inode *inode, struct file *file,
 			at32_wdt_start();
 		ret = 0;
 		break;
+	case WDIOC_KEEPALIVE:
+		at32_wdt_pat();
+		ret = 0;
+		break;
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, p);
+		if (ret)
+			break;
+		ret = at32_wdt_settimeout(time);
+		if (ret)
+			break;
+		/* Enable new time value */
+		at32_wdt_start();
+		/* fall through */
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(wdt->timeout, p);
+		break;
 	}
 
 	return ret;
@@ -283,7 +283,7 @@ static ssize_t at32_wdt_write(struct file *file, const char __user *data,
 			 */
 			for (i = 0; i != len; i++) {
 				char c;
-				if (get_user(c, data+i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_release = 42;
@@ -298,7 +298,7 @@ static ssize_t at32_wdt_write(struct file *file, const char __user *data,
 static const struct file_operations at32_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= at32_wdt_ioctl,
+	.unlocked_ioctl	= at32_wdt_ioctl,
 	.open		= at32_wdt_open,
 	.release	= at32_wdt_close,
 	.write		= at32_wdt_write,
@@ -391,7 +391,6 @@ static int __exit at32_wdt_remove(struct platform_device *pdev)
 		wdt = NULL;
 		platform_set_drvdata(pdev, NULL);
 	}
-
 	return 0;
 }
 
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index 9ff9a95..2313f44 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -20,7 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/arch/at91_st.h>
 
 
@@ -31,11 +31,14 @@ static int wdt_time = WDT_DEFAULT_TIME;
 static int nowayout = WATCHDOG_NOWAYOUT;
 
 module_param(wdt_time, int, 0);
-MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="__MODULE_STRING(WDT_DEFAULT_TIME) ")");
+MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
+				__MODULE_STRING(WDT_DEFAULT_TIME) ")");
 
 #ifdef CONFIG_WATCHDOG_NOWAYOUT
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 #endif
 
 
@@ -46,7 +49,7 @@ static unsigned long at91wdt_busy;
 /*
  * Disable the watchdog.
  */
-static void inline at91_wdt_stop(void)
+static inline void at91_wdt_stop(void)
 {
 	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN);
 }
@@ -54,16 +57,17 @@ static void inline at91_wdt_stop(void)
 /*
  * Enable and reset the watchdog.
  */
-static void inline at91_wdt_start(void)
+static inline void at91_wdt_start(void)
 {
-	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN | AT91_ST_RSTEN | (((65536 * wdt_time) >> 8) & AT91_ST_WDV));
+	at91_sys_write(AT91_ST_WDMR, AT91_ST_EXTEN | AT91_ST_RSTEN |
+				(((65536 * wdt_time) >> 8) & AT91_ST_WDV));
 	at91_sys_write(AT91_ST_CR, AT91_ST_WDRST);
 }
 
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
-static void inline at91_wdt_reload(void)
+static inline void at91_wdt_reload(void)
 {
 	at91_sys_write(AT91_ST_CR, AT91_ST_WDRST);
 }
@@ -89,8 +93,9 @@ static int at91_wdt_open(struct inode *inode, struct file *file)
  */
 static int at91_wdt_close(struct inode *inode, struct file *file)
 {
+	/* Disable the watchdog when file is closed */
 	if (!nowayout)
-		at91_wdt_stop();	/* Disable the watchdog when file is closed */
+		at91_wdt_stop();
 
 	clear_bit(0, &at91wdt_busy);
 	return 0;
@@ -110,7 +115,8 @@ static int at91_wdt_settimeout(int new_time)
 	if ((new_time <= 0) || (new_time > WDT_MAX_TIME))
 		return -EINVAL;
 
-	/* Set new watchdog time. It will be used when at91_wdt_start() is called. */
+	/* Set new watchdog time. It will be used when
+	   at91_wdt_start() is called. */
 	wdt_time = new_time;
 	return 0;
 }
@@ -123,60 +129,52 @@ static struct watchdog_info at91_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static int at91_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long at91_wdt_ioct(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_value;
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			at91_wdt_reload();	/* pat the watchdog */
-			return 0;
-
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &at91_wdt_info, sizeof(at91_wdt_info)) ? -EFAULT : 0;
-
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_value, p))
-				return -EFAULT;
-
-			if (at91_wdt_settimeout(new_value))
-				return -EINVAL;
-
-			/* Enable new time value */
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &at91_wdt_info,
+				sizeof(at91_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (new_value & WDIOS_DISABLECARD)
+			at91_wdt_stop();
+		if (new_value & WDIOS_ENABLECARD)
 			at91_wdt_start();
-
-			/* Return current value */
-			return put_user(wdt_time, p);
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(wdt_time, p);
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_SETOPTIONS:
-			if (get_user(new_value, p))
-				return -EFAULT;
-
-			if (new_value & WDIOS_DISABLECARD)
-				at91_wdt_stop();
-			if (new_value & WDIOS_ENABLECARD)
-				at91_wdt_start();
-			return 0;
-
-		default:
-			return -ENOTTY;
+		return 0;
+	case WDIOC_KEEPALIVE:
+		at91_wdt_reload();	/* pat the watchdog */
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (at91_wdt_settimeout(new_value))
+			return -EINVAL;
+		/* Enable new time value */
+		at91_wdt_start();
+		/* Return current value */
+		return put_user(wdt_time, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt_time, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
 /*
  * Pat the watchdog whenever device is written to.
  */
-static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t at91_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	at91_wdt_reload();		/* pat the watchdog */
 	return len;
@@ -187,7 +185,7 @@ static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len, l
 static const struct file_operations at91wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= at91_wdt_ioctl,
+	.unlocked_ioctl	= at91_wdt_ioctl,
 	.open		= at91_wdt_open,
 	.release	= at91_wdt_close,
 	.write		= at91_wdt_write,
@@ -211,7 +209,8 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	if (res)
 		return res;
 
-	printk("AT91 Watchdog Timer enabled (%d seconds%s)\n", wdt_time, nowayout ? ", nowayout" : "");
+	printk(KERN_INFO "AT91 Watchdog Timer enabled (%d seconds%s)\n",
+				wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
@@ -265,7 +264,8 @@ static struct platform_driver at91wdt_driver = {
 
 static int __init at91_wdt_init(void)
 {
-	/* Check that the heartbeat value is within range; if not reset to the default */
+	/* Check that the heartbeat value is within range;
+	   if not reset to the default */
 	if (at91_wdt_settimeout(wdt_time)) {
 		at91_wdt_settimeout(WDT_DEFAULT_TIME);
 		pr_info("at91_wdt: wdt_time value must be 1 <= wdt_time <= 256, using %d\n", wdt_time);
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 03b3e3d..31b4225 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -24,8 +24,8 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/uaccess.h>
 #include <asm/blackfin.h>
-#include <asm/uaccess.h>
 
 #define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
@@ -148,7 +148,8 @@ static int bfin_wdt_set_timeout(unsigned long t)
 		int run = bfin_wdt_running();
 		bfin_wdt_stop();
 		bfin_write_WDOG_CNT(cnt);
-		if (run) bfin_wdt_start();
+		if (run)
+			bfin_wdt_start();
 	}
 	spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
 
@@ -191,16 +192,15 @@ static int bfin_wdt_release(struct inode *inode, struct file *file)
 {
 	stampit();
 
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		bfin_wdt_stop();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		bfin_wdt_keepalive();
 	}
-
 	expect_close = 0;
 	clear_bit(0, &open_check);
-
 	return 0;
 }
 
@@ -214,7 +214,7 @@ static int bfin_wdt_release(struct inode *inode, struct file *file)
  *	Pings the watchdog on write.
  */
 static ssize_t bfin_wdt_write(struct file *file, const char __user *data,
-                              size_t len, loff_t *ppos)
+						size_t len, loff_t *ppos)
 {
 	stampit();
 
@@ -241,7 +241,6 @@ static ssize_t bfin_wdt_write(struct file *file, const char __user *data,
 
 /**
  *	bfin_wdt_ioctl - Query Device
- *	@inode: inode of device
  *	@file: file handle of device
  *	@cmd: watchdog command
  *	@arg: argument
@@ -249,8 +248,8 @@ static ssize_t bfin_wdt_write(struct file *file, const char __user *data,
  *	Query basic information from the device or ping it, as outlined by the
  *	watchdog API.
  */
-static int bfin_wdt_ioctl(struct inode *inode, struct file *file,
-                          unsigned int cmd, unsigned long arg)
+static long bfin_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -258,59 +257,49 @@ static int bfin_wdt_ioctl(struct inode *inode, struct file *file,
 	stampit();
 
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-
-		case WDIOC_GETSUPPORT:
-			if (copy_to_user(argp, &bfin_wdt_info, sizeof(bfin_wdt_info)))
-				return -EFAULT;
-			else
-				return 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(!!(_bfin_swrst & SWRST_RESET_WDOG), p);
-
-		case WDIOC_KEEPALIVE:
-			bfin_wdt_keepalive();
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &bfin_wdt_info, sizeof(bfin_wdt_info)))
+			return -EFAULT;
+		else
 			return 0;
-
-		case WDIOC_SETTIMEOUT: {
-			int new_timeout;
-
-			if (get_user(new_timeout, p))
-				return -EFAULT;
-
-			if (bfin_wdt_set_timeout(new_timeout))
-				return -EINVAL;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(!!(_bfin_swrst & SWRST_RESET_WDOG), p);
+	case WDIOC_SETOPTIONS: {
+		unsigned long flags;
+		int options, ret = -EINVAL;
+
+		if (get_user(options, p))
+			return -EFAULT;
+
+		spin_lock_irqsave(&bfin_wdt_spinlock, flags);
+		if (options & WDIOS_DISABLECARD) {
+			bfin_wdt_stop();
+			ret = 0;
 		}
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
-
-		case WDIOC_SETOPTIONS: {
-			unsigned long flags;
-			int options, ret = -EINVAL;
-
-			if (get_user(options, p))
-				return -EFAULT;
-
-			spin_lock_irqsave(&bfin_wdt_spinlock, flags);
-
-			if (options & WDIOS_DISABLECARD) {
-				bfin_wdt_stop();
-				ret = 0;
-			}
-
-			if (options & WDIOS_ENABLECARD) {
-				bfin_wdt_start();
-				ret = 0;
-			}
-
-			spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
-
-			return ret;
+		if (options & WDIOS_ENABLECARD) {
+			bfin_wdt_start();
+			ret = 0;
 		}
+		spin_unlock_irqrestore(&bfin_wdt_spinlock, flags);
+		return ret;
+	}
+	case WDIOC_KEEPALIVE:
+		bfin_wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT: {
+		int new_timeout;
+
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (bfin_wdt_set_timeout(new_timeout))
+			return -EINVAL;
+	}
+	/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -323,8 +312,8 @@ static int bfin_wdt_ioctl(struct inode *inode, struct file *file,
  *	Handles specific events, such as turning off the watchdog during a
  *	shutdown event.
  */
-static int bfin_wdt_notify_sys(struct notifier_block *this, unsigned long code,
-                               void *unused)
+static int bfin_wdt_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
 	stampit();
 
@@ -379,12 +368,12 @@ static int bfin_wdt_resume(struct platform_device *pdev)
 #endif
 
 static const struct file_operations bfin_wdt_fops = {
-	.owner    = THIS_MODULE,
-	.llseek   = no_llseek,
-	.write    = bfin_wdt_write,
-	.ioctl    = bfin_wdt_ioctl,
-	.open     = bfin_wdt_open,
-	.release  = bfin_wdt_release,
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write    	= bfin_wdt_write,
+	.unlocked_ioctl	= bfin_wdt_ioctl,
+	.open		= bfin_wdt_open,
+	.release	= bfin_wdt_release,
 };
 
 static struct miscdevice bfin_wdt_miscdev = {
@@ -396,8 +385,8 @@ static struct miscdevice bfin_wdt_miscdev = {
 static struct watchdog_info bfin_wdt_info = {
 	.identity = "Blackfin Watchdog",
 	.options  = WDIOF_SETTIMEOUT |
-	            WDIOF_KEEPALIVEPING |
-	            WDIOF_MAGICCLOSE,
+		    WDIOF_KEEPALIVEPING |
+		    WDIOF_MAGICCLOSE,
 };
 
 static struct notifier_block bfin_wdt_notifier = {
@@ -416,14 +405,16 @@ static int __devinit bfin_wdt_probe(struct platform_device *pdev)
 
 	ret = register_reboot_notifier(&bfin_wdt_notifier);
 	if (ret) {
-		pr_devinit(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		pr_devinit(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&bfin_wdt_miscdev);
 	if (ret) {
-		pr_devinit(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-		       WATCHDOG_MINOR, ret);
+		pr_devinit(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+				WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&bfin_wdt_notifier);
 		return ret;
 	}
@@ -516,7 +507,11 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(timeout, uint, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=((2^32)/SCLK), default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=((2^32)/SCLK), default="
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 7708244..c3b78a7 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -18,9 +18,9 @@
 #include <linux/miscdevice.h>
 #include <linux/notifier.h>
 #include <linux/watchdog.h>
+#include <linux/uaccess.h>
 
 #include <asm/reg_booke.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 /* If the kernel parameter wdt=1, the watchdog will be enabled at boot.
@@ -32,7 +32,7 @@
  */
 
 #ifdef	CONFIG_FSL_BOOKE
-#define WDT_PERIOD_DEFAULT 63	/* Ex. wdt_period=28 bus=333Mhz , reset=~40sec */
+#define WDT_PERIOD_DEFAULT 63	/* Ex. wdt_period=28 bus=333Mhz,reset=~40sec */
 #else
 #define WDT_PERIOD_DEFAULT 3	/* Refer to the PPC40x and PPC4xx manuals */
 #endif				/* for timing information */
@@ -82,16 +82,15 @@ static struct watchdog_info ident = {
 	.identity = "PowerPC Book-E Watchdog",
 };
 
-static int booke_wdt_ioctl(struct inode *inode, struct file *file,
-			    unsigned int cmd, unsigned long arg)
+static long booke_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	u32 tmp = 0;
 	u32 __user *p = (u32 __user *)arg;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user((struct watchdog_info __user *)arg, &ident,
-				sizeof(struct watchdog_info)))
+		if (copy_to_user(arg, &ident, sizeof(struct watchdog_info)))
 			return -EFAULT;
 	case WDIOC_GETSTATUS:
 		return put_user(ident.options, p);
@@ -100,16 +99,6 @@ static int booke_wdt_ioctl(struct inode *inode, struct file *file,
 		tmp = mfspr(SPRN_TSR) & TSR_WRS(3);
 		/* returns 1 if last reset was caused by the WDT */
 		return (tmp ? 1 : 0);
-	case WDIOC_KEEPALIVE:
-		booke_wdt_ping();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(booke_wdt_period, p))
-			return -EFAULT;
-		mtspr(SPRN_TCR, (mfspr(SPRN_TCR)&~WDTP(0))|WDTP(booke_wdt_period));
-		return 0;
-	case WDIOC_GETTIMEOUT:
-		return put_user(booke_wdt_period, p);
 	case WDIOC_SETOPTIONS:
 		if (get_user(tmp, p))
 			return -EINVAL;
@@ -119,6 +108,17 @@ static int booke_wdt_ioctl(struct inode *inode, struct file *file,
 		} else
 			return -EINVAL;
 		return 0;
+	case WDIOC_KEEPALIVE:
+		booke_wdt_ping();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(booke_wdt_period, p))
+			return -EFAULT;
+		mtspr(SPRN_TCR, (mfspr(SPRN_TCR) & ~WDTP(0)) |
+						WDTP(booke_wdt_period));
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(booke_wdt_period, p);
 	default:
 		return -ENOTTY;
 	}
@@ -132,8 +132,9 @@ static int booke_wdt_open(struct inode *inode, struct file *file)
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
 		on_each_cpu(__booke_wdt_enable, NULL, 0);
-		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
-				"(wdt_period=%d)\n", booke_wdt_period);
+		printk(KERN_INFO
+		      "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
+				booke_wdt_period);
 	}
 	spin_unlock(&booke_wdt_lock);
 
@@ -144,7 +145,7 @@ static const struct file_operations booke_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = booke_wdt_write,
-	.ioctl = booke_wdt_ioctl,
+	.unlocked_ioctl = booke_wdt_ioctl,
 	.open = booke_wdt_open,
 };
 
@@ -175,8 +176,9 @@ static int __init booke_wdt_init(void)
 
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
-		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
-				"(wdt_period=%d)\n", booke_wdt_period);
+		printk(KERN_INFO
+		      "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
+				booke_wdt_period);
 		on_each_cpu(__booke_wdt_enable, NULL, 0);
 	}
 	spin_unlock(&booke_wdt_lock);
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index df72f90..71f6d7e 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -30,16 +30,16 @@
 #include <linux/timer.h>
 #include <linux/completion.h>
 #include <linux/jiffies.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <linux/watchdog.h>
 
 /* adjustable parameters */
 
-static int verbose = 0;
+static int verbose;
 static int port = 0x91;
 static int ticks = 10000;
+static spinlock_t cpu5wdt_lock;
 
 #define PFX			"cpu5wdt: "
 
@@ -70,12 +70,13 @@ static struct {
 
 static void cpu5wdt_trigger(unsigned long unused)
 {
-	if ( verbose > 2 )
+	if (verbose > 2)
 		printk(KERN_DEBUG PFX "trigger at %i ticks\n", ticks);
 
-	if( cpu5wdt_device.running )
+	if (cpu5wdt_device.running)
 		ticks--;
 
+	spin_lock(&cpu5wdt_lock);
 	/* keep watchdog alive */
 	outb(1, port + CPU5WDT_TRIGGER_REG);
 
@@ -86,6 +87,7 @@ static void cpu5wdt_trigger(unsigned long unused)
 		/* ticks doesn't matter anyway */
 		complete(&cpu5wdt_device.stop);
 	}
+	spin_unlock(&cpu5wdt_lock);
 
 }
 
@@ -93,14 +95,17 @@ static void cpu5wdt_reset(void)
 {
 	ticks = cpu5wdt_device.default_ticks;
 
-	if ( verbose )
+	if (verbose)
 		printk(KERN_DEBUG PFX "reset (%i ticks)\n", (int) ticks);
 
 }
 
 static void cpu5wdt_start(void)
 {
-	if ( !cpu5wdt_device.queue ) {
+	unsigned long flags;
+
+	spin_lock_irqsave(&cpu5wdt_lock, flags);
+	if (!cpu5wdt_device.queue) {
 		cpu5wdt_device.queue = 1;
 		outb(0, port + CPU5WDT_TIME_A_REG);
 		outb(0, port + CPU5WDT_TIME_B_REG);
@@ -111,18 +116,20 @@ static void cpu5wdt_start(void)
 	}
 	/* if process dies, counter is not decremented */
 	cpu5wdt_device.running++;
+	spin_unlock_irqrestore(&cpu5wdt_lock, flags);
 }
 
 static int cpu5wdt_stop(void)
 {
-	if ( cpu5wdt_device.running )
-		cpu5wdt_device.running = 0;
+	unsigned long flags;
 
+	spin_lock_irqsave(&cpu5wdt_lock, flags);
+	if (cpu5wdt_device.running)
+		cpu5wdt_device.running = 0;
 	ticks = cpu5wdt_device.default_ticks;
-
-	if ( verbose )
+	spin_unlock_irqrestore(&cpu5wdt_lock, flags);
+	if (verbose)
 		printk(KERN_CRIT PFX "stop not possible\n");
-
 	return -EIO;
 }
 
@@ -130,9 +137,8 @@ static int cpu5wdt_stop(void)
 
 static int cpu5wdt_open(struct inode *inode, struct file *file)
 {
-	if ( test_and_set_bit(0, &cpu5wdt_device.inuse) )
+	if (test_and_set_bit(0, &cpu5wdt_device.inuse))
 		return -EBUSY;
-
 	return nonseekable_open(inode, file);
 }
 
@@ -142,67 +148,58 @@ static int cpu5wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int cpu5wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long cpu5wdt_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
 	unsigned int value;
-	static struct watchdog_info ident =
-	{
+	static struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "CPU5 WDT",
 	};
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			cpu5wdt_reset();
-			break;
-		case WDIOC_GETSTATUS:
-			value = inb(port + CPU5WDT_STATUS_REG);
-			value = (value >> 2) & 1;
-			if ( copy_to_user(argp, &value, sizeof(int)) )
-				return -EFAULT;
-			break;
-		case WDIOC_GETBOOTSTATUS:
-			if ( copy_to_user(argp, &value, sizeof(int)) )
-				return -EFAULT;
-			break;
-		case WDIOC_GETSUPPORT:
-			if ( copy_to_user(argp, &ident, sizeof(ident)) )
-				return -EFAULT;
-			break;
-		case WDIOC_SETOPTIONS:
-			if ( copy_from_user(&value, argp, sizeof(int)) )
-				return -EFAULT;
-			switch(value) {
-				case WDIOS_ENABLECARD:
-					cpu5wdt_start();
-					break;
-				case WDIOS_DISABLECARD:
-					return cpu5wdt_stop();
-				default:
-					return -EINVAL;
-			}
-			break;
-		default:
-    			return -ENOTTY;
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_GETSTATUS:
+		value = inb(port + CPU5WDT_STATUS_REG);
+		value = (value >> 2) & 1;
+		return put_user(value, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(value, p))
+			return -EFAULT;
+		if (value & WDIOS_ENABLECARD)
+			cpu5wdt_start();
+		if (value & WDIOS_DISABLECARD)
+			cpu5wdt_stop();
+		break;
+	case WDIOC_KEEPALIVE:
+		cpu5wdt_reset();
+		break;
+	default:
+		return -ENOTTY;
 	}
 	return 0;
 }
 
-static ssize_t cpu5wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t cpu5wdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
-	if ( !count )
+	if (!count)
 		return -EIO;
-
 	cpu5wdt_reset();
-
 	return count;
 }
 
 static const struct file_operations cpu5wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= cpu5wdt_ioctl,
+	.unlocked_ioctl	= cpu5wdt_ioctl,
 	.open		= cpu5wdt_open,
 	.write		= cpu5wdt_write,
 	.release	= cpu5wdt_release,
@@ -221,37 +218,36 @@ static int __devinit cpu5wdt_init(void)
 	unsigned int val;
 	int err;
 
-	if ( verbose )
-		printk(KERN_DEBUG PFX "port=0x%x, verbose=%i\n", port, verbose);
+	if (verbose)
+		printk(KERN_DEBUG PFX
+				"port=0x%x, verbose=%i\n", port, verbose);
 
-	if ( !request_region(port, CPU5WDT_EXTENT, PFX) ) {
+	init_completion(&cpu5wdt_device.stop);
+	spin_lock_init(&cpu5wdt_lock);
+	cpu5wdt_device.queue = 0;
+	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
+	cpu5wdt_device.default_ticks = ticks;
+
+	if (!request_region(port, CPU5WDT_EXTENT, PFX)) {
 		printk(KERN_ERR PFX "request_region failed\n");
 		err = -EBUSY;
 		goto no_port;
 	}
 
-	if ( (err = misc_register(&cpu5wdt_misc)) < 0 ) {
-		printk(KERN_ERR PFX "misc_register failed\n");
-		goto no_misc;
-	}
-
 	/* watchdog reboot? */
 	val = inb(port + CPU5WDT_STATUS_REG);
 	val = (val >> 2) & 1;
-	if ( !val )
+	if (!val)
 		printk(KERN_INFO PFX "sorry, was my fault\n");
 
-	init_completion(&cpu5wdt_device.stop);
-	cpu5wdt_device.queue = 0;
-
-	clear_bit(0, &cpu5wdt_device.inuse);
-
-	setup_timer(&cpu5wdt_device.timer, cpu5wdt_trigger, 0);
+	err = misc_register(&cpu5wdt_misc);
+	if (err < 0) {
+		printk(KERN_ERR PFX "misc_register failed\n");
+		goto no_misc;
+	}
 
-	cpu5wdt_device.default_ticks = ticks;
 
 	printk(KERN_INFO PFX "init success\n");
-
 	return 0;
 
 no_misc:
@@ -267,7 +263,7 @@ static int __devinit cpu5wdt_init_module(void)
 
 static void __devexit cpu5wdt_exit(void)
 {
-	if ( cpu5wdt_device.queue ) {
+	if (cpu5wdt_device.queue) {
 		cpu5wdt_device.queue = 0;
 		wait_for_completion(&cpu5wdt_device.stop);
 	}
diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 1782c79..802aeba 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -22,10 +22,10 @@
 #include <linux/bitops.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
 
 #define MODULE_NAME "DAVINCI-WDT: "
 
@@ -143,9 +143,8 @@ static struct watchdog_info ident = {
 	.identity = "DaVinci Watchdog",
 };
 
-static int
-davinci_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		  unsigned long arg)
+static long davinci_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 
@@ -160,14 +159,14 @@ davinci_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		ret = put_user(0, (int *)arg);
 		break;
 
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(heartbeat, (int *)arg);
-		break;
-
 	case WDIOC_KEEPALIVE:
 		wdt_service();
 		ret = 0;
 		break;
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(heartbeat, (int *)arg);
+		break;
 	}
 	return ret;
 }
@@ -184,7 +183,7 @@ static const struct file_operations davinci_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = davinci_wdt_write,
-	.ioctl = davinci_wdt_ioctl,
+	.unlocked_ioctl = davinci_wdt_ioctl,
 	.open = davinci_wdt_open,
 	.release = davinci_wdt_release,
 };
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index 0e4787a..07b74a7 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -28,9 +28,9 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/timer.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 #define WDT_VERSION	"0.3"
 #define PFX		"ep93xx_wdt: "
@@ -136,9 +136,8 @@ static struct watchdog_info ident = {
 	.identity = "EP93xx Watchdog",
 };
 
-static int
-ep93xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		 unsigned long arg)
+static long ep93xx_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 
@@ -156,15 +155,15 @@ ep93xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		ret = put_user(boot_status, (int __user *)arg);
 		break;
 
-	case WDIOC_GETTIMEOUT:
-		/* actually, it is 0.250 seconds.... */
-		ret = put_user(1, (int __user *)arg);
-		break;
-
 	case WDIOC_KEEPALIVE:
 		wdt_keepalive();
 		ret = 0;
 		break;
+
+	case WDIOC_GETTIMEOUT:
+		/* actually, it is 0.250 seconds.... */
+		ret = put_user(1, (int __user *)arg);
+		break;
 	}
 	return ret;
 }
@@ -174,8 +173,8 @@ static int ep93xx_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_shutdown();
 	else
-		printk(KERN_CRIT PFX "Device closed unexpectedly - "
-			"timer will not stop\n");
+		printk(KERN_CRIT PFX
+			"Device closed unexpectedly - timer will not stop\n");
 
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
@@ -186,7 +185,7 @@ static int ep93xx_wdt_release(struct inode *inode, struct file *file)
 static const struct file_operations ep93xx_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ep93xx_wdt_write,
-	.ioctl		= ep93xx_wdt_ioctl,
+	.unlocked_ioctl	= ep93xx_wdt_ioctl,
 	.open		= ep93xx_wdt_open,
 	.release	= ep93xx_wdt_release,
 };
@@ -243,7 +242,9 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 MODULE_AUTHOR("Ray Lehtiniemi <rayl@mail.com>,"
 		"Alessandro Zummo <a.zummo@towertech.it>");
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index b14e9d1..bbd14e3 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -56,14 +56,15 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static unsigned long eurwdt_is_open;
 static int eurwdt_timeout;
 static char eur_expect_close;
+static spinlock_t eurwdt_lock;
 
 /*
  * You must set these - there is no sane way to probe for this board.
@@ -78,7 +79,9 @@ static char *ev = "int";
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Some symbolic names
@@ -137,7 +140,8 @@ static void eurwdt_activate_timer(void)
 {
 	eurwdt_disable_timer();
 	eurwdt_write_reg(WDT_CTRL_REG, 0x01);	/* activate the WDT */
-	eurwdt_write_reg(WDT_OUTPIN_CFG, !strcmp("int", ev) ? WDT_EVENT_INT : WDT_EVENT_REBOOT);
+	eurwdt_write_reg(WDT_OUTPIN_CFG,
+		!strcmp("int", ev) ? WDT_EVENT_INT : WDT_EVENT_REBOOT);
 
 	/* Setting interrupt line */
 	if (irq == 2 || irq > 15 || irq < 0) {
@@ -206,21 +210,21 @@ size_t count, loff_t *ppos)
 
 			for (i = 0; i != count; i++) {
 				char c;
-				if(get_user(c, buf+i))
+				if (get_user(c, buf + i))
 					return -EFAULT;
 				if (c == 'V')
 					eur_expect_close = 42;
 			}
 		}
+		spin_lock(&eurwdt_lock);
 		eurwdt_ping();	/* the default timeout */
+		spin_unlock(&eurwdt_lock);
 	}
-
 	return count;
 }
 
 /**
  * eurwdt_ioctl:
- * @inode: inode of the device
  * @file: file handle to the device
  * @cmd: watchdog command
  * @arg: argument pointer
@@ -229,13 +233,14 @@ size_t count, loff_t *ppos)
  * according to their available features.
  */
 
-static int eurwdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long eurwdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	static struct watchdog_info ident = {
-		.options	  = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.options	  = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity	  = "WDT Eurotech CPU-1220/1410",
 	};
@@ -243,10 +248,7 @@ static int eurwdt_ioctl(struct inode *inode, struct file *file,
 	int time;
 	int options, retval = -EINVAL;
 
-	switch(cmd) {
-	default:
-		return -ENOTTY;
-
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
 
@@ -254,8 +256,26 @@ static int eurwdt_ioctl(struct inode *inode, struct file *file,
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 
+	case WDIOC_SETOPTIONS:
+		if (get_user(options, p))
+			return -EFAULT;
+		spin_lock(&eurwdt_lock);
+		if (options & WDIOS_DISABLECARD) {
+			eurwdt_disable_timer();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			eurwdt_activate_timer();
+			eurwdt_ping();
+			retval = 0;
+		}
+		spin_unlock(&eurwdt_lock);
+		return retval;
+
 	case WDIOC_KEEPALIVE:
+		spin_lock(&eurwdt_lock);
 		eurwdt_ping();
+		spin_unlock(&eurwdt_lock);
 		return 0;
 
 	case WDIOC_SETTIMEOUT:
@@ -266,26 +286,17 @@ static int eurwdt_ioctl(struct inode *inode, struct file *file,
 		if (time < 0 || time > 255)
 			return -EINVAL;
 
+		spin_lock(&eurwdt_lock);
 		eurwdt_timeout = time;
 		eurwdt_set_timeout(time);
+		spin_unlock(&eurwdt_lock);
 		/* Fall */
 
 	case WDIOC_GETTIMEOUT:
 		return put_user(eurwdt_timeout, p);
 
-	case WDIOC_SETOPTIONS:
-		if (get_user(options, p))
-			return -EFAULT;
-		if (options & WDIOS_DISABLECARD) {
-			eurwdt_disable_timer();
-			retval = 0;
-		}
-		if (options & WDIOS_ENABLECARD) {
-			eurwdt_activate_timer();
-			eurwdt_ping();
-			retval = 0;
-		}
-		return retval;
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -322,10 +333,11 @@ static int eurwdt_open(struct inode *inode, struct file *file)
 
 static int eurwdt_release(struct inode *inode, struct file *file)
 {
-	if (eur_expect_close == 42) {
+	if (eur_expect_close == 42)
 		eurwdt_disable_timer();
-	} else {
-		printk(KERN_CRIT "eurwdt: Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT
+			"eurwdt: Unexpected close, not stopping watchdog!\n");
 		eurwdt_ping();
 	}
 	clear_bit(0, &eurwdt_is_open);
@@ -348,10 +360,8 @@ static int eurwdt_release(struct inode *inode, struct file *file)
 static int eurwdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		/* Turn the card off */
-		eurwdt_disable_timer();
-	}
+	if (code == SYS_DOWN || code == SYS_HALT)
+		eurwdt_disable_timer();	/* Turn the card off */
 
 	return NOTIFY_DONE;
 }
@@ -362,11 +372,11 @@ static int eurwdt_notify_sys(struct notifier_block *this, unsigned long code,
 
 
 static const struct file_operations eurwdt_fops = {
-	.owner	= THIS_MODULE,
-	.llseek	= no_llseek,
-	.write	= eurwdt_write,
-	.ioctl	= eurwdt_ioctl,
-	.open	= eurwdt_open,
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= eurwdt_write,
+	.unlocked_ioctl	= eurwdt_ioctl,
+	.open		= eurwdt_open,
 	.release	= eurwdt_release,
 };
 
@@ -419,7 +429,7 @@ static int __init eurwdt_init(void)
 	int ret;
 
 	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
-	if(ret) {
+	if (ret) {
 		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
 		goto out;
 	}
@@ -432,10 +442,13 @@ static int __init eurwdt_init(void)
 
 	ret = register_reboot_notifier(&eurwdt_notifier);
 	if (ret) {
-		printk(KERN_ERR "eurwdt: can't register reboot notifier (err=%d)\n", ret);
+		printk(KERN_ERR
+		    "eurwdt: can't register reboot notifier (err=%d)\n", ret);
 		goto outreg;
 	}
 
+	spin_lock_init(&eurwdt_lock);
+
 	ret = misc_register(&eurwdt_miscdev);
 	if (ret) {
 		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 30d09cb..614a5c7 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -17,8 +17,8 @@
 #include <linux/fs.h>
 #include <linux/platform_device.h>
 #include <linux/reboot.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/geode.h>
 
 #define GEODEWDT_HZ 500
@@ -77,27 +77,24 @@ static int geodewdt_set_heartbeat(int val)
 	return 0;
 }
 
-static int
-geodewdt_open(struct inode *inode, struct file *file)
+static int geodewdt_open(struct inode *inode, struct file *file)
 {
-        if (test_and_set_bit(WDT_FLAGS_OPEN, &wdt_flags))
-                return -EBUSY;
+	if (test_and_set_bit(WDT_FLAGS_OPEN, &wdt_flags))
+		return -EBUSY;
 
-        if (!test_and_clear_bit(WDT_FLAGS_ORPHAN, &wdt_flags))
-                __module_get(THIS_MODULE);
+	if (!test_and_clear_bit(WDT_FLAGS_ORPHAN, &wdt_flags))
+		__module_get(THIS_MODULE);
 
 	geodewdt_ping();
-        return nonseekable_open(inode, file);
+	return nonseekable_open(inode, file);
 }
 
-static int
-geodewdt_release(struct inode *inode, struct file *file)
+static int geodewdt_release(struct inode *inode, struct file *file)
 {
 	if (safe_close) {
 		geodewdt_disable();
 		module_put(THIS_MODULE);
-	}
-	else {
+	} else {
 		printk(KERN_CRIT "Unexpected close - watchdog is not stopping.\n");
 		geodewdt_ping();
 
@@ -109,11 +106,10 @@ geodewdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t
-geodewdt_write(struct file *file, const char __user *data, size_t len,
-	       loff_t *ppos)
+static ssize_t geodewdt_write(struct file *file, const char __user *data,
+				size_t len, loff_t *ppos)
 {
-        if(len) {
+	if (len) {
 		if (!nowayout) {
 			size_t i;
 			safe_close = 0;
@@ -134,9 +130,8 @@ geodewdt_write(struct file *file, const char __user *data, size_t len,
 	return len;
 }
 
-static int
-geodewdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	       unsigned long arg)
+static int geodewdt_ioctl(struct inode *inode, struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -147,9 +142,9 @@ geodewdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		| WDIOF_MAGICCLOSE,
 		.firmware_version =     1,
 		.identity =             WATCHDOG_NAME,
-        };
+	};
 
-	switch(cmd) {
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &ident,
 				    sizeof(ident)) ? -EFAULT : 0;
@@ -159,22 +154,6 @@ geodewdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 
-	case WDIOC_KEEPALIVE:
-		geodewdt_ping();
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(interval, p))
-			return -EFAULT;
-
-		if (geodewdt_set_heartbeat(interval))
-			return -EINVAL;
-
-/* Fall through */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout, p);
-
 	case WDIOC_SETOPTIONS:
 	{
 		int options, ret = -EINVAL;
@@ -194,6 +173,20 @@ geodewdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 		return ret;
 	}
+	case WDIOC_KEEPALIVE:
+		geodewdt_ping();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(interval, p))
+			return -EFAULT;
+
+		if (geodewdt_set_heartbeat(interval))
+			return -EINVAL;
+	/* Fall through */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+
 	default:
 		return -ENOTTY;
 	}
@@ -202,22 +195,21 @@ geodewdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 }
 
 static const struct file_operations geodewdt_fops = {
-        .owner          = THIS_MODULE,
-        .llseek         = no_llseek,
-        .write          = geodewdt_write,
-        .ioctl          = geodewdt_ioctl,
-        .open           = geodewdt_open,
-        .release        = geodewdt_release,
+	.owner          = THIS_MODULE,
+	.llseek         = no_llseek,
+	.write          = geodewdt_write,
+	.ioctl          = geodewdt_ioctl,
+	.open           = geodewdt_open,
+	.release        = geodewdt_release,
 };
 
 static struct miscdevice geodewdt_miscdev = {
 	.minor = WATCHDOG_MINOR,
 	.name = "watchdog",
-	.fops = &geodewdt_fops
+	.fops = &geodewdt_fops,
 };
 
-static int __devinit
-geodewdt_probe(struct platform_device *dev)
+static int __devinit geodewdt_probe(struct platform_device *dev)
 {
 	int ret, timer;
 
@@ -248,15 +240,13 @@ geodewdt_probe(struct platform_device *dev)
 	return ret;
 }
 
-static int __devexit
-geodewdt_remove(struct platform_device *dev)
+static int __devexit geodewdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&geodewdt_miscdev);
 	return 0;
 }
 
-static void
-geodewdt_shutdown(struct platform_device *dev)
+static void geodewdt_shutdown(struct platform_device *dev)
 {
 	geodewdt_disable();
 }
@@ -271,8 +261,7 @@ static struct platform_driver geodewdt_driver = {
 	},
 };
 
-static int __init
-geodewdt_init(void)
+static int __init geodewdt_init(void)
 {
 	int ret;
 
@@ -292,8 +281,7 @@ err:
 	return ret;
 }
 
-static void __exit
-geodewdt_exit(void)
+static void __exit geodewdt_exit(void)
 {
 	platform_device_unregister(geodewdt_platform_device);
 	platform_driver_unregister(&geodewdt_driver);
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index ccd6c53..d039d5f 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -39,9 +39,7 @@
 #include <linux/string.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
-#include <asm/dmi.h>
 #include <asm/desc.h>
-#include <asm/kdebug.h>
 
 #define PCI_BIOS32_SD_VALUE		0x5F32335F	/* "_32_" */
 #define CRU_BIOS_SIGNATURE_VALUE	0x55524324
@@ -407,7 +405,7 @@ static int __devinit detect_cru_service(void)
 	dmi_walk(dmi_find_cru);
 
 	/* if cru_rom_addr has been set then we found a CRU service */
-	return ((cru_rom_addr != NULL)? 0: -ENODEV);
+	return ((cru_rom_addr != NULL) ? 0: -ENODEV);
 }
 
 /* ------------------------------------------------------------------------- */
@@ -535,7 +533,7 @@ static ssize_t hpwdt_write(struct file *file, const char __user *data,
 			/* scan to see whether or not we got the magic char. */
 			for (i = 0; i != len; i++) {
 				char c;
-				if (get_user(c, data+i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_release = 42;
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index ca44fd9..c13383f 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -9,18 +9,18 @@
  *	as published by the Free Software Foundation; either version
  *	2 of the License, or (at your option) any later version.
  *
- *      based on i810-tco.c which is in turn based on softdog.c
+ *	based on i810-tco.c which is in turn based on softdog.c
  *
- * 	The timer is implemented in the following I/O controller hubs:
- * 	(See the intel documentation on http://developer.intel.com.)
- * 	6300ESB chip : document number 300641-003
+ *	The timer is implemented in the following I/O controller hubs:
+ *	(See the intel documentation on http://developer.intel.com.)
+ *	6300ESB chip : document number 300641-003
  *
  *  2004YYZZ Ross Biro
  *	Initial version 0.01
  *  2004YYZZ Ross Biro
- *  	Version 0.02
+ *	Version 0.02
  *  20050210 David Härdeman <david@2gen.com>
- *      Ported driver to kernel 2.6
+ *	Ported driver to kernel 2.6
  */
 
 /*
@@ -38,9 +38,8 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 /* Module and version information */
 #define ESB_VERSION "0.03"
@@ -59,17 +58,17 @@
 #define ESB_RELOAD_REG  BASEADDR + 0x0c /* Reload register                   */
 
 /* Lock register bits */
-#define ESB_WDT_FUNC    ( 0x01 << 2 )   /* Watchdog functionality            */
-#define ESB_WDT_ENABLE  ( 0x01 << 1 )   /* Enable WDT                        */
-#define ESB_WDT_LOCK    ( 0x01 << 0 )   /* Lock (nowayout)                   */
+#define ESB_WDT_FUNC    (0x01 << 2)   /* Watchdog functionality            */
+#define ESB_WDT_ENABLE  (0x01 << 1)   /* Enable WDT                        */
+#define ESB_WDT_LOCK    (0x01 << 0)   /* Lock (nowayout)                   */
 
 /* Config register bits */
-#define ESB_WDT_REBOOT  ( 0x01 << 5 )   /* Enable reboot on timeout          */
-#define ESB_WDT_FREQ    ( 0x01 << 2 )   /* Decrement frequency               */
-#define ESB_WDT_INTTYPE ( 0x11 << 0 )   /* Interrupt type on timer1 timeout  */
+#define ESB_WDT_REBOOT  (0x01 << 5)   /* Enable reboot on timeout          */
+#define ESB_WDT_FREQ    (0x01 << 2)   /* Decrement frequency               */
+#define ESB_WDT_INTTYPE (0x11 << 0)   /* Interrupt type on timer1 timeout  */
 
 /* Reload register bits */
-#define ESB_WDT_RELOAD ( 0x01 << 8 )    /* prevent timeout                   */
+#define ESB_WDT_RELOAD  (0x01 << 8)    /* prevent timeout                   */
 
 /* Magic constants */
 #define ESB_UNLOCK1     0x80            /* Step 1 to unlock reset registers  */
@@ -84,14 +83,20 @@ static unsigned short triggered; /* The status of the watchdog upon boot */
 static char esb_expect_close;
 
 /* module parameters */
-#define WATCHDOG_HEARTBEAT 30   /* 30 sec default heartbeat (1<heartbeat<2*1023) */
+/* 30 sec default heartbeat (1 < heartbeat < 2*1023) */
+#define WATCHDOG_HEARTBEAT 30
 static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
+
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (1<heartbeat<2046, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat,
+		"Watchdog heartbeat in seconds. (1<heartbeat<2046, default="
+				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Some i6300ESB specific functions
@@ -103,9 +108,10 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" _
  * reload register. After this the appropriate registers can be written
  * to once before they need to be unlocked again.
  */
-static inline void esb_unlock_registers(void) {
-        writeb(ESB_UNLOCK1, ESB_RELOAD_REG);
-        writeb(ESB_UNLOCK2, ESB_RELOAD_REG);
+static inline void esb_unlock_registers(void)
+{
+	writeb(ESB_UNLOCK1, ESB_RELOAD_REG);
+	writeb(ESB_UNLOCK2, ESB_RELOAD_REG);
 }
 
 static void esb_timer_start(void)
@@ -114,8 +120,7 @@ static void esb_timer_start(void)
 
 	/* Enable or Enable + Lock? */
 	val = 0x02 | (nowayout ? 0x01 : 0x00);
-
-        pci_write_config_byte(esb_pci, ESB_LOCK_REG, val);
+	pci_write_config_byte(esb_pci, ESB_LOCK_REG, val);
 }
 
 static int esb_timer_stop(void)
@@ -140,7 +145,7 @@ static void esb_timer_keepalive(void)
 	spin_lock(&esb_lock);
 	esb_unlock_registers();
 	writew(ESB_WDT_RELOAD, ESB_RELOAD_REG);
-        /* FIXME: Do we need to flush anything here? */
+	/* FIXME: Do we need to flush anything here? */
 	spin_unlock(&esb_lock);
 }
 
@@ -165,9 +170,9 @@ static int esb_timer_set_heartbeat(int time)
 
 	/* Write timer 2 */
 	esb_unlock_registers();
-        writel(val, ESB_TIMER2_REG);
+	writel(val, ESB_TIMER2_REG);
 
-        /* Reload */
+	/* Reload */
 	esb_unlock_registers();
 	writew(ESB_WDT_RELOAD, ESB_RELOAD_REG);
 
@@ -179,54 +184,55 @@ static int esb_timer_set_heartbeat(int time)
 	return 0;
 }
 
-static int esb_timer_read (void)
+static int esb_timer_read(void)
 {
-       	u32 count;
+	u32 count;
 
 	/* This isn't documented, and doesn't take into
-         * acount which stage is running, but it looks
-         * like a 20 bit count down, so we might as well report it.
-         */
-        pci_read_config_dword(esb_pci, 0x64, &count);
-        return (int)count;
+	 * acount which stage is running, but it looks
+	 * like a 20 bit count down, so we might as well report it.
+	 */
+	pci_read_config_dword(esb_pci, 0x64, &count);
+	return (int)count;
 }
 
 /*
- * 	/dev/watchdog handling
+ *	/dev/watchdog handling
  */
 
-static int esb_open (struct inode *inode, struct file *file)
+static int esb_open(struct inode *inode, struct file *file)
 {
-        /* /dev/watchdog can only be opened once */
-        if (test_and_set_bit(0, &timer_alive))
-                return -EBUSY;
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &timer_alive))
+		return -EBUSY;
 
-        /* Reload and activate timer */
-        esb_timer_keepalive ();
-        esb_timer_start ();
+	/* Reload and activate timer */
+	esb_timer_keepalive();
+	esb_timer_start();
 
 	return nonseekable_open(inode, file);
 }
 
-static int esb_release (struct inode *inode, struct file *file)
+static int esb_release(struct inode *inode, struct file *file)
 {
-        /* Shut off the timer. */
-        if (esb_expect_close == 42) {
-                esb_timer_stop ();
-        } else {
-                printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
-                esb_timer_keepalive ();
-        }
-        clear_bit(0, &timer_alive);
-        esb_expect_close = 0;
-        return 0;
+	/* Shut off the timer. */
+	if (esb_expect_close == 42)
+		esb_timer_stop();
+	else {
+		printk(KERN_CRIT PFX
+				"Unexpected close, not stopping watchdog!\n");
+		esb_timer_keepalive();
+	}
+	clear_bit(0, &timer_alive);
+	esb_expect_close = 0;
+	return 0;
 }
 
-static ssize_t esb_write (struct file *file, const char __user *data,
-			  size_t len, loff_t * ppos)
+static ssize_t esb_write(struct file *file, const char __user *data,
+			  size_t len, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-        if (len) {
+	if (len) {
 		if (!nowayout) {
 			size_t i;
 
@@ -237,7 +243,7 @@ static ssize_t esb_write (struct file *file, const char __user *data,
 			/* scan to see whether or not we got the magic character */
 			for (i = 0; i != len; i++) {
 				char c;
-				if(get_user(c, data+i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					esb_expect_close = 42;
@@ -245,92 +251,84 @@ static ssize_t esb_write (struct file *file, const char __user *data,
 		}
 
 		/* someone wrote to us, we should reload the timer */
-		esb_timer_keepalive ();
+		esb_timer_keepalive();
 	}
 	return len;
 }
 
-static int esb_ioctl (struct inode *inode, struct file *file,
-		      unsigned int cmd, unsigned long arg)
+static long esb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_options, retval = -EINVAL;
 	int new_heartbeat;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	static struct watchdog_info ident = {
-		.options =              WDIOF_SETTIMEOUT |
+		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
-		.firmware_version =     0,
-		.identity =             ESB_MODULE_NAME,
+		.firmware_version =	0,
+		.identity =		ESB_MODULE_NAME,
 	};
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-					    sizeof (ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-			return put_user (esb_timer_read(), p);
-
-		case WDIOC_GETBOOTSTATUS:
-			return put_user (triggered, p);
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident,
+					sizeof(ident)) ? -EFAULT : 0;
 
-                case WDIOC_KEEPALIVE:
-                        esb_timer_keepalive ();
-                        return 0;
+	case WDIOC_GETSTATUS:
+		return put_user(esb_timer_read(), p);
 
-                case WDIOC_SETOPTIONS:
-                {
-                        if (get_user (new_options, p))
-                                return -EFAULT;
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(triggered, p);
 
-                        if (new_options & WDIOS_DISABLECARD) {
-                                esb_timer_stop ();
-                                retval = 0;
-                        }
+	case WDIOC_SETOPTIONS:
+	{
+		if (get_user(new_options, p))
+			return -EFAULT;
 
-                        if (new_options & WDIOS_ENABLECARD) {
-                                esb_timer_keepalive ();
-                                esb_timer_start ();
-                                retval = 0;
-                        }
-
-                        return retval;
-                }
-
-                case WDIOC_SETTIMEOUT:
-                {
-                        if (get_user(new_heartbeat, p))
-                                return -EFAULT;
-
-                        if (esb_timer_set_heartbeat(new_heartbeat))
-                            return -EINVAL;
-
-                        esb_timer_keepalive ();
-                        /* Fall */
-                }
-
-                case WDIOC_GETTIMEOUT:
-                        return put_user(heartbeat, p);
+		if (new_options & WDIOS_DISABLECARD) {
+			esb_timer_stop();
+			retval = 0;
+		}
 
-                default:
-                        return -ENOTTY;
-        }
+		if (new_options & WDIOS_ENABLECARD) {
+			esb_timer_keepalive();
+			esb_timer_start();
+			retval = 0;
+		}
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		esb_timer_keepalive();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+	{
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
+		if (esb_timer_set_heartbeat(new_heartbeat))
+			return -EINVAL;
+		esb_timer_keepalive();
+		/* Fall */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	default:
+		return -ENOTTY;
+	}
 }
 
 /*
  *      Notify system
  */
 
-static int esb_notify_sys (struct notifier_block *this, unsigned long code, void *unused)
+static int esb_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
-        if (code==SYS_DOWN || code==SYS_HALT) {
-                /* Turn the WDT off */
-                esb_timer_stop ();
-        }
+	if (code == SYS_DOWN || code == SYS_HALT)
+		esb_timer_stop();	/* Turn the WDT off */
 
-        return NOTIFY_DONE;
+	return NOTIFY_DONE;
 }
 
 /*
@@ -338,22 +336,22 @@ static int esb_notify_sys (struct notifier_block *this, unsigned long code, void
  */
 
 static const struct file_operations esb_fops = {
-        .owner =        THIS_MODULE,
-        .llseek =       no_llseek,
-        .write =        esb_write,
-        .ioctl =        esb_ioctl,
-        .open =         esb_open,
-        .release =      esb_release,
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = esb_write,
+	.unlocked_ioctl = esb_ioctl,
+	.open = esb_open,
+	.release = esb_release,
 };
 
 static struct miscdevice esb_miscdev = {
-        .minor =        WATCHDOG_MINOR,
-        .name =         "watchdog",
-        .fops =         &esb_fops,
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &esb_fops,
 };
 
 static struct notifier_block esb_notifier = {
-        .notifier_call =        esb_notify_sys,
+	.notifier_call = esb_notify_sys,
 };
 
 /*
@@ -365,50 +363,44 @@ static struct notifier_block esb_notifier = {
  * want to register another driver on the same PCI id.
  */
 static struct pci_device_id esb_pci_tbl[] = {
-        { PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_9), },
-        { 0, },                 /* End of list */
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_9), },
+	{ 0, },                 /* End of list */
 };
-MODULE_DEVICE_TABLE (pci, esb_pci_tbl);
+MODULE_DEVICE_TABLE(pci, esb_pci_tbl);
 
 /*
  *      Init & exit routines
  */
 
-static unsigned char __init esb_getdevice (void)
+static unsigned char __init esb_getdevice(void)
 {
 	u8 val1;
 	unsigned short val2;
+	/*
+	 *      Find the PCI device
+	 */
 
-        struct pci_dev *dev = NULL;
-        /*
-         *      Find the PCI device
-         */
-
-        for_each_pci_dev(dev) {
-                if (pci_match_id(esb_pci_tbl, dev)) {
-                        esb_pci = dev;
-                        break;
-                }
-	}
+	esb_pci = pci_get_device(PCI_VENDOR_ID_INTEL,
+					PCI_DEVICE_ID_INTEL_ESB_9, NULL);
 
-        if (esb_pci) {
-        	if (pci_enable_device(esb_pci)) {
-			printk (KERN_ERR PFX "failed to enable device\n");
+	if (esb_pci) {
+		if (pci_enable_device(esb_pci)) {
+			printk(KERN_ERR PFX "failed to enable device\n");
 			goto err_devput;
 		}
 
 		if (pci_request_region(esb_pci, 0, ESB_MODULE_NAME)) {
-			printk (KERN_ERR PFX "failed to request region\n");
+			printk(KERN_ERR PFX "failed to request region\n");
 			goto err_disable;
 		}
 
 		BASEADDR = ioremap(pci_resource_start(esb_pci, 0),
 				   pci_resource_len(esb_pci, 0));
 		if (BASEADDR == NULL) {
-                	/* Something's wrong here, BASEADDR has to be set */
-			printk (KERN_ERR PFX "failed to get BASEADDR\n");
-                        goto err_release;
-                }
+			/* Something's wrong here, BASEADDR has to be set */
+			printk(KERN_ERR PFX "failed to get BASEADDR\n");
+			goto err_release;
+		}
 
 		/*
 		 * The watchdog has two timers, it can be setup so that the
@@ -425,7 +417,7 @@ static unsigned char __init esb_getdevice (void)
 		/* Check that the WDT isn't already locked */
 		pci_read_config_byte(esb_pci, ESB_LOCK_REG, &val1);
 		if (val1 & ESB_WDT_LOCK)
-			printk (KERN_WARNING PFX "nowayout already set\n");
+			printk(KERN_WARNING PFX "nowayout already set\n");
 
 		/* Set the timer to watchdog mode and disable it for now */
 		pci_write_config_byte(esb_pci, ESB_LOCK_REG, 0x00);
@@ -452,44 +444,44 @@ err_devput:
 	return 0;
 }
 
-static int __init watchdog_init (void)
+static int __init watchdog_init(void)
 {
-        int ret;
-
-        /* Check whether or not the hardware watchdog is there */
-        if (!esb_getdevice () || esb_pci == NULL)
-                return -ENODEV;
-
-        /* Check that the heartbeat value is within it's range ; if not reset to the default */
-        if (esb_timer_set_heartbeat (heartbeat)) {
-                esb_timer_set_heartbeat (WATCHDOG_HEARTBEAT);
-                printk(KERN_INFO PFX "heartbeat value must be 1<heartbeat<2046, using %d\n",
-		       heartbeat);
-        }
-
-        ret = register_reboot_notifier(&esb_notifier);
-        if (ret != 0) {
-                printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-                        ret);
-                goto err_unmap;
-        }
-
-        ret = misc_register(&esb_miscdev);
-        if (ret != 0) {
-                printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-                        WATCHDOG_MINOR, ret);
-                goto err_notifier;
-        }
-
-        esb_timer_stop ();
-
-        printk (KERN_INFO PFX "initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
-                BASEADDR, heartbeat, nowayout);
+	int ret;
+
+	/* Check whether or not the hardware watchdog is there */
+	if (!esb_getdevice() || esb_pci == NULL)
+		return -ENODEV;
+
+	/* Check that the heartbeat value is within it's range;
+	   if not reset to the default */
+	if (esb_timer_set_heartbeat(heartbeat)) {
+		esb_timer_set_heartbeat(WATCHDOG_HEARTBEAT);
+		printk(KERN_INFO PFX
+			"heartbeat value must be 1<heartbeat<2046, using %d\n",
+								heartbeat);
+	}
+	ret = register_reboot_notifier(&esb_notifier);
+	if (ret != 0) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
+		goto err_unmap;
+	}
 
-        return 0;
+	ret = misc_register(&esb_miscdev);
+	if (ret != 0) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
+		goto err_notifier;
+	}
+	esb_timer_stop();
+	printk(KERN_INFO PFX
+		"initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
+						BASEADDR, heartbeat, nowayout);
+	return 0;
 
 err_notifier:
-        unregister_reboot_notifier(&esb_notifier);
+	unregister_reboot_notifier(&esb_notifier);
 err_unmap:
 	iounmap(BASEADDR);
 /* err_release: */
@@ -498,18 +490,18 @@ err_unmap:
 	pci_disable_device(esb_pci);
 /* err_devput: */
 	pci_dev_put(esb_pci);
-        return ret;
+	return ret;
 }
 
-static void __exit watchdog_cleanup (void)
+static void __exit watchdog_cleanup(void)
 {
 	/* Stop the timer before we leave */
 	if (!nowayout)
-		esb_timer_stop ();
+		esb_timer_stop();
 
 	/* Deregister */
 	misc_deregister(&esb_miscdev);
-        unregister_reboot_notifier(&esb_notifier);
+	unregister_reboot_notifier(&esb_notifier);
 	iounmap(BASEADDR);
 	pci_release_region(esb_pci, 0);
 	pci_disable_device(esb_pci);
diff --git a/drivers/watchdog/iTCO_vendor.h b/drivers/watchdog/iTCO_vendor.h
new file mode 100644
index 0000000..9e27e64
--- /dev/null
+++ b/drivers/watchdog/iTCO_vendor.h
@@ -0,0 +1,15 @@
+/* iTCO Vendor Specific Support hooks */
+#ifdef CONFIG_ITCO_VENDOR_SUPPORT
+extern void iTCO_vendor_pre_start(unsigned long, unsigned int);
+extern void iTCO_vendor_pre_stop(unsigned long);
+extern void iTCO_vendor_pre_keepalive(unsigned long, unsigned int);
+extern void iTCO_vendor_pre_set_heartbeat(unsigned int);
+extern int iTCO_vendor_check_noreboot_on(void);
+#else
+#define iTCO_vendor_pre_start(acpibase, heartbeat)	{}
+#define iTCO_vendor_pre_stop(acpibase)			{}
+#define iTCO_vendor_pre_keepalive(acpibase, heartbeat)	{}
+#define iTCO_vendor_pre_set_heartbeat(heartbeat)	{}
+#define iTCO_vendor_check_noreboot_on()			1
+				/* 1=check noreboot; 0=don't check */
+#endif
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index cafc465..ca344a8 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -18,9 +18,9 @@
  */
 
 /* Module and version information */
-#define DRV_NAME        "iTCO_vendor_support"
-#define DRV_VERSION     "1.01"
-#define DRV_RELDATE     "11-Nov-2006"
+#define DRV_NAME	"iTCO_vendor_support"
+#define DRV_VERSION	"1.01"
+#define DRV_RELDATE	"11-Nov-2006"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -31,19 +31,22 @@
 #include <linux/kernel.h>		/* For printk/panic/... */
 #include <linux/init.h>			/* For __init/__exit/... */
 #include <linux/ioport.h>		/* For io-port access */
+#include <linux/io.h>			/* For inb/outb/... */
 
-#include <asm/io.h>			/* For inb/outb/... */
+#include "iTCO_vendor.h"
 
 /* iTCO defines */
 #define	SMI_EN		acpibase + 0x30	/* SMI Control and Enable Register */
-#define	TCOBASE		acpibase + 0x60	/* TCO base address		*/
-#define	TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register		*/
+#define	TCOBASE		acpibase + 0x60	/* TCO base address */
+#define	TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register */
 
 /* List of vendor support modes */
-#define SUPERMICRO_OLD_BOARD	1	/* SuperMicro Pentium 3 Era 370SSE+-OEM1/P3TSSE */
-#define SUPERMICRO_NEW_BOARD	2	/* SuperMicro Pentium 4 / Xeon 4 / EMT64T Era Systems */
+/* SuperMicro Pentium 3 Era 370SSE+-OEM1/P3TSSE */
+#define SUPERMICRO_OLD_BOARD	1
+/* SuperMicro Pentium 4 / Xeon 4 / EMT64T Era Systems */
+#define SUPERMICRO_NEW_BOARD	2
 
-static int vendorsupport = 0;
+static int vendorsupport;
 module_param(vendorsupport, int, 0);
 MODULE_PARM_DESC(vendorsupport, "iTCO vendor specific support mode, default=0 (none), 1=SuperMicro Pent3, 2=SuperMicro Pent4+");
 
@@ -143,34 +146,35 @@ static void supermicro_old_pre_keepalive(unsigned long acpibase)
  */
 
 /* I/O Port's */
-#define SM_REGINDEX	0x2e		/* SuperMicro ICH4+ Register Index */
-#define SM_DATAIO	0x2f		/* SuperMicro ICH4+ Register Data I/O */
+#define SM_REGINDEX	0x2e	/* SuperMicro ICH4+ Register Index */
+#define SM_DATAIO	0x2f	/* SuperMicro ICH4+ Register Data I/O */
 
 /* Control Register's */
-#define SM_CTLPAGESW	0x07		/* SuperMicro ICH4+ Control Page Switch */
-#define SM_CTLPAGE		0x08	/* SuperMicro ICH4+ Control Page Num */
+#define SM_CTLPAGESW	0x07	/* SuperMicro ICH4+ Control Page Switch */
+#define SM_CTLPAGE	0x08	/* SuperMicro ICH4+ Control Page Num */
 
-#define SM_WATCHENABLE	0x30		/* Watchdog enable: Bit 0: 0=off, 1=on */
+#define SM_WATCHENABLE	0x30	/* Watchdog enable: Bit 0: 0=off, 1=on */
 
-#define SM_WATCHPAGE	0x87		/* Watchdog unlock control page */
+#define SM_WATCHPAGE	0x87	/* Watchdog unlock control page */
 
-#define SM_ENDWATCH	0xAA		/* Watchdog lock control page */
+#define SM_ENDWATCH	0xAA	/* Watchdog lock control page */
 
-#define SM_COUNTMODE	0xf5		/* Watchdog count mode select */
-					/* (Bit 3: 0 = seconds, 1 = minutes */
+#define SM_COUNTMODE	0xf5	/* Watchdog count mode select */
+				/* (Bit 3: 0 = seconds, 1 = minutes */
 
-#define SM_WATCHTIMER	0xf6		/* 8-bits, Watchdog timer counter (RW) */
+#define SM_WATCHTIMER	0xf6	/* 8-bits, Watchdog timer counter (RW) */
 
-#define SM_RESETCONTROL	0xf7		/* Watchdog reset control */
-					/* Bit 6: timer is reset by kbd interrupt */
-					/* Bit 7: timer is reset by mouse interrupt */
+#define SM_RESETCONTROL	0xf7	/* Watchdog reset control */
+				/* Bit 6: timer is reset by kbd interrupt */
+				/* Bit 7: timer is reset by mouse interrupt */
 
 static void supermicro_new_unlock_watchdog(void)
 {
-	outb(SM_WATCHPAGE, SM_REGINDEX);	/* Write 0x87 to port 0x2e twice */
+	/* Write 0x87 to port 0x2e twice */
 	outb(SM_WATCHPAGE, SM_REGINDEX);
-
-	outb(SM_CTLPAGESW, SM_REGINDEX);	/* Switch to watchdog control page */
+	outb(SM_WATCHPAGE, SM_REGINDEX);
+	/* Switch to watchdog control page */
+	outb(SM_CTLPAGESW, SM_REGINDEX);
 	outb(SM_CTLPAGE, SM_DATAIO);
 }
 
@@ -192,7 +196,7 @@ static void supermicro_new_pre_start(unsigned int heartbeat)
 	outb(val, SM_DATAIO);
 
 	/* Write heartbeat interval to WDOG */
-	outb (SM_WATCHTIMER, SM_REGINDEX);
+	outb(SM_WATCHTIMER, SM_REGINDEX);
 	outb((heartbeat & 255), SM_DATAIO);
 
 	/* Make sure keyboard/mouse interrupts don't interfere */
@@ -277,7 +281,7 @@ EXPORT_SYMBOL(iTCO_vendor_pre_set_heartbeat);
 
 int iTCO_vendor_check_noreboot_on(void)
 {
-	switch(vendorsupport) {
+	switch (vendorsupport) {
 	case SUPERMICRO_OLD_BOARD:
 		return 0;
 	default:
@@ -288,13 +292,13 @@ EXPORT_SYMBOL(iTCO_vendor_check_noreboot_on);
 
 static int __init iTCO_vendor_init_module(void)
 {
-	printk (KERN_INFO PFX "vendor-support=%d\n", vendorsupport);
+	printk(KERN_INFO PFX "vendor-support=%d\n", vendorsupport);
 	return 0;
 }
 
 static void __exit iTCO_vendor_exit_module(void)
 {
-	printk (KERN_INFO PFX "Module Unloaded\n");
+	printk(KERN_INFO PFX "Module Unloaded\n");
 }
 
 module_init(iTCO_vendor_init_module);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 95ba985..bfb93bc 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -55,9 +55,9 @@
  */
 
 /* Module and version information */
-#define DRV_NAME        "iTCO_wdt"
-#define DRV_VERSION     "1.03"
-#define DRV_RELDATE     "30-Apr-2008"
+#define DRV_NAME	"iTCO_wdt"
+#define DRV_VERSION	"1.03"
+#define DRV_RELDATE	"30-Apr-2008"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -66,7 +66,8 @@
 #include <linux/types.h>		/* For standard types (like size_t) */
 #include <linux/errno.h>		/* For the -ENODEV/... values */
 #include <linux/kernel.h>		/* For printk/panic/... */
-#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
+							(WATCHDOG_MINOR) */
 #include <linux/watchdog.h>		/* For the watchdog specific items */
 #include <linux/init.h>			/* For __init/__exit/... */
 #include <linux/fs.h>			/* For file operations */
@@ -74,9 +75,10 @@
 #include <linux/pci.h>			/* For pci functions */
 #include <linux/ioport.h>		/* For io-port access */
 #include <linux/spinlock.h>		/* For spin_lock/spin_unlock/... */
+#include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
+#include <linux/io.h>			/* For inb/outb/... */
 
-#include <asm/uaccess.h>		/* For copy_to_user/put_user/... */
-#include <asm/io.h>			/* For inb/outb/... */
+#include "iTCO_vendor.h"
 
 /* TCO related info */
 enum iTCO_chipsets {
@@ -105,7 +107,7 @@ enum iTCO_chipsets {
 	TCO_ICH9,	/* ICH9 */
 	TCO_ICH9R,	/* ICH9R */
 	TCO_ICH9DH,	/* ICH9DH */
-	TCO_ICH9DO,     /* ICH9DO */
+	TCO_ICH9DO,	/* ICH9DO */
 	TCO_631XESB,	/* 631xESB/632xESB */
 };
 
@@ -140,7 +142,7 @@ static struct {
 	{"ICH9DH", 2},
 	{"ICH9DO", 2},
 	{"631xESB/632xESB", 2},
-	{NULL,0}
+	{NULL, 0}
 };
 
 #define ITCO_PCI_DEVICE(dev, data) 	\
@@ -159,32 +161,32 @@ static struct {
  * functions that probably will be registered by other drivers.
  */
 static struct pci_device_id iTCO_wdt_pci_tbl[] = {
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AA_0,	TCO_ICH    )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AB_0,	TCO_ICH0   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_0,	TCO_ICH2   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_10,	TCO_ICH2M  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_0,	TCO_ICH3   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_12,	TCO_ICH3M  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_0,	TCO_ICH4   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_12,	TCO_ICH4M  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801E_0,		TCO_CICH   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801EB_0,	TCO_ICH5   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AA_0,	TCO_ICH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AB_0,	TCO_ICH0)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_0,	TCO_ICH2)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_10,	TCO_ICH2M)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_0,	TCO_ICH3)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_12,	TCO_ICH3M)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_0,	TCO_ICH4)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_12,	TCO_ICH4M)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801E_0,		TCO_CICH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801EB_0,	TCO_ICH5)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB_1,		TCO_6300ESB)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_0,		TCO_ICH6   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_1,		TCO_ICH6M  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_2,		TCO_ICH6W  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0,		TCO_ICH7   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M  )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_0,		TCO_ICH6)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_1,		TCO_ICH6M)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_2,		TCO_ICH6W)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0,		TCO_ICH7)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31,		TCO_ICH7MDH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1,		TCO_ICH8ME )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4,		TCO_ICH8M  )},
-	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9   )},
-	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4,           TCO_ICH9DO )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1,		TCO_ICH8ME)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4,		TCO_ICH8M)},
+	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9)},
+	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4,		TCO_ICH9DO)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0,		TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2671,				TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2672,				TCO_631XESB)},
@@ -203,13 +205,15 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x267f,				TCO_631XESB)},
 	{ 0, },			/* End of list */
 };
-MODULE_DEVICE_TABLE (pci, iTCO_wdt_pci_tbl);
+MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
 
 /* Address definitions for the TCO */
-#define	TCOBASE		iTCO_wdt_private.ACPIBASE + 0x60	/* TCO base address                */
-#define	SMI_EN		iTCO_wdt_private.ACPIBASE + 0x30	/* SMI Control and Enable Register */
+/* TCO base address */
+#define	TCOBASE		iTCO_wdt_private.ACPIBASE + 0x60
+/* SMI Control and Enable Register */
+#define	SMI_EN		iTCO_wdt_private.ACPIBASE + 0x30
 
-#define TCO_RLD		TCOBASE + 0x00	/* TCO Timer Reload and Current Value */
+#define TCO_RLD		TCOBASE + 0x00	/* TCO Timer Reload and Curr. Value */
 #define TCOv1_TMR	TCOBASE + 0x01	/* TCOv1 Timer Initial Value	*/
 #define	TCO_DAT_IN	TCOBASE + 0x02	/* TCO Data In Register		*/
 #define	TCO_DAT_OUT	TCOBASE + 0x03	/* TCO Data Out Register	*/
@@ -222,15 +226,21 @@ MODULE_DEVICE_TABLE (pci, iTCO_wdt_pci_tbl);
 /* internal variables */
 static unsigned long is_active;
 static char expect_release;
-static struct {				/* this is private data for the iTCO_wdt device */
-	unsigned int iTCO_version;	/* TCO version/generation */
-	unsigned long ACPIBASE;		/* The cards ACPIBASE address (TCOBASE = ACPIBASE+0x60) */
-	unsigned long __iomem *gcs;	/* NO_REBOOT flag is Memory-Mapped GCS register bit 5 (TCO version 2) */
-	spinlock_t io_lock;		/* the lock for io operations */
-	struct pci_dev *pdev;		/* the PCI-device */
+static struct {		/* this is private data for the iTCO_wdt device */
+	/* TCO version/generation */
+	unsigned int iTCO_version;
+	/* The cards ACPIBASE address (TCOBASE = ACPIBASE+0x60) */
+	unsigned long ACPIBASE;
+	/* NO_REBOOT flag is Memory-Mapped GCS register bit 5 (TCO version 2)*/
+	unsigned long __iomem *gcs;
+	/* the lock for io operations */
+	spinlock_t io_lock;
+	/* the PCI-device */
+	struct pci_dev *pdev;
 } iTCO_wdt_private;
 
-static struct platform_device *iTCO_wdt_platform_device;	/* the watchdog platform device */
+/* the watchdog platform device */
+static struct platform_device *iTCO_wdt_platform_device;
 
 /* module parameters */
 #define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat */
@@ -240,22 +250,9 @@ MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<heartbeat<39 (TCO
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-/* iTCO Vendor Specific Support hooks */
-#ifdef CONFIG_ITCO_VENDOR_SUPPORT
-extern void iTCO_vendor_pre_start(unsigned long, unsigned int);
-extern void iTCO_vendor_pre_stop(unsigned long);
-extern void iTCO_vendor_pre_keepalive(unsigned long, unsigned int);
-extern void iTCO_vendor_pre_set_heartbeat(unsigned int);
-extern int iTCO_vendor_check_noreboot_on(void);
-#else
-#define iTCO_vendor_pre_start(acpibase, heartbeat)	{}
-#define iTCO_vendor_pre_stop(acpibase)			{}
-#define iTCO_vendor_pre_keepalive(acpibase,heartbeat)	{}
-#define iTCO_vendor_pre_set_heartbeat(heartbeat)	{}
-#define iTCO_vendor_check_noreboot_on()			1	/* 1=check noreboot; 0=don't check */
-#endif
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Some TCO specific functions
@@ -369,11 +366,10 @@ static int iTCO_wdt_keepalive(void)
 	iTCO_vendor_pre_keepalive(iTCO_wdt_private.ACPIBASE, heartbeat);
 
 	/* Reload the timer by writing to the TCO Timer Counter register */
-	if (iTCO_wdt_private.iTCO_version == 2) {
+	if (iTCO_wdt_private.iTCO_version == 2)
 		outw(0x01, TCO_RLD);
-	} else if (iTCO_wdt_private.iTCO_version == 1) {
+	else if (iTCO_wdt_private.iTCO_version == 1)
 		outb(0x01, TCO_RLD);
-	}
 
 	spin_unlock(&iTCO_wdt_private.io_lock);
 	return 0;
@@ -425,7 +421,7 @@ static int iTCO_wdt_set_heartbeat(int t)
 	return 0;
 }
 
-static int iTCO_wdt_get_timeleft (int *time_left)
+static int iTCO_wdt_get_timeleft(int *time_left)
 {
 	unsigned int val16;
 	unsigned char val8;
@@ -454,7 +450,7 @@ static int iTCO_wdt_get_timeleft (int *time_left)
  *	/dev/watchdog handling
  */
 
-static int iTCO_wdt_open (struct inode *inode, struct file *file)
+static int iTCO_wdt_open(struct inode *inode, struct file *file)
 {
 	/* /dev/watchdog can only be opened once */
 	if (test_and_set_bit(0, &is_active))
@@ -468,7 +464,7 @@ static int iTCO_wdt_open (struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static int iTCO_wdt_release (struct inode *inode, struct file *file)
+static int iTCO_wdt_release(struct inode *inode, struct file *file)
 {
 	/*
 	 *      Shut off the timer.
@@ -476,7 +472,8 @@ static int iTCO_wdt_release (struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		iTCO_wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		iTCO_wdt_keepalive();
 	}
 	clear_bit(0, &is_active);
@@ -484,22 +481,23 @@ static int iTCO_wdt_release (struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t iTCO_wdt_write (struct file *file, const char __user *data,
-			      size_t len, loff_t * ppos)
+static ssize_t iTCO_wdt_write(struct file *file, const char __user *data,
+			      size_t len, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
 	if (len) {
 		if (!nowayout) {
 			size_t i;
 
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
+			/* note: just in case someone wrote the magic
+			   character five months ago... */
 			expect_release = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			   magic character */
 			for (i = 0; i != len; i++) {
 				char c;
-				if (get_user(c, data+i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_release = 42;
@@ -512,8 +510,8 @@ static ssize_t iTCO_wdt_write (struct file *file, const char __user *data,
 	return len;
 }
 
-static int iTCO_wdt_ioctl (struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long iTCO_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int new_options, retval = -EINVAL;
 	int new_heartbeat;
@@ -528,64 +526,52 @@ static int iTCO_wdt_ioctl (struct inode *inode, struct file *file,
 	};
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof (ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_KEEPALIVE:
-			iTCO_wdt_keepalive();
-			return 0;
-
-		case WDIOC_SETOPTIONS:
-		{
-			if (get_user(new_options, p))
-				return -EFAULT;
-
-			if (new_options & WDIOS_DISABLECARD) {
-				iTCO_wdt_stop();
-				retval = 0;
-			}
-
-			if (new_options & WDIOS_ENABLECARD) {
-				iTCO_wdt_keepalive();
-				iTCO_wdt_start();
-				retval = 0;
-			}
-
-			return retval;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_SETOPTIONS:
+	{
+		if (get_user(new_options, p))
+			return -EFAULT;
+
+		if (new_options & WDIOS_DISABLECARD) {
+			iTCO_wdt_stop();
+			retval = 0;
 		}
-
-		case WDIOC_SETTIMEOUT:
-		{
-			if (get_user(new_heartbeat, p))
-				return -EFAULT;
-
-			if (iTCO_wdt_set_heartbeat(new_heartbeat))
-				return -EINVAL;
-
+		if (new_options & WDIOS_ENABLECARD) {
 			iTCO_wdt_keepalive();
-			/* Fall */
-		}
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, p);
-
-		case WDIOC_GETTIMELEFT:
-		{
-			int time_left;
-
-			if (iTCO_wdt_get_timeleft(&time_left))
-				return -EINVAL;
-
-			return put_user(time_left, p);
+			iTCO_wdt_start();
+			retval = 0;
 		}
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		iTCO_wdt_keepalive();
+		return 0;
 
-		default:
-			return -ENOTTY;
+	case WDIOC_SETTIMEOUT:
+	{
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
+		if (iTCO_wdt_set_heartbeat(new_heartbeat))
+			return -EINVAL;
+		iTCO_wdt_keepalive();
+		/* Fall */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	case WDIOC_GETTIMELEFT:
+	{
+		int time_left;
+		if (iTCO_wdt_get_timeleft(&time_left))
+			return -EINVAL;
+		return put_user(time_left, p);
+	}
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -594,12 +580,12 @@ static int iTCO_wdt_ioctl (struct inode *inode, struct file *file,
  */
 
 static const struct file_operations iTCO_wdt_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	no_llseek,
-	.write =	iTCO_wdt_write,
-	.ioctl =	iTCO_wdt_ioctl,
-	.open =		iTCO_wdt_open,
-	.release =	iTCO_wdt_release,
+	.owner =		THIS_MODULE,
+	.llseek =		no_llseek,
+	.write =		iTCO_wdt_write,
+	.unlocked_ioctl =	iTCO_wdt_ioctl,
+	.open =			iTCO_wdt_open,
+	.release =		iTCO_wdt_release,
 };
 
 static struct miscdevice iTCO_wdt_miscdev = {
@@ -612,7 +598,8 @@ static struct miscdevice iTCO_wdt_miscdev = {
  *	Init & exit routines
  */
 
-static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device_id *ent, struct platform_device *dev)
+static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
+		const struct pci_device_id *ent, struct platform_device *dev)
 {
 	int ret;
 	u32 base_address;
@@ -632,17 +619,19 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device
 		pci_dev_put(pdev);
 		return -ENODEV;
 	}
-	iTCO_wdt_private.iTCO_version = iTCO_chipset_info[ent->driver_data].iTCO_version;
+	iTCO_wdt_private.iTCO_version =
+			iTCO_chipset_info[ent->driver_data].iTCO_version;
 	iTCO_wdt_private.ACPIBASE = base_address;
 	iTCO_wdt_private.pdev = pdev;
 
-	/* Get the Memory-Mapped GCS register, we need it for the NO_REBOOT flag (TCO v2) */
-	/* To get access to it you have to read RCBA from PCI Config space 0xf0
-	   and use it as base. GCS = RCBA + ICH6_GCS(0x3410). */
+	/* Get the Memory-Mapped GCS register, we need it for the
+	   NO_REBOOT flag (TCO v2). To get access to it you have to
+	   read RCBA from PCI Config space 0xf0 and use it as base.
+	   GCS = RCBA + ICH6_GCS(0x3410). */
 	if (iTCO_wdt_private.iTCO_version == 2) {
 		pci_read_config_dword(pdev, 0xf0, &base_address);
 		RCBA = base_address & 0xffffc000;
-		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410),4);
+		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410), 4);
 	}
 
 	/* Check chipset's NO_REBOOT bit */
@@ -657,8 +646,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device
 
 	/* Set the TCO_EN bit in SMI_EN register */
 	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
-		printk(KERN_ERR PFX "I/O address 0x%04lx already in use\n",
-			SMI_EN );
+		printk(KERN_ERR PFX
+			"I/O address 0x%04lx already in use\n", SMI_EN);
 		ret = -EIO;
 		goto out;
 	}
@@ -667,18 +656,20 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device
 	outl(val32, SMI_EN);
 	release_region(SMI_EN, 4);
 
-	/* The TCO I/O registers reside in a 32-byte range pointed to by the TCOBASE value */
-	if (!request_region (TCOBASE, 0x20, "iTCO_wdt")) {
-		printk (KERN_ERR PFX "I/O address 0x%04lx already in use\n",
+	/* The TCO I/O registers reside in a 32-byte range pointed to
+	   by the TCOBASE value */
+	if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
+		printk(KERN_ERR PFX "I/O address 0x%04lx already in use\n",
 			TCOBASE);
 		ret = -EIO;
 		goto out;
 	}
 
-	printk(KERN_INFO PFX "Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
-		iTCO_chipset_info[ent->driver_data].name,
-		iTCO_chipset_info[ent->driver_data].iTCO_version,
-		TCOBASE);
+	printk(KERN_INFO PFX
+		"Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
+			iTCO_chipset_info[ent->driver_data].name,
+			iTCO_chipset_info[ent->driver_data].iTCO_version,
+			TCOBASE);
 
 	/* Clear out the (probably old) status */
 	outb(0, TCO1_STS);
@@ -687,27 +678,29 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device
 	/* Make sure the watchdog is not running */
 	iTCO_wdt_stop();
 
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
+	/* Check that the heartbeat value is within it's range;
+	   if not reset to the default */
 	if (iTCO_wdt_set_heartbeat(heartbeat)) {
 		iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX "heartbeat value must be 2<heartbeat<39 (TCO v1) or 613 (TCO v2), using %d\n",
-			heartbeat);
+		printk(KERN_INFO PFX "heartbeat value must be 2 < heartbeat < 39 (TCO v1) or 613 (TCO v2), using %d\n",
+							heartbeat);
 	}
 
 	ret = misc_register(&iTCO_wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto unreg_region;
 	}
 
-	printk (KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
-		heartbeat, nowayout);
+	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+							heartbeat, nowayout);
 
 	return 0;
 
 unreg_region:
-	release_region (TCOBASE, 0x20);
+	release_region(TCOBASE, 0x20);
 out:
 	if (iTCO_wdt_private.iTCO_version == 2)
 		iounmap(iTCO_wdt_private.gcs);
@@ -796,7 +789,8 @@ static int __init iTCO_wdt_init_module(void)
 	if (err)
 		return err;
 
-	iTCO_wdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	iTCO_wdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(iTCO_wdt_platform_device)) {
 		err = PTR_ERR(iTCO_wdt_platform_device);
 		goto unreg_platform_driver;
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 4b89f40..05a2810 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -41,9 +41,9 @@
 #include <linux/spinlock.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static struct platform_device *ibwdt_platform_device;
@@ -120,15 +120,16 @@ static int wd_margin = WD_TIMO;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 
 /*
  *	Watchdog Operations
  */
 
-static void
-ibwdt_ping(void)
+static void ibwdt_ping(void)
 {
 	spin_lock(&ibwdt_lock);
 
@@ -138,16 +139,14 @@ ibwdt_ping(void)
 	spin_unlock(&ibwdt_lock);
 }
 
-static void
-ibwdt_disable(void)
+static void ibwdt_disable(void)
 {
 	spin_lock(&ibwdt_lock);
 	outb_p(0, WDT_STOP);
 	spin_unlock(&ibwdt_lock);
 }
 
-static int
-ibwdt_set_heartbeat(int t)
+static int ibwdt_set_heartbeat(int t)
 {
 	int i;
 
@@ -165,8 +164,8 @@ ibwdt_set_heartbeat(int t)
  *	/dev/watchdog handling
  */
 
-static ssize_t
-ibwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t ibwdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -188,77 +187,71 @@ ibwdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppo
 	return count;
 }
 
-static int
-ibwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long ibwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int new_margin;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 
 	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "IB700 WDT",
 	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  if (copy_to_user(argp, &ident, sizeof(ident)))
-	    return -EFAULT;
-	  break;
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
-
-	case WDIOC_KEEPALIVE:
-	  ibwdt_ping();
-	  break;
-
-	case WDIOC_SETTIMEOUT:
-	  if (get_user(new_margin, p))
-		  return -EFAULT;
-	  if (ibwdt_set_heartbeat(new_margin))
-		  return -EINVAL;
-	  ibwdt_ping();
-	  /* Fall */
-
-	case WDIOC_GETTIMEOUT:
-	  return put_user(wd_times[wd_margin], p);
+		return put_user(0, p);
 
 	case WDIOC_SETOPTIONS:
 	{
-	  int options, retval = -EINVAL;
+		int options, retval = -EINVAL;
 
-	  if (get_user(options, p))
-	    return -EFAULT;
+		if (get_user(options, p))
+			return -EFAULT;
 
-	  if (options & WDIOS_DISABLECARD) {
-	    ibwdt_disable();
-	    retval = 0;
-	  }
+		if (options & WDIOS_DISABLECARD) {
+			ibwdt_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			ibwdt_ping();
+			retval = 0;
+		}
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		ibwdt_ping();
+		break;
 
-	  if (options & WDIOS_ENABLECARD) {
-	    ibwdt_ping();
-	    retval = 0;
-	  }
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, p))
+			return -EFAULT;
+		if (ibwdt_set_heartbeat(new_margin))
+			return -EINVAL;
+		ibwdt_ping();
+		/* Fall */
 
-	  return retval;
-	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(wd_times[wd_margin], p);
 
 	default:
-	  return -ENOTTY;
+		return -ENOTTY;
 	}
 	return 0;
 }
 
-static int
-ibwdt_open(struct inode *inode, struct file *file)
+static int ibwdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &ibwdt_is_open)) {
+	if (test_and_set_bit(0, &ibwdt_is_open))
 		return -EBUSY;
-	}
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
@@ -267,13 +260,13 @@ ibwdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static int
-ibwdt_close(struct inode *inode, struct file *file)
+static int ibwdt_close(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
 		ibwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
+		printk(KERN_CRIT PFX
+		     "WDT device closed unexpectedly.  WDT will not stop!\n");
 		ibwdt_ping();
 	}
 	clear_bit(0, &ibwdt_is_open);
@@ -289,7 +282,7 @@ static const struct file_operations ibwdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ibwdt_write,
-	.ioctl		= ibwdt_ioctl,
+	.unlocked_ioctl	= ibwdt_ioctl,
 	.open		= ibwdt_open,
 	.release	= ibwdt_close,
 };
@@ -310,21 +303,23 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 
 #if WDT_START != WDT_STOP
 	if (!request_region(WDT_STOP, 1, "IB700 WDT")) {
-		printk (KERN_ERR PFX "STOP method I/O %X is not available.\n", WDT_STOP);
+		printk(KERN_ERR PFX "STOP method I/O %X is not available.\n",
+								WDT_STOP);
 		res = -EIO;
 		goto out_nostopreg;
 	}
 #endif
 
 	if (!request_region(WDT_START, 1, "IB700 WDT")) {
-		printk (KERN_ERR PFX "START method I/O %X is not available.\n", WDT_START);
+		printk(KERN_ERR PFX "START method I/O %X is not available.\n",
+								WDT_START);
 		res = -EIO;
 		goto out_nostartreg;
 	}
 
 	res = misc_register(&ibwdt_miscdev);
 	if (res) {
-		printk (KERN_ERR PFX "failed to register misc device\n");
+		printk(KERN_ERR PFX "failed to register misc device\n");
 		goto out_nomisc;
 	}
 	return 0;
@@ -342,9 +337,9 @@ out_nostopreg:
 static int __devexit ibwdt_remove(struct platform_device *dev)
 {
 	misc_deregister(&ibwdt_miscdev);
-	release_region(WDT_START,1);
+	release_region(WDT_START, 1);
 #if WDT_START != WDT_STOP
-	release_region(WDT_STOP,1);
+	release_region(WDT_STOP, 1);
 #endif
 	return 0;
 }
@@ -369,13 +364,15 @@ static int __init ibwdt_init(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "WDT driver for IB700 single board computer initialising.\n");
+	printk(KERN_INFO PFX
+		"WDT driver for IB700 single board computer initialising.\n");
 
 	err = platform_driver_register(&ibwdt_driver);
 	if (err)
 		return err;
 
-	ibwdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	ibwdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(ibwdt_platform_device)) {
 		err = PTR_ERR(ibwdt_platform_device);
 		goto unreg_platform_driver;
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index 94155f6..b82405c 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -19,9 +19,8 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/dmi.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 
 enum {
@@ -70,10 +69,13 @@ static char asr_expect_close;
 static unsigned int asr_type, asr_base, asr_length;
 static unsigned int asr_read_addr, asr_write_addr;
 static unsigned char asr_toggle_mask, asr_disable_mask;
+static spinlock_t asr_lock;
 
-static void asr_toggle(void)
+static void __asr_toggle(void)
 {
-	unsigned char reg = inb(asr_read_addr);
+	unsigned char reg;
+
+	reg = inb(asr_read_addr);
 
 	outb(reg & ~asr_toggle_mask, asr_write_addr);
 	reg = inb(asr_read_addr);
@@ -83,12 +85,21 @@ static void asr_toggle(void)
 
 	outb(reg & ~asr_toggle_mask, asr_write_addr);
 	reg = inb(asr_read_addr);
+	spin_unlock(&asr_lock);
+}
+
+static void asr_toggle(void)
+{
+	spin_lock(&asr_lock);
+	__asr_toggle();
+	spin_unlock(&asr_lock);
 }
 
 static void asr_enable(void)
 {
 	unsigned char reg;
 
+	spin_lock(&asr_lock);
 	if (asr_type == ASMTYPE_TOPAZ) {
 		/* asr_write_addr == asr_read_addr */
 		reg = inb(asr_read_addr);
@@ -99,17 +110,21 @@ static void asr_enable(void)
 		 * First make sure the hardware timer is reset by toggling
 		 * ASR hardware timer line.
 		 */
-		asr_toggle();
+		__asr_toggle();
 
 		reg = inb(asr_read_addr);
 		outb(reg & ~asr_disable_mask, asr_write_addr);
 	}
 	reg = inb(asr_read_addr);
+	spin_unlock(&asr_lock);
 }
 
 static void asr_disable(void)
 {
-	unsigned char reg = inb(asr_read_addr);
+	unsigned char reg;
+
+	spin_lock(&asr_lock);
+	reg = inb(asr_read_addr);
 
 	if (asr_type == ASMTYPE_TOPAZ)
 		/* asr_write_addr == asr_read_addr */
@@ -122,6 +137,7 @@ static void asr_disable(void)
 		outb(reg | asr_disable_mask, asr_write_addr);
 	}
 	reg = inb(asr_read_addr);
+	spin_unlock(&asr_lock);
 }
 
 static int __init asr_get_base_address(void)
@@ -133,7 +149,8 @@ static int __init asr_get_base_address(void)
 
 	switch (asr_type) {
 	case ASMTYPE_TOPAZ:
-		/* SELECT SuperIO CHIP FOR QUERYING (WRITE 0x07 TO BOTH 0x2E and 0x2F) */
+		/* SELECT SuperIO CHIP FOR QUERYING
+		   (WRITE 0x07 TO BOTH 0x2E and 0x2F) */
 		outb(0x07, 0x2e);
 		outb(0x07, 0x2f);
 
@@ -154,14 +171,26 @@ static int __init asr_get_base_address(void)
 
 	case ASMTYPE_JASPER:
 		type = "Jaspers ";
-
-		/* FIXME: need to use pci_config_lock here, but it's not exported */
+#if 0
+		u32 r;
+		/* Suggested fix */
+		pdev = pci_get_bus_and_slot(0, DEVFN(0x1f, 0));
+		if (pdev == NULL)
+			return -ENODEV;
+		pci_read_config_dword(pdev, 0x58, &r);
+		asr_base = r & 0xFFFE;
+		pci_dev_put(pdev);
+#else
+		/* FIXME: need to use pci_config_lock here,
+		   but it's not exported */
 
 /*		spin_lock_irqsave(&pci_config_lock, flags);*/
 
 		/* Select the SuperIO chip in the PCI I/O port register */
 		outl(0x8000f858, 0xcf8);
 
+		/* BUS 0, Slot 1F, fnc 0, offset 58 */
+
 		/*
 		 * Read the base address for the SuperIO chip.
 		 * Only the lower 16 bits are valid, but the address is word
@@ -170,7 +199,7 @@ static int __init asr_get_base_address(void)
 		asr_base = inl(0xcfc) & 0xfffe;
 
 /*		spin_unlock_irqrestore(&pci_config_lock, flags);*/
-
+#endif
 		asr_read_addr = asr_write_addr =
 			asr_base + JASPER_ASR_REG_OFFSET;
 		asr_toggle_mask = JASPER_ASR_TOGGLE_MASK;
@@ -241,66 +270,57 @@ static ssize_t asr_write(struct file *file, const char __user *buf,
 	return count;
 }
 
-static int asr_ioctl(struct inode *inode, struct file *file,
-		     unsigned int cmd, unsigned long arg)
+static long asr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	static const struct watchdog_info ident = {
-		.options =	WDIOF_KEEPALIVEPING | 
+		.options =	WDIOF_KEEPALIVEPING |
 				WDIOF_MAGICCLOSE,
-		.identity =	"IBM ASR"
+		.identity =	"IBM ASR",
 	};
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int heartbeat;
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident)) ?
-				-EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_KEEPALIVE:
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+	{
+		int new_options, retval = -EINVAL;
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			asr_disable();
+			retval = 0;
+		}
+		if (new_options & WDIOS_ENABLECARD) {
+			asr_enable();
 			asr_toggle();
-			return 0;
-
-		/*
-		 * The hardware has a fixed timeout value, so no WDIOC_SETTIMEOUT
-		 * and WDIOC_GETTIMEOUT always returns 256.
-		 */
-		case WDIOC_GETTIMEOUT:
-			heartbeat = 256;
-			return put_user(heartbeat, p);
-
-		case WDIOC_SETOPTIONS: {
-			int new_options, retval = -EINVAL;
-
-			if (get_user(new_options, p))
-				return -EFAULT;
-
-			if (new_options & WDIOS_DISABLECARD) {
-				asr_disable();
-				retval = 0;
-			}
-
-			if (new_options & WDIOS_ENABLECARD) {
-				asr_enable();
-				asr_toggle();
-				retval = 0;
-			}
-
-			return retval;
+			retval = 0;
 		}
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		asr_toggle();
+		return 0;
+	/*
+	 * The hardware has a fixed timeout value, so no WDIOC_SETTIMEOUT
+	 * and WDIOC_GETTIMEOUT always returns 256.
+	 */
+	case WDIOC_GETTIMEOUT:
+		heartbeat = 256;
+		return put_user(heartbeat, p);
+	default:
+		return -ENOTTY;
 	}
-
-	return -ENOTTY;
 }
 
 static int asr_open(struct inode *inode, struct file *file)
 {
-	if(test_and_set_bit(0, &asr_is_open))
+	if (test_and_set_bit(0, &asr_is_open))
 		return -EBUSY;
 
 	asr_toggle();
@@ -314,7 +334,8 @@ static int asr_release(struct inode *inode, struct file *file)
 	if (asr_expect_close == 42)
 		asr_disable();
 	else {
-		printk(KERN_CRIT PFX "unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+				"unexpected close, not stopping watchdog!\n");
 		asr_toggle();
 	}
 	clear_bit(0, &asr_is_open);
@@ -323,12 +344,12 @@ static int asr_release(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations asr_fops = {
-	.owner =	THIS_MODULE,
-	.llseek	=	no_llseek,
-	.write =	asr_write,
-	.ioctl =	asr_ioctl,
-	.open =		asr_open,
-	.release =	asr_release,
+	.owner =		THIS_MODULE,
+	.llseek =		no_llseek,
+	.write =		asr_write,
+	.unlocked_ioctl =	asr_ioctl,
+	.open =			asr_open,
+	.release =		asr_release,
 };
 
 static struct miscdevice asr_miscdev = {
@@ -367,6 +388,8 @@ static int __init ibmasr_init(void)
 	if (!asr_type)
 		return -ENODEV;
 
+	spin_lock_init(&asr_lock);
+
 	rc = asr_get_base_address();
 	if (rc)
 		return rc;
@@ -395,7 +418,9 @@ module_init(ibmasr_init);
 module_exit(ibmasr_exit);
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 MODULE_DESCRIPTION("IBM Automatic Server Restart driver");
 MODULE_AUTHOR("Andrey Panin");
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index 788245b..73c9e79 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -1,7 +1,8 @@
 /*
  *	IndyDog	0.3	A Hardware Watchdog Device for SGI IP22
  *
- *	(c) Copyright 2002 Guido Guenther <agx@sigxcpu.org>, All Rights Reserved.
+ *	(c) Copyright 2002 Guido Guenther <agx@sigxcpu.org>,
+ *						All Rights Reserved.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -22,32 +23,42 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/sgi/mc.h>
 
 #define PFX "indydog: "
-static int indydog_alive;
+static unsigned long indydog_alive;
+static spinlock_t indydog_lock;
 
 #define WATCHDOG_TIMEOUT 30		/* 30 sec default timeout */
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void indydog_start(void)
 {
-	u32 mc_ctrl0 = sgimc->cpuctrl0;
+	u32 mc_ctrl0;
 
+	spin_lock(&indydog_lock);
+	mc_ctrl0 = sgimc->cpuctrl0;
 	mc_ctrl0 = sgimc->cpuctrl0 | SGIMC_CCTRL0_WDOG;
 	sgimc->cpuctrl0 = mc_ctrl0;
+	spin_unlock(&indydog_lock);
 }
 
 static void indydog_stop(void)
 {
-	u32 mc_ctrl0 = sgimc->cpuctrl0;
+	u32 mc_ctrl0;
 
+	spin_lock(&indydog_lock);
+
+	mc_ctrl0 = sgimc->cpuctrl0;
 	mc_ctrl0 &= ~SGIMC_CCTRL0_WDOG;
 	sgimc->cpuctrl0 = mc_ctrl0;
+	spin_unlock(&indydog_lock);
 
 	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
 }
@@ -62,7 +73,7 @@ static void indydog_ping(void)
  */
 static int indydog_open(struct inode *inode, struct file *file)
 {
-	if (indydog_alive)
+	if (test_and_set_bit(0, &indydog_alive))
 		return -EBUSY;
 
 	if (nowayout)
@@ -84,23 +95,21 @@ static int indydog_release(struct inode *inode, struct file *file)
 	 * Lock it in if it's a module and we defined ...NOWAYOUT */
 	if (!nowayout)
 		indydog_stop();		/* Turn the WDT off */
-
-	indydog_alive = 0;
-
+	clear_bit(0, &indydog_alive);
 	return 0;
 }
 
-static ssize_t indydog_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t indydog_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	/* Refresh the timer. */
-	if (len) {
+	if (len)
 		indydog_ping();
-	}
 	return len;
 }
 
-static int indydog_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long indydog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	static struct watchdog_info ident = {
@@ -111,42 +120,40 @@ static int indydog_ioctl(struct inode *inode, struct file *file,
 	};
 
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			if (copy_to_user((struct watchdog_info *)arg,
-					 &ident, sizeof(ident)))
-				return -EFAULT;
-			return 0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0,(int *)arg);
-		case WDIOC_KEEPALIVE:
-			indydog_ping();
-			return 0;
-		case WDIOC_GETTIMEOUT:
-			return put_user(WATCHDOG_TIMEOUT,(int *)arg);
-		case WDIOC_SETOPTIONS:
-		{
-			if (get_user(options, (int *)arg))
-				return -EFAULT;
-
-			if (options & WDIOS_DISABLECARD) {
-				indydog_stop();
-				retval = 0;
-			}
-
-			if (options & WDIOS_ENABLECARD) {
-				indydog_start();
-				retval = 0;
-			}
-
-			return retval;
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user((struct watchdog_info *)arg,
+				 &ident, sizeof(ident)))
+			return -EFAULT;
+		return 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int *)arg);
+	case WDIOC_SETOPTIONS:
+	{
+		if (get_user(options, (int *)arg))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			indydog_stop();
+			retval = 0;
 		}
+		if (options & WDIOS_ENABLECARD) {
+			indydog_start();
+			retval = 0;
+		}
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		indydog_ping();
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(WATCHDOG_TIMEOUT, (int *)arg);
+	default:
+		return -ENOTTY;
 	}
 }
 
-static int indydog_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int indydog_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
 		indydog_stop();		/* Turn the WDT off */
@@ -158,7 +165,7 @@ static const struct file_operations indydog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= indydog_write,
-	.ioctl		= indydog_ioctl,
+	.unlocked_ioctl	= indydog_ioctl,
 	.open		= indydog_open,
 	.release	= indydog_release,
 };
@@ -180,17 +187,20 @@ static int __init watchdog_init(void)
 {
 	int ret;
 
+	spin_lock_init(&indydog_lock);
+
 	ret = register_reboot_notifier(&indydog_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&indydog_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&indydog_notifier);
 		return ret;
 	}
diff --git a/drivers/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
index bbbd91a..8278b13 100644
--- a/drivers/watchdog/iop_wdt.c
+++ b/drivers/watchdog/iop_wdt.c
@@ -37,6 +37,7 @@
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned long wdt_status;
 static unsigned long boot_status;
+static spinlock_t wdt_lock;
 
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
@@ -68,8 +69,10 @@ static void wdt_enable(void)
 	/* Arm and enable the Timer to starting counting down from 0xFFFF.FFFF
 	 * Takes approx. 10.7s to timeout
 	 */
+	spin_lock(&wdt_lock);
 	write_wdtcr(IOP_WDTCR_EN_ARM);
 	write_wdtcr(IOP_WDTCR_EN);
+	spin_unlock(&wdt_lock);
 }
 
 /* returns 0 if the timer was successfully disabled */
@@ -77,9 +80,11 @@ static int wdt_disable(void)
 {
 	/* Stop Counting */
 	if (wdt_supports_disable()) {
+		spin_lock(&wdt_lock);
 		write_wdtcr(IOP_WDTCR_DIS_ARM);
 		write_wdtcr(IOP_WDTCR_DIS);
 		clear_bit(WDT_ENABLED, &wdt_status);
+		spin_unlock(&wdt_lock);
 		printk(KERN_INFO "WATCHDOG: Disabled\n");
 		return 0;
 	} else
@@ -92,16 +97,12 @@ static int iop_wdt_open(struct inode *inode, struct file *file)
 		return -EBUSY;
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
 	wdt_enable();
-
 	set_bit(WDT_ENABLED, &wdt_status);
-
 	return nonseekable_open(inode, file);
 }
 
-static ssize_t
-iop_wdt_write(struct file *file, const char *data, size_t len,
+static ssize_t iop_wdt_write(struct file *file, const char *data, size_t len,
 		  loff_t *ppos)
 {
 	if (len) {
@@ -121,46 +122,35 @@ iop_wdt_write(struct file *file, const char *data, size_t len,
 		}
 		wdt_enable();
 	}
-
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE | WDIOF_KEEPALIVEPING,
 	.identity = "iop watchdog",
 };
 
-static int
-iop_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		  unsigned long arg)
+static long iop_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	int options;
 	int ret = -ENOTTY;
+	int __user *argp = (int __user *)arg;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user
-		    ((struct watchdog_info *)arg, &ident, sizeof ident))
+		if (copy_to_user(argp, &ident, sizeof ident))
 			ret = -EFAULT;
 		else
 			ret = 0;
 		break;
 
 	case WDIOC_GETSTATUS:
-		ret = put_user(0, (int *)arg);
+		ret = put_user(0, argp);
 		break;
 
 	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(boot_status, (int *)arg);
-		break;
-
-	case WDIOC_GETTIMEOUT:
-		ret = put_user(iop_watchdog_timeout(), (int *)arg);
-		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_enable();
-		ret = 0;
+		ret = put_user(boot_status, argp);
 		break;
 
 	case WDIOC_SETOPTIONS:
@@ -177,14 +167,21 @@ iop_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 			} else
 				ret = 0;
 		}
-
 		if (options & WDIOS_ENABLECARD) {
 			wdt_enable();
 			ret = 0;
 		}
 		break;
-	}
 
+	case WDIOC_KEEPALIVE:
+		wdt_enable();
+		ret = 0;
+		break;
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(iop_watchdog_timeout(), argp);
+		break;
+	}
 	return ret;
 }
 
@@ -214,7 +211,7 @@ static const struct file_operations iop_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = iop_wdt_write,
-	.ioctl = iop_wdt_ioctl,
+	.unlocked_ioctl = iop_wdt_ioctl,
 	.open = iop_wdt_open,
 	.release = iop_wdt_release,
 };
@@ -229,10 +226,8 @@ static int __init iop_wdt_init(void)
 {
 	int ret;
 
-	ret = misc_register(&iop_wdt_miscdev);
-	if (ret == 0)
-		printk("iop watchdog timer: timeout %lu sec\n",
-		       iop_watchdog_timeout());
+	spin_lock_init(&wdt_lock);
+
 
 	/* check if the reset was caused by the watchdog timer */
 	boot_status = (read_rcsr() & IOP_RCSR_WDT) ? WDIOF_CARDRESET : 0;
@@ -242,6 +237,13 @@ static int __init iop_wdt_init(void)
 	 */
 	write_wdtsr(IOP13XX_WDTCR_IB_RESET);
 
+	/* Register after we have the device set up so we cannot race
+	   with an open */
+	ret = misc_register(&iop_wdt_miscdev);
+	if (ret == 0)
+		printk(KERN_INFO "iop watchdog timer: timeout %lu sec\n",
+		       iop_watchdog_timeout());
+
 	return ret;
 }
 
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 51bfd57..2270ee0 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -221,7 +221,7 @@ static ssize_t it8712f_wdt_write(struct file *file, const char __user *data,
 		expect_close = 0;
 		for (i = 0; i < len; ++i) {
 			char c;
-			if (get_user(c, data+i))
+			if (get_user(c, data + i))
 				return -EFAULT;
 			if (c == 'V')
 				expect_close = 42;
@@ -244,8 +244,6 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 	int value;
 
 	switch (cmd) {
-	default:
-		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
 		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
@@ -284,6 +282,8 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
 		if (put_user(margin, p))
 			return -EFAULT;
 		return 0;
+	default:
+		return -ENOTTY;
 	}
 }
 
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index dc7548d..a77f69d 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -25,42 +25,45 @@
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int heartbeat = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
+static spinlock_t wdt_lock;
 
 #define	WDT_IN_USE		0
 #define	WDT_OK_TO_CLOSE		1
 
 static unsigned long wdt_tick_rate;
 
-static void
-wdt_enable(void)
+static void wdt_enable(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_RESET0, *(IXP2000_RESET0) | WDT_RESET_ENABLE);
 	ixp2000_reg_write(IXP2000_TWDE, WDT_ENABLE);
 	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
 	ixp2000_reg_write(IXP2000_T4_CTL, TIMER_DIVIDER_256 | TIMER_ENABLE);
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_disable(void)
+static void wdt_disable(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_T4_CTL, 0);
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_keepalive(void)
+static void wdt_keepalive(void)
 {
+	spin_lock(&wdt_lock);
 	ixp2000_reg_write(IXP2000_T4_CLD, heartbeat * wdt_tick_rate);
+	spin_unlock(&wdt_lock);
 }
 
-static int
-ixp2000_wdt_open(struct inode *inode, struct file *file)
+static int ixp2000_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
 		return -EBUSY;
@@ -72,8 +75,8 @@ ixp2000_wdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static ssize_t
-ixp2000_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t ixp2000_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -103,9 +106,8 @@ static struct watchdog_info ident = {
 	.identity	= "IXP2000 Watchdog",
 };
 
-static int
-ixp2000_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-			unsigned long arg)
+static long ixp2000_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -124,6 +126,11 @@ ixp2000_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		ret = put_user(0, (int *)arg);
 		break;
 
+	case WDIOC_KEEPALIVE:
+		wdt_enable();
+		ret = 0;
+		break;
+
 	case WDIOC_SETTIMEOUT:
 		ret = get_user(time, (int *)arg);
 		if (ret)
@@ -141,26 +148,18 @@ ixp2000_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	case WDIOC_GETTIMEOUT:
 		ret = put_user(heartbeat, (int *)arg);
 		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_enable();
-		ret = 0;
-		break;
 	}
 
 	return ret;
 }
 
-static int
-ixp2000_wdt_release(struct inode *inode, struct file *file)
+static int ixp2000_wdt_release(struct inode *inode, struct file *file)
 {
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
-	} else {
+	else
 		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
 					"timer will not stop\n");
-	}
-
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
@@ -168,18 +167,16 @@ ixp2000_wdt_release(struct inode *inode, struct file *file)
 }
 
 
-static const struct file_operations ixp2000_wdt_fops =
-{
+static const struct file_operations ixp2000_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ixp2000_wdt_write,
-	.ioctl		= ixp2000_wdt_ioctl,
+	.unlocked_ioctl	= ixp2000_wdt_ioctl,
 	.open		= ixp2000_wdt_open,
 	.release	= ixp2000_wdt_release,
 };
 
-static struct miscdevice ixp2000_wdt_miscdev =
-{
+static struct miscdevice ixp2000_wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &ixp2000_wdt_fops,
@@ -191,9 +188,8 @@ static int __init ixp2000_wdt_init(void)
 		printk(KERN_INFO "Unable to use IXP2000 watchdog due to IXP2800 erratum #25.\n");
 		return -EIO;
 	}
-
 	wdt_tick_rate = (*IXP2000_T1_CLD * HZ) / 256;
-
+	spin_lock_init(&wdt_lock);
 	return misc_register(&ixp2000_wdt_miscdev);
 }
 
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 5864bb8..ef3157d 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -22,48 +22,48 @@
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 static int heartbeat = 60;	/* (secs) Default is 1 minute */
 static unsigned long wdt_status;
 static unsigned long boot_status;
+static spin_lock_t wdt_lock;
 
 #define WDT_TICK_RATE (IXP4XX_PERIPHERAL_BUS_CLOCK * 1000000UL)
 
 #define	WDT_IN_USE		0
 #define	WDT_OK_TO_CLOSE		1
 
-static void
-wdt_enable(void)
+static void wdt_enable(void)
 {
+	spin_lock(&wdt_lock);
 	*IXP4XX_OSWK = IXP4XX_WDT_KEY;
 	*IXP4XX_OSWE = 0;
 	*IXP4XX_OSWT = WDT_TICK_RATE * heartbeat;
 	*IXP4XX_OSWE = IXP4XX_WDT_COUNT_ENABLE | IXP4XX_WDT_RESET_ENABLE;
 	*IXP4XX_OSWK = 0;
+	spin_unlock(&wdt_lock);
 }
 
-static void
-wdt_disable(void)
+static void wdt_disable(void)
 {
+	spin_lock(&wdt_lock);
 	*IXP4XX_OSWK = IXP4XX_WDT_KEY;
 	*IXP4XX_OSWE = 0;
 	*IXP4XX_OSWK = 0;
+	spin_unlock(&wdt_lock);
 }
 
-static int
-ixp4xx_wdt_open(struct inode *inode, struct file *file)
+static int ixp4xx_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
 		return -EBUSY;
 
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
-
 	wdt_enable();
-
 	return nonseekable_open(inode, file);
 }
 
@@ -87,7 +87,6 @@ ixp4xx_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
 		}
 		wdt_enable();
 	}
-
 	return len;
 }
 
@@ -98,9 +97,8 @@ static struct watchdog_info ident = {
 };
 
 
-static int
-ixp4xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-			unsigned long arg)
+static long ixp4xx_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -119,6 +117,11 @@ ixp4xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		ret = put_user(boot_status, (int *)arg);
 		break;
 
+	case WDIOC_KEEPALIVE:
+		wdt_enable();
+		ret = 0;
+		break;
+
 	case WDIOC_SETTIMEOUT:
 		ret = get_user(time, (int *)arg);
 		if (ret)
@@ -136,25 +139,17 @@ ixp4xx_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	case WDIOC_GETTIMEOUT:
 		ret = put_user(heartbeat, (int *)arg);
 		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_enable();
-		ret = 0;
-		break;
 	}
 	return ret;
 }
 
-static int
-ixp4xx_wdt_release(struct inode *inode, struct file *file)
+static int ixp4xx_wdt_release(struct inode *inode, struct file *file)
 {
-	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
-	} else {
+	else
 		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
 					"timer will not stop\n");
-	}
-
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
 
@@ -162,18 +157,16 @@ ixp4xx_wdt_release(struct inode *inode, struct file *file)
 }
 
 
-static const struct file_operations ixp4xx_wdt_fops =
-{
+static const struct file_operations ixp4xx_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= ixp4xx_wdt_write,
-	.ioctl		= ixp4xx_wdt_ioctl,
+	.unlocked_ioctl	= ixp4xx_wdt_ioctl,
 	.open		= ixp4xx_wdt_open,
 	.release	= ixp4xx_wdt_release,
 };
 
-static struct miscdevice ixp4xx_wdt_miscdev =
-{
+static struct miscdevice ixp4xx_wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &ixp4xx_wdt_fops,
@@ -186,19 +179,18 @@ static int __init ixp4xx_wdt_init(void)
 
 	asm("mrc p15, 0, %0, cr0, cr0, 0;" : "=r"(processor_id) :);
 	if (!(processor_id & 0xf) && !cpu_is_ixp46x()) {
-		printk("IXP4XXX Watchdog: Rev. A0 IXP42x CPU detected - "
-			"watchdog disabled\n");
+		printk(KERN_ERR "IXP4XXX Watchdog: Rev. A0 IXP42x CPU detected"
+			" - watchdog disabled\n");
 
 		return -ENODEV;
 	}
-
-	ret = misc_register(&ixp4xx_wdt_miscdev);
-	if (ret == 0)
-		printk("IXP4xx Watchdog Timer: heartbeat %d sec\n", heartbeat);
-
+	spin_lock_init(&wdt_lock);
 	boot_status = (*IXP4XX_OSST & IXP4XX_OSST_TIMER_WARM_RESET) ?
 			WDIOF_CARDRESET : 0;
-
+	ret = misc_register(&ixp4xx_wdt_miscdev);
+	if (ret == 0)
+		printk(KERN_INFO "IXP4xx Watchdog Timer: heartbeat %d sec\n",
+			heartbeat);
 	return ret;
 }
 
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index df5a6b8..f8566d5 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -19,8 +19,8 @@
 #include <linux/platform_device.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/arch/regs-timer.h>
 
 
@@ -31,38 +31,44 @@ static int wdt_time = WDT_DEFAULT_TIME;
 static int nowayout = WATCHDOG_NOWAYOUT;
 
 module_param(wdt_time, int, 0);
-MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="__MODULE_STRING(WDT_DEFAULT_TIME) ")");
+MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
+					__MODULE_STRING(WDT_DEFAULT_TIME) ")");
 
 #ifdef CONFIG_WATCHDOG_NOWAYOUT
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 #endif
 
 
 static unsigned long ks8695wdt_busy;
+static spinlock_t ks8695_lock;
 
 /* ......................................................................... */
 
 /*
  * Disable the watchdog.
  */
-static void inline ks8695_wdt_stop(void)
+static inline void ks8695_wdt_stop(void)
 {
 	unsigned long tmcon;
 
+	spin_lock(&ks8695_lock);
 	/* disable timer0 */
 	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
 	__raw_writel(tmcon & ~TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+	spin_unlock(&ks8695_lock);
 }
 
 /*
  * Enable and reset the watchdog.
  */
-static void inline ks8695_wdt_start(void)
+static inline void ks8695_wdt_start(void)
 {
 	unsigned long tmcon;
 	unsigned long tval = wdt_time * CLOCK_TICK_RATE;
 
+	spin_lock(&ks8695_lock);
 	/* disable timer0 */
 	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
 	__raw_writel(tmcon & ~TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
@@ -73,19 +79,22 @@ static void inline ks8695_wdt_start(void)
 	/* re-enable timer0 */
 	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
 	__raw_writel(tmcon | TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+	spin_unlock(&ks8695_lock);
 }
 
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
-static void inline ks8695_wdt_reload(void)
+static inline void ks8695_wdt_reload(void)
 {
 	unsigned long tmcon;
 
+	spin_lock(&ks8695_lock);
 	/* disable, then re-enable timer0 */
 	tmcon = __raw_readl(KS8695_TMR_VA + KS8695_TMCON);
 	__raw_writel(tmcon & ~TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
 	__raw_writel(tmcon | TMCON_T0EN, KS8695_TMR_VA + KS8695_TMCON);
+	spin_unlock(&ks8695_lock);
 }
 
 /*
@@ -102,7 +111,8 @@ static int ks8695_wdt_settimeout(int new_time)
 	if ((new_time <= 0) || (new_time > WDT_MAX_TIME))
 		return -EINVAL;
 
-	/* Set new watchdog time. It will be used when ks8695_wdt_start() is called. */
+	/* Set new watchdog time. It will be used when
+	   ks8695_wdt_start() is called. */
 	wdt_time = new_time;
 	return 0;
 }
@@ -128,9 +138,9 @@ static int ks8695_wdt_open(struct inode *inode, struct file *file)
  */
 static int ks8695_wdt_close(struct inode *inode, struct file *file)
 {
+	/* Disable the watchdog when file is closed */
 	if (!nowayout)
-		ks8695_wdt_stop();	/* Disable the watchdog when file is closed */
-
+		ks8695_wdt_stop();
 	clear_bit(0, &ks8695wdt_busy);
 	return 0;
 }
@@ -143,60 +153,52 @@ static struct watchdog_info ks8695_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static int ks8695_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long ks8695_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_value;
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			ks8695_wdt_reload();	/* pat the watchdog */
-			return 0;
-
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ks8695_wdt_info, sizeof(ks8695_wdt_info)) ? -EFAULT : 0;
-
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_value, p))
-				return -EFAULT;
-
-			if (ks8695_wdt_settimeout(new_value))
-				return -EINVAL;
-
-			/* Enable new time value */
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ks8695_wdt_info,
+					sizeof(ks8695_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (new_value & WDIOS_DISABLECARD)
+			ks8695_wdt_stop();
+		if (new_value & WDIOS_ENABLECARD)
 			ks8695_wdt_start();
-
-			/* Return current value */
-			return put_user(wdt_time, p);
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(wdt_time, p);
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_SETOPTIONS:
-			if (get_user(new_value, p))
-				return -EFAULT;
-
-			if (new_value & WDIOS_DISABLECARD)
-				ks8695_wdt_stop();
-			if (new_value & WDIOS_ENABLECARD)
-				ks8695_wdt_start();
-			return 0;
-
-		default:
-			return -ENOTTY;
+		return 0;
+	case WDIOC_KEEPALIVE:
+		ks8695_wdt_reload();	/* pat the watchdog */
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if (ks8695_wdt_settimeout(new_value))
+			return -EINVAL;
+		/* Enable new time value */
+		ks8695_wdt_start();
+		/* Return current value */
+		return put_user(wdt_time, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt_time, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
 /*
  * Pat the watchdog whenever device is written to.
  */
-static ssize_t ks8695_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t ks8695_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	ks8695_wdt_reload();		/* pat the watchdog */
 	return len;
@@ -207,7 +209,7 @@ static ssize_t ks8695_wdt_write(struct file *file, const char *data, size_t len,
 static const struct file_operations ks8695wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= ks8695_wdt_ioctl,
+	.unlocked_ioctl	= ks8695_wdt_ioctl,
 	.open		= ks8695_wdt_open,
 	.release	= ks8695_wdt_close,
 	.write		= ks8695_wdt_write,
@@ -231,7 +233,8 @@ static int __init ks8695wdt_probe(struct platform_device *pdev)
 	if (res)
 		return res;
 
-	printk("KS8695 Watchdog Timer enabled (%d seconds%s)\n", wdt_time, nowayout ? ", nowayout" : "");
+	printk(KERN_INFO "KS8695 Watchdog Timer enabled (%d seconds%s)\n",
+				wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
 
@@ -285,12 +288,14 @@ static struct platform_driver ks8695wdt_driver = {
 
 static int __init ks8695_wdt_init(void)
 {
-	/* Check that the heartbeat value is within range; if not reset to the default */
+	spin_lock_init(&ks8695_lock);
+	/* Check that the heartbeat value is within range;
+	   if not reset to the default */
 	if (ks8695_wdt_settimeout(wdt_time)) {
 		ks8695_wdt_settimeout(WDT_DEFAULT_TIME);
-		pr_info("ks8695_wdt: wdt_time value must be 1 <= wdt_time <= %i, using %d\n", wdt_time, WDT_MAX_TIME);
+		pr_info("ks8695_wdt: wdt_time value must be 1 <= wdt_time <= %i, using %d\n",
+							wdt_time, WDT_MAX_TIME);
 	}
-
 	return platform_driver_register(&ks8695wdt_driver);
 }
 
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 6905135..2dfc275 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -40,9 +40,9 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 /* ports */
@@ -95,7 +95,9 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #define PFX "machzwd"
 
@@ -114,7 +116,7 @@ static struct watchdog_info zf_info = {
  * 3 = GEN_SCI
  * defaults to GEN_RESET (0)
  */
-static int action = 0;
+static int action;
 module_param(action, int, 0);
 MODULE_PARM_DESC(action, "after watchdog resets, generate: 0 = RESET(*)  1 = SMI  2 = NMI  3 = SCI");
 
@@ -123,10 +125,9 @@ static void zf_ping(unsigned long data);
 static int zf_action = GEN_RESET;
 static unsigned long zf_is_open;
 static char zf_expect_close;
-static DEFINE_SPINLOCK(zf_lock);
 static DEFINE_SPINLOCK(zf_port_lock);
 static DEFINE_TIMER(zf_timer, zf_ping, 0, 0);
-static unsigned long next_heartbeat = 0;
+static unsigned long next_heartbeat;
 
 
 /* timeout for user land heart beat (10 seconds) */
@@ -171,13 +172,13 @@ static inline void zf_set_control(unsigned short new)
 
 static inline void zf_set_timer(unsigned short new, unsigned char n)
 {
-	switch(n){
-		case WD1:
-			zf_writew(COUNTER_1, new);
-		case WD2:
-			zf_writeb(COUNTER_2, new > 0xff ? 0xff : new);
-		default:
-			return;
+	switch (n) {
+	case WD1:
+		zf_writew(COUNTER_1, new);
+	case WD2:
+		zf_writeb(COUNTER_2, new > 0xff ? 0xff : new);
+	default:
+		return;
 	}
 }
 
@@ -241,10 +242,8 @@ static void zf_ping(unsigned long data)
 
 	zf_writeb(COUNTER_2, 0xff);
 
-	if(time_before(jiffies, next_heartbeat)){
-
+	if (time_before(jiffies, next_heartbeat)) {
 		dprintk("time_before: %ld\n", next_heartbeat - jiffies);
-
 		/*
 		 * reset event is activated by transition from 0 to 1 on
 		 * RESET_WD1 bit and we assume that it is already zero...
@@ -261,24 +260,21 @@ static void zf_ping(unsigned long data)
 		spin_unlock_irqrestore(&zf_port_lock, flags);
 
 		mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
-	}else{
+	} else
 		printk(KERN_CRIT PFX ": I will reset your machine\n");
-	}
 }
 
 static ssize_t zf_write(struct file *file, const char __user *buf, size_t count,
 								loff_t *ppos)
 {
 	/* See if we got the magic character */
-	if(count){
-
+	if (count) {
 		/*
 		 * no need to check for close confirmation
 		 * no way to disable watchdog ;)
 		 */
 		if (!nowayout) {
 			size_t ofs;
-
 			/*
 			 * note: just in case someone wrote the magic character
 			 * five months ago...
@@ -286,11 +282,11 @@ static ssize_t zf_write(struct file *file, const char __user *buf, size_t count,
 			zf_expect_close = 0;
 
 			/* now scan */
-			for (ofs = 0; ofs != count; ofs++){
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
 				if (get_user(c, buf + ofs))
 					return -EFAULT;
-				if (c == 'V'){
+				if (c == 'V') {
 					zf_expect_close = 42;
 					dprintk("zf_expect_close = 42\n");
 				}
@@ -303,14 +299,11 @@ static ssize_t zf_write(struct file *file, const char __user *buf, size_t count,
 		 */
 		next_heartbeat = jiffies + ZF_USER_TIMEO;
 		dprintk("user ping at %ld\n", jiffies);
-
 	}
-
 	return count;
 }
 
-static int zf_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long zf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -319,55 +312,38 @@ static int zf_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		if (copy_to_user(argp, &zf_info, sizeof(zf_info)))
 			return -EFAULT;
 		break;
-
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
-
 	case WDIOC_KEEPALIVE:
 		zf_ping(0);
 		break;
-
 	default:
 		return -ENOTTY;
 	}
-
 	return 0;
 }
 
 static int zf_open(struct inode *inode, struct file *file)
 {
-	spin_lock(&zf_lock);
-	if(test_and_set_bit(0, &zf_is_open)) {
-		spin_unlock(&zf_lock);
+	if (test_and_set_bit(0, &zf_is_open))
 		return -EBUSY;
-	}
-
 	if (nowayout)
 		__module_get(THIS_MODULE);
-
-	spin_unlock(&zf_lock);
-
 	zf_timer_on();
-
 	return nonseekable_open(inode, file);
 }
 
 static int zf_close(struct inode *inode, struct file *file)
 {
-	if(zf_expect_close == 42){
+	if (zf_expect_close == 42)
 		zf_timer_off();
-	} else {
+	else {
 		del_timer(&zf_timer);
 		printk(KERN_ERR PFX ": device file closed unexpectedly. Will not stop the WDT!\n");
 	}
-
-	spin_lock(&zf_lock);
 	clear_bit(0, &zf_is_open);
-	spin_unlock(&zf_lock);
-
 	zf_expect_close = 0;
-
 	return 0;
 }
 
@@ -378,23 +354,18 @@ static int zf_close(struct inode *inode, struct file *file)
 static int zf_notify_sys(struct notifier_block *this, unsigned long code,
 								void *unused)
 {
-	if(code == SYS_DOWN || code == SYS_HALT){
+	if (code == SYS_DOWN || code == SYS_HALT)
 		zf_timer_off();
-	}
-
 	return NOTIFY_DONE;
 }
 
-
-
-
 static const struct file_operations zf_fops = {
-	.owner          = THIS_MODULE,
-	.llseek         = no_llseek,
-	.write          = zf_write,
-	.ioctl          = zf_ioctl,
-	.open           = zf_open,
-	.release        = zf_close,
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= zf_write,
+	.unlocked_ioctl = zf_ioctl,
+	.open		= zf_open,
+	.release	= zf_close,
 };
 
 static struct miscdevice zf_miscdev = {
@@ -402,7 +373,7 @@ static struct miscdevice zf_miscdev = {
 	.name = "watchdog",
 	.fops = &zf_fops,
 };
- 
+
 
 /*
  * The device needs to learn about soft shutdowns in order to
@@ -423,22 +394,23 @@ static int __init zf_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO PFX ": MachZ ZF-Logic Watchdog driver initializing.\n");
+	printk(KERN_INFO PFX
+		": MachZ ZF-Logic Watchdog driver initializing.\n");
 
 	ret = zf_get_ZFL_version();
-	if ((!ret) || (ret == 0xffff)) {
+	if (!ret || ret == 0xffff) {
 		printk(KERN_WARNING PFX ": no ZF-Logic found\n");
 		return -ENODEV;
 	}
 
-	if((action <= 3) && (action >= 0)){
-		zf_action = zf_action>>action;
-	} else
+	if (action <= 3 && action >= 0)
+		zf_action = zf_action >> action;
+	else
 		action = 0;
 
 	zf_show_action(action);
 
-	if(!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")){
+	if (!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")) {
 		printk(KERN_ERR "cannot reserve I/O ports at %d\n",
 							ZF_IOBASE);
 		ret = -EBUSY;
@@ -446,14 +418,14 @@ static int __init zf_init(void)
 	}
 
 	ret = register_reboot_notifier(&zf_notifier);
-	if(ret){
+	if (ret) {
 		printk(KERN_ERR "can't register reboot notifier (err=%d)\n",
 									ret);
 		goto no_reboot;
 	}
 
 	ret = misc_register(&zf_miscdev);
-	if (ret){
+	if (ret) {
 		printk(KERN_ERR "can't misc_register on minor=%d\n",
 							WATCHDOG_MINOR);
 		goto no_misc;
diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
index 1adf1d5..407b025 100644
--- a/drivers/watchdog/mixcomwd.c
+++ b/drivers/watchdog/mixcomwd.c
@@ -29,7 +29,8 @@
  *		- support for one more type board
  *
  * Version 0.5 (2001/12/14) Matt Domsch <Matt_Domsch@dell.com>
- *		- added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
+ *		- added nowayout module option to override
+ *		  CONFIG_WATCHDOG_NOWAYOUT
  *
  * Version 0.6 (2002/04/12): Rob Radez <rob@osinvestor.com>
  *		- make mixcomwd_opened unsigned,
@@ -53,8 +54,8 @@
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/timer.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 /*
  * We have two types of cards that can be probed:
@@ -108,18 +109,19 @@ static char expect_close;
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void mixcomwd_ping(void)
 {
-	outb_p(55,watchdog_port);
+	outb_p(55, watchdog_port);
 	return;
 }
 
 static void mixcomwd_timerfun(unsigned long d)
 {
 	mixcomwd_ping();
-
 	mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 }
 
@@ -129,22 +131,22 @@ static void mixcomwd_timerfun(unsigned long d)
 
 static int mixcomwd_open(struct inode *inode, struct file *file)
 {
-	if(test_and_set_bit(0,&mixcomwd_opened)) {
+	if (test_and_set_bit(0, &mixcomwd_opened))
 		return -EBUSY;
-	}
+
 	mixcomwd_ping();
 
-	if (nowayout) {
+	if (nowayout)
 		/*
 		 * fops_get() code via open() has already done
 		 * a try_module_get() so it is safe to do the
 		 * __module_get().
 		 */
 		__module_get(THIS_MODULE);
-	} else {
-		if(mixcomwd_timer_alive) {
+	else {
+		if (mixcomwd_timer_alive) {
 			del_timer(&mixcomwd_timer);
-			mixcomwd_timer_alive=0;
+			mixcomwd_timer_alive = 0;
 		}
 	}
 	return nonseekable_open(inode, file);
@@ -153,26 +155,27 @@ static int mixcomwd_open(struct inode *inode, struct file *file)
 static int mixcomwd_release(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
-		if(mixcomwd_timer_alive) {
-			printk(KERN_ERR PFX "release called while internal timer alive");
+		if (mixcomwd_timer_alive) {
+			printk(KERN_ERR PFX
+				"release called while internal timer alive");
 			return -EBUSY;
 		}
-		mixcomwd_timer_alive=1;
+		mixcomwd_timer_alive = 1;
 		mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
-	} else {
-		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
-	}
+	} else
+		printk(KERN_CRIT PFX
+		    "WDT device closed unexpectedly.  WDT will not stop!\n");
 
-	clear_bit(0,&mixcomwd_opened);
-	expect_close=0;
+	clear_bit(0, &mixcomwd_opened);
+	expect_close = 0;
 	return 0;
 }
 
 
-static ssize_t mixcomwd_write(struct file *file, const char __user *data, size_t len, loff_t *ppos)
+static ssize_t mixcomwd_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
 {
-	if(len)
-	{
+	if (len) {
 		if (!nowayout) {
 			size_t i;
 
@@ -192,8 +195,8 @@ static ssize_t mixcomwd_write(struct file *file, const char __user *data, size_t
 	return len;
 }
 
-static int mixcomwd_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long mixcomwd_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -204,32 +207,23 @@ static int mixcomwd_ioctl(struct inode *inode, struct file *file,
 		.identity = "MixCOM watchdog",
 	};
 
-	switch(cmd)
-	{
-		case WDIOC_GETSTATUS:
-			status=mixcomwd_opened;
-			if (!nowayout) {
-				status|=mixcomwd_timer_alive;
-			}
-			if (copy_to_user(p, &status, sizeof(int))) {
-				return -EFAULT;
-			}
-			break;
-		case WDIOC_GETBOOTSTATUS:
-			if (copy_to_user(p, &status, sizeof(int))) {
-				return -EFAULT;
-			}
-			break;
-		case WDIOC_GETSUPPORT:
-			if (copy_to_user(argp, &ident, sizeof(ident))) {
-				return -EFAULT;
-			}
-			break;
-		case WDIOC_KEEPALIVE:
-			mixcomwd_ping();
-			break;
-		default:
-			return -ENOTTY;
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_GETSTATUS:
+		status = mixcomwd_opened;
+		if (!nowayout)
+			status |= mixcomwd_timer_alive;
+		return put_user(status, p);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		mixcomwd_ping();
+		break;
+	default:
+		return -ENOTTY;
 	}
 	return 0;
 }
@@ -238,7 +232,7 @@ static const struct file_operations mixcomwd_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= mixcomwd_write,
-	.ioctl		= mixcomwd_ioctl,
+	.unlocked_ioctl	= mixcomwd_ioctl,
 	.open		= mixcomwd_open,
 	.release	= mixcomwd_release,
 };
@@ -253,15 +247,14 @@ static int __init checkcard(int port, int card_id)
 {
 	int id;
 
-	if (!request_region(port, 1, "MixCOM watchdog")) {
+	if (!request_region(port, 1, "MixCOM watchdog"))
 		return 0;
-	}
 
-	id=inb_p(port);
-	if (card_id==MIXCOM_ID)
+	id = inb_p(port);
+	if (card_id == MIXCOM_ID)
 		id &= 0x3f;
 
-	if (id!=card_id) {
+	if (id != card_id) {
 		release_region(port, 1);
 		return 0;
 	}
@@ -270,9 +263,7 @@ static int __init checkcard(int port, int card_id)
 
 static int __init mixcomwd_init(void)
 {
-	int i;
-	int ret;
-	int found=0;
+	int i, ret, found = 0;
 
 	for (i = 0; !found && mixcomwd_io_info[i].ioport != 0; i++) {
 		if (checkcard(mixcomwd_io_info[i].ioport,
@@ -283,20 +274,22 @@ static int __init mixcomwd_init(void)
 	}
 
 	if (!found) {
-		printk(KERN_ERR PFX "No card detected, or port not available.\n");
+		printk(KERN_ERR PFX
+			"No card detected, or port not available.\n");
 		return -ENODEV;
 	}
 
 	ret = misc_register(&mixcomwd_miscdev);
-	if (ret)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+	if (ret) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+					WATCHDOG_MINOR, ret);
 		goto error_misc_register_watchdog;
 	}
 
-	printk(KERN_INFO "MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",
-		VERSION, watchdog_port);
+	printk(KERN_INFO
+		"MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",
+					VERSION, watchdog_port);
 
 	return 0;
 
@@ -309,15 +302,15 @@ error_misc_register_watchdog:
 static void __exit mixcomwd_exit(void)
 {
 	if (!nowayout) {
-		if(mixcomwd_timer_alive) {
+		if (mixcomwd_timer_alive) {
 			printk(KERN_WARNING PFX "I quit now, hardware will"
 			       " probably reboot!\n");
 			del_timer_sync(&mixcomwd_timer);
-			mixcomwd_timer_alive=0;
+			mixcomwd_timer_alive = 0;
 		}
 	}
 	misc_deregister(&mixcomwd_miscdev);
-	release_region(watchdog_port,1);
+	release_region(watchdog_port, 1);
 }
 
 module_init(mixcomwd_init);
diff --git a/drivers/watchdog/mpc5200_wdt.c b/drivers/watchdog/mpc5200_wdt.c
index 77c1c2a..db91892 100644
--- a/drivers/watchdog/mpc5200_wdt.c
+++ b/drivers/watchdog/mpc5200_wdt.c
@@ -5,7 +5,7 @@
 #include <linux/io.h>
 #include <linux/spinlock.h>
 #include <linux/of_platform.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/mpc52xx.h>
 
 
@@ -57,7 +57,8 @@ static int mpc5200_wdt_start(struct mpc5200_wdt *wdt)
 	/* set timeout, with maximum prescaler */
 	out_be32(&wdt->regs->count, 0x0 | wdt->count);
 	/* enable watchdog */
-	out_be32(&wdt->regs->mode, GPT_MODE_CE | GPT_MODE_WDT | GPT_MODE_MS_TIMER);
+	out_be32(&wdt->regs->mode, GPT_MODE_CE | GPT_MODE_WDT |
+						GPT_MODE_MS_TIMER);
 	spin_unlock(&wdt->io_lock);
 
 	return 0;
@@ -66,7 +67,8 @@ static int mpc5200_wdt_ping(struct mpc5200_wdt *wdt)
 {
 	spin_lock(&wdt->io_lock);
 	/* writing A5 to OCPW resets the watchdog */
-	out_be32(&wdt->regs->mode, 0xA5000000 | (0xffffff & in_be32(&wdt->regs->mode)));
+	out_be32(&wdt->regs->mode, 0xA5000000 |
+				(0xffffff & in_be32(&wdt->regs->mode)));
 	spin_unlock(&wdt->io_lock);
 	return 0;
 }
@@ -92,8 +94,8 @@ static struct watchdog_info mpc5200_wdt_info = {
 	.options	= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity	= "mpc5200 watchdog on GPT0",
 };
-static int mpc5200_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long mpc5200_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct mpc5200_wdt *wdt = file->private_data;
 	int __user *data = (int __user *)arg;
@@ -103,7 +105,7 @@ static int mpc5200_wdt_ioctl(struct inode *inode, struct file *file,
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ret = copy_to_user(data, &mpc5200_wdt_info,
-			sizeof(mpc5200_wdt_info));
+						sizeof(mpc5200_wdt_info));
 		if (ret)
 			ret = -EFAULT;
 		break;
@@ -135,6 +137,7 @@ static int mpc5200_wdt_ioctl(struct inode *inode, struct file *file,
 	}
 	return ret;
 }
+
 static int mpc5200_wdt_open(struct inode *inode, struct file *file)
 {
 	/* /dev/watchdog can only be opened once */
@@ -161,13 +164,14 @@ static int mpc5200_wdt_release(struct inode *inode, struct file *file)
 static const struct file_operations mpc5200_wdt_fops = {
 	.owner	= THIS_MODULE,
 	.write	= mpc5200_wdt_write,
-	.ioctl	= mpc5200_wdt_ioctl,
+	.unlocked_ioctl	= mpc5200_wdt_ioctl,
 	.open	= mpc5200_wdt_open,
 	.release = mpc5200_wdt_release,
 };
 
 /* module operations */
-static int mpc5200_wdt_probe(struct of_device *op, const struct of_device_id *match)
+static int mpc5200_wdt_probe(struct of_device *op,
+					const struct of_device_id *match)
 {
 	struct mpc5200_wdt *wdt;
 	int err;
@@ -215,9 +219,9 @@ static int mpc5200_wdt_probe(struct of_device *op, const struct of_device_id *ma
 		return 0;
 
 	iounmap(wdt->regs);
- out_release:
+out_release:
 	release_mem_region(wdt->mem.start, size);
- out_free:
+out_free:
 	kfree(wdt);
 	return err;
 }
diff --git a/drivers/watchdog/mpc83xx_wdt.c b/drivers/watchdog/mpc83xx_wdt.c
deleted file mode 100644
index b16c5cd..0000000
--- a/drivers/watchdog/mpc83xx_wdt.c
+++ /dev/null
@@ -1,230 +0,0 @@
-/*
- * mpc83xx_wdt.c - MPC83xx watchdog userspace interface
- *
- * Authors: Dave Updegraff <dave@cray.org>
- * 	    Kumar Gala <galak@kernel.crashing.org>
- * 		Attribution: from 83xx_wst: Florian Schirmer <jolt@tuxbox.org>
- * 				..and from sc520_wdt
- *
- * Note: it appears that you can only actually ENABLE or DISABLE the thing
- * once after POR. Once enabled, you cannot disable, and vice versa.
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/miscdevice.h>
-#include <linux/platform_device.h>
-#include <linux/module.h>
-#include <linux/watchdog.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-
-struct mpc83xx_wdt {
-	__be32 res0;
-	__be32 swcrr; /* System watchdog control register */
-#define SWCRR_SWTC 0xFFFF0000 /* Software Watchdog Time Count. */
-#define SWCRR_SWEN 0x00000004 /* Watchdog Enable bit. */
-#define SWCRR_SWRI 0x00000002 /* Software Watchdog Reset/Interrupt Select bit.*/
-#define SWCRR_SWPR 0x00000001 /* Software Watchdog Counter Prescale bit. */
-	__be32 swcnr; /* System watchdog count register */
-	u8 res1[2];
-	__be16 swsrr; /* System watchdog service register */
-	u8 res2[0xF0];
-};
-
-static struct mpc83xx_wdt __iomem *wd_base;
-
-static u16 timeout = 0xffff;
-module_param(timeout, ushort, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in ticks. (0<timeout<65536, default=65535");
-
-static int reset = 1;
-module_param(reset, bool, 0);
-MODULE_PARM_DESC(reset, "Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
-
-/*
- * We always prescale, but if someone really doesn't want to they can set this
- * to 0
- */
-static int prescale = 1;
-static unsigned int timeout_sec;
-
-static unsigned long wdt_is_open;
-static DEFINE_SPINLOCK(wdt_spinlock);
-
-static void mpc83xx_wdt_keepalive(void)
-{
-	/* Ping the WDT */
-	spin_lock(&wdt_spinlock);
-	out_be16(&wd_base->swsrr, 0x556c);
-	out_be16(&wd_base->swsrr, 0xaa39);
-	spin_unlock(&wdt_spinlock);
-}
-
-static ssize_t mpc83xx_wdt_write(struct file *file, const char __user *buf,
-				 size_t count, loff_t *ppos)
-{
-	if (count)
-		mpc83xx_wdt_keepalive();
-	return count;
-}
-
-static int mpc83xx_wdt_open(struct inode *inode, struct file *file)
-{
-	u32 tmp = SWCRR_SWEN;
-	if (test_and_set_bit(0, &wdt_is_open))
-		return -EBUSY;
-
-	/* Once we start the watchdog we can't stop it */
-	__module_get(THIS_MODULE);
-
-	/* Good, fire up the show */
-	if (prescale)
-		tmp |= SWCRR_SWPR;
-	if (reset)
-		tmp |= SWCRR_SWRI;
-
-	tmp |= timeout << 16;
-
-	out_be32(&wd_base->swcrr, tmp);
-
-	return nonseekable_open(inode, file);
-}
-
-static int mpc83xx_wdt_release(struct inode *inode, struct file *file)
-{
-	printk(KERN_CRIT "Unexpected close, not stopping watchdog!\n");
-	mpc83xx_wdt_keepalive();
-	clear_bit(0, &wdt_is_open);
-	return 0;
-}
-
-static int mpc83xx_wdt_ioctl(struct inode *inode, struct file *file,
-				unsigned int cmd, unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING,
-		.firmware_version = 1,
-		.identity = "MPC83xx",
-	};
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_KEEPALIVE:
-		mpc83xx_wdt_keepalive();
-		return 0;
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout_sec, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-static const struct file_operations mpc83xx_wdt_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= mpc83xx_wdt_write,
-	.ioctl		= mpc83xx_wdt_ioctl,
-	.open		= mpc83xx_wdt_open,
-	.release	= mpc83xx_wdt_release,
-};
-
-static struct miscdevice mpc83xx_wdt_miscdev = {
-	.minor	= WATCHDOG_MINOR,
-	.name	= "watchdog",
-	.fops	= &mpc83xx_wdt_fops,
-};
-
-static int __devinit mpc83xx_wdt_probe(struct platform_device *dev)
-{
-	struct resource *r;
-	int ret;
-	unsigned int *freq = dev->dev.platform_data;
-
-	/* get a pointer to the register memory */
-	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
-
-	if (!r) {
-		ret = -ENODEV;
-		goto err_out;
-	}
-
-	wd_base = ioremap(r->start, sizeof (struct mpc83xx_wdt));
-
-	if (wd_base == NULL) {
-		ret = -ENOMEM;
-		goto err_out;
-	}
-
-	ret = misc_register(&mpc83xx_wdt_miscdev);
-	if (ret) {
-		printk(KERN_ERR "cannot register miscdev on minor=%d "
-				"(err=%d)\n",
-				WATCHDOG_MINOR, ret);
-		goto err_unmap;
-	}
-
-	/* Calculate the timeout in seconds */
-	if (prescale)
-		timeout_sec = (timeout * 0x10000) / (*freq);
-	else
-		timeout_sec = timeout / (*freq);
-
-	printk(KERN_INFO "WDT driver for MPC83xx initialized. "
-		"mode:%s timeout=%d (%d seconds)\n",
-		reset ? "reset":"interrupt", timeout, timeout_sec);
-	return 0;
-
-err_unmap:
-	iounmap(wd_base);
-err_out:
-	return ret;
-}
-
-static int __devexit mpc83xx_wdt_remove(struct platform_device *dev)
-{
-	misc_deregister(&mpc83xx_wdt_miscdev);
-	iounmap(wd_base);
-
-	return 0;
-}
-
-static struct platform_driver mpc83xx_wdt_driver = {
-	.probe		= mpc83xx_wdt_probe,
-	.remove		= __devexit_p(mpc83xx_wdt_remove),
-	.driver		= {
-		.name	= "mpc83xx_wdt",
-		.owner	= THIS_MODULE,
-	},
-};
-
-static int __init mpc83xx_wdt_init(void)
-{
-	return platform_driver_register(&mpc83xx_wdt_driver);
-}
-
-static void __exit mpc83xx_wdt_exit(void)
-{
-	platform_driver_unregister(&mpc83xx_wdt_driver);
-}
-
-module_init(mpc83xx_wdt_init);
-module_exit(mpc83xx_wdt_exit);
-
-MODULE_AUTHOR("Dave Updegraff, Kumar Gala");
-MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx uProcessor");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS("platform:mpc83xx_wdt");
diff --git a/drivers/watchdog/mpc8xx_wdt.c b/drivers/watchdog/mpc8xx_wdt.c
index 85b5734..1336425 100644
--- a/drivers/watchdog/mpc8xx_wdt.c
+++ b/drivers/watchdog/mpc8xx_wdt.c
@@ -16,36 +16,35 @@
 #include <linux/module.h>
 #include <linux/watchdog.h>
 #include <asm/8xx_immap.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 #include <syslib/m8xx_wdt.h>
 
 static unsigned long wdt_opened;
 static int wdt_status;
+static spinlock_t wdt_lock;
 
 static void mpc8xx_wdt_handler_disable(void)
 {
 	volatile uint __iomem *piscr;
-	piscr = (uint *)&((immap_t*)IMAP_ADDR)->im_sit.sit_piscr;
+	piscr = (uint *)&((immap_t *)IMAP_ADDR)->im_sit.sit_piscr;
 
 	if (!m8xx_has_internal_rtc)
 		m8xx_wdt_stop_timer();
 	else
 		out_be32(piscr, in_be32(piscr) & ~(PISCR_PIE | PISCR_PTE));
-
 	printk(KERN_NOTICE "mpc8xx_wdt: keep-alive handler deactivated\n");
 }
 
 static void mpc8xx_wdt_handler_enable(void)
 {
 	volatile uint __iomem *piscr;
-	piscr = (uint *)&((immap_t*)IMAP_ADDR)->im_sit.sit_piscr;
+	piscr = (uint *)&((immap_t *)IMAP_ADDR)->im_sit.sit_piscr;
 
 	if (!m8xx_has_internal_rtc)
 		m8xx_wdt_install_timer();
 	else
 		out_be32(piscr, in_be32(piscr) | PISCR_PIE | PISCR_PTE);
-
 	printk(KERN_NOTICE "mpc8xx_wdt: keep-alive handler activated\n");
 }
 
@@ -53,37 +52,34 @@ static int mpc8xx_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &wdt_opened))
 		return -EBUSY;
-
 	m8xx_wdt_reset();
 	mpc8xx_wdt_handler_disable();
-
 	return nonseekable_open(inode, file);
 }
 
 static int mpc8xx_wdt_release(struct inode *inode, struct file *file)
 {
 	m8xx_wdt_reset();
-
 #if !defined(CONFIG_WATCHDOG_NOWAYOUT)
 	mpc8xx_wdt_handler_enable();
 #endif
-
 	clear_bit(0, &wdt_opened);
-
 	return 0;
 }
 
-static ssize_t mpc8xx_wdt_write(struct file *file, const char *data, size_t len,
-				loff_t * ppos)
+static ssize_t mpc8xx_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
-	if (len)
+	if (len) {
+		spin_lock(&wdt_lock);
 		m8xx_wdt_reset();
-
+		spin_unlock(&wdt_lock);
+	}
 	return len;
 }
 
-static int mpc8xx_wdt_ioctl(struct inode *inode, struct file *file,
-			    unsigned int cmd, unsigned long arg)
+static long mpc8xx_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int timeout;
 	static struct watchdog_info info = {
@@ -112,15 +108,19 @@ static int mpc8xx_wdt_ioctl(struct inode *inode, struct file *file,
 		return -EOPNOTSUPP;
 
 	case WDIOC_KEEPALIVE:
+		spin_lock(&wdt_lock);
 		m8xx_wdt_reset();
 		wdt_status |= WDIOF_KEEPALIVEPING;
+		spin_unlock(&wdt_lock);
 		break;
 
 	case WDIOC_SETTIMEOUT:
 		return -EOPNOTSUPP;
 
 	case WDIOC_GETTIMEOUT:
+		spin_lock(&wdt_lock);
 		timeout = m8xx_wdt_get_timeout();
+		spin_unlock(&wdt_lock);
 		if (put_user(timeout, (int *)arg))
 			return -EFAULT;
 		break;
@@ -136,7 +136,7 @@ static const struct file_operations mpc8xx_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = mpc8xx_wdt_write,
-	.ioctl = mpc8xx_wdt_ioctl,
+	.unlocked_ioctl = mpc8xx_wdt_ioctl,
 	.open = mpc8xx_wdt_open,
 	.release = mpc8xx_wdt_release,
 };
@@ -149,6 +149,7 @@ static struct miscdevice mpc8xx_wdt_miscdev = {
 
 static int __init mpc8xx_wdt_init(void)
 {
+	spin_lock_init(&wdt_lock);
 	return misc_register(&mpc8xx_wdt_miscdev);
 }
 
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
new file mode 100644
index 0000000..f209496
--- /dev/null
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -0,0 +1,316 @@
+/*
+ * mpc8xxx_wdt.c - MPC8xx/MPC83xx/MPC86xx watchdog userspace interface
+ *
+ * Authors: Dave Updegraff <dave@cray.org>
+ * 	    Kumar Gala <galak@kernel.crashing.org>
+ * 		Attribution: from 83xx_wst: Florian Schirmer <jolt@tuxbox.org>
+ * 				..and from sc520_wdt
+ * Copyright (c) 2008  MontaVista Software, Inc.
+ *                     Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * Note: it appears that you can only actually ENABLE or DISABLE the thing
+ * once after POR. Once enabled, you cannot disable, and vice versa.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/timer.h>
+#include <linux/miscdevice.h>
+#include <linux/of_platform.h>
+#include <linux/module.h>
+#include <linux/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <sysdev/fsl_soc.h>
+
+struct mpc8xxx_wdt {
+	__be32 res0;
+	__be32 swcrr; /* System watchdog control register */
+#define SWCRR_SWTC 0xFFFF0000 /* Software Watchdog Time Count. */
+#define SWCRR_SWEN 0x00000004 /* Watchdog Enable bit. */
+#define SWCRR_SWRI 0x00000002 /* Software Watchdog Reset/Interrupt Select bit.*/
+#define SWCRR_SWPR 0x00000001 /* Software Watchdog Counter Prescale bit. */
+	__be32 swcnr; /* System watchdog count register */
+	u8 res1[2];
+	__be16 swsrr; /* System watchdog service register */
+	u8 res2[0xF0];
+};
+
+struct mpc8xxx_wdt_type {
+	int prescaler;
+	bool hw_enabled;
+};
+
+static struct mpc8xxx_wdt __iomem *wd_base;
+
+static u16 timeout = 0xffff;
+module_param(timeout, ushort, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in ticks. (0<timeout<65536, default=65535");
+
+static int reset = 1;
+module_param(reset, bool, 0);
+MODULE_PARM_DESC(reset,
+	"Watchdog Interrupt/Reset Mode. 0 = interrupt, 1 = reset");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+		 "(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+/*
+ * We always prescale, but if someone really doesn't want to they can set this
+ * to 0
+ */
+static int prescale = 1;
+static unsigned int timeout_sec;
+
+static unsigned long wdt_is_open;
+static DEFINE_SPINLOCK(wdt_spinlock);
+
+static void mpc8xxx_wdt_keepalive(void)
+{
+	/* Ping the WDT */
+	spin_lock(&wdt_spinlock);
+	out_be16(&wd_base->swsrr, 0x556c);
+	out_be16(&wd_base->swsrr, 0xaa39);
+	spin_unlock(&wdt_spinlock);
+}
+
+static void mpc8xxx_wdt_timer_ping(unsigned long arg);
+static DEFINE_TIMER(wdt_timer, mpc8xxx_wdt_timer_ping, 0, 0);
+
+static void mpc8xxx_wdt_timer_ping(unsigned long arg)
+{
+	mpc8xxx_wdt_keepalive();
+	/* We're pinging it twice faster than needed, just to be sure. */
+	mod_timer(&wdt_timer, jiffies + HZ * timeout_sec / 2);
+}
+
+static void mpc8xxx_wdt_pr_warn(const char *msg)
+{
+	pr_crit("mpc8xxx_wdt: %s, expect the %s soon!\n", msg,
+		reset ? "reset" : "machine check exception");
+}
+
+static ssize_t mpc8xxx_wdt_write(struct file *file, const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	if (count)
+		mpc8xxx_wdt_keepalive();
+	return count;
+}
+
+static int mpc8xxx_wdt_open(struct inode *inode, struct file *file)
+{
+	u32 tmp = SWCRR_SWEN;
+	if (test_and_set_bit(0, &wdt_is_open))
+		return -EBUSY;
+
+	/* Once we start the watchdog we can't stop it */
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	/* Good, fire up the show */
+	if (prescale)
+		tmp |= SWCRR_SWPR;
+	if (reset)
+		tmp |= SWCRR_SWRI;
+
+	tmp |= timeout << 16;
+
+	out_be32(&wd_base->swcrr, tmp);
+
+	del_timer_sync(&wdt_timer);
+
+	return nonseekable_open(inode, file);
+}
+
+static int mpc8xxx_wdt_release(struct inode *inode, struct file *file)
+{
+	if (!nowayout)
+		mpc8xxx_wdt_timer_ping(0);
+	else
+		mpc8xxx_wdt_pr_warn("watchdog closed");
+	clear_bit(0, &wdt_is_open);
+	return 0;
+}
+
+static long mpc8xxx_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	static struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING,
+		.firmware_version = 1,
+		.identity = "MPC8xxx",
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		mpc8xxx_wdt_keepalive();
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout_sec, p);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static const struct file_operations mpc8xxx_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= mpc8xxx_wdt_write,
+	.unlocked_ioctl	= mpc8xxx_wdt_ioctl,
+	.open		= mpc8xxx_wdt_open,
+	.release	= mpc8xxx_wdt_release,
+};
+
+static struct miscdevice mpc8xxx_wdt_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &mpc8xxx_wdt_fops,
+};
+
+static int __devinit mpc8xxx_wdt_probe(struct of_device *ofdev,
+				       const struct of_device_id *match)
+{
+	int ret;
+	struct device_node *np = ofdev->node;
+	struct mpc8xxx_wdt_type *wdt_type = match->data;
+	u32 freq = fsl_get_sys_freq();
+	bool enabled;
+
+	if (!freq || freq == -1)
+		return -EINVAL;
+
+	wd_base = of_iomap(np, 0);
+	if (!wd_base)
+		return -ENOMEM;
+
+	enabled = in_be32(&wd_base->swcrr) & SWCRR_SWEN;
+	if (!enabled && wdt_type->hw_enabled) {
+		pr_info("mpc8xxx_wdt: could not be enabled in software\n");
+		ret = -ENOSYS;
+		goto err_unmap;
+	}
+
+	/* Calculate the timeout in seconds */
+	if (prescale)
+		timeout_sec = (timeout * wdt_type->prescaler) / freq;
+	else
+		timeout_sec = timeout / freq;
+
+	pr_info("WDT driver for MPC8xxx initialized. mode:%s timeout=%d "
+		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
+		timeout_sec);
+
+	/*
+	 * If the watchdog was previously enabled or we're running on
+	 * MPC8xxx, we should ping the wdt from the kernel until the
+	 * userspace handles it.
+	 */
+	if (enabled)
+		mpc8xxx_wdt_timer_ping(0);
+	return 0;
+err_unmap:
+	iounmap(wd_base);
+	wd_base = NULL;
+	return ret;
+}
+
+static int __devexit mpc8xxx_wdt_remove(struct of_device *ofdev)
+{
+	mpc8xxx_wdt_pr_warn("watchdog removed");
+	del_timer_sync(&wdt_timer);
+	misc_deregister(&mpc8xxx_wdt_miscdev);
+	iounmap(wd_base);
+
+	return 0;
+}
+
+static const struct of_device_id mpc8xxx_wdt_match[] = {
+	{
+		.compatible = "mpc83xx_wdt",
+		.data = &(struct mpc8xxx_wdt_type) {
+			.prescaler = 0x10000,
+		},
+	},
+	{
+		.compatible = "fsl,mpc8610-wdt",
+		.data = &(struct mpc8xxx_wdt_type) {
+			.prescaler = 0x10000,
+			.hw_enabled = true,
+		},
+	},
+	{
+		.compatible = "fsl,mpc823-wdt",
+		.data = &(struct mpc8xxx_wdt_type) {
+			.prescaler = 0x800,
+		},
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, mpc8xxx_wdt_match);
+
+static struct of_platform_driver mpc8xxx_wdt_driver = {
+	.match_table	= mpc8xxx_wdt_match,
+	.probe		= mpc8xxx_wdt_probe,
+	.remove		= __devexit_p(mpc8xxx_wdt_remove),
+	.driver		= {
+		.name	= "mpc8xxx_wdt",
+		.owner	= THIS_MODULE,
+	},
+};
+
+/*
+ * We do wdt initialization in two steps: arch_initcall probes the wdt
+ * very early to start pinging the watchdog (misc devices are not yet
+ * available), and later module_init() just registers the misc device.
+ */
+static int __init mpc8xxx_wdt_init_late(void)
+{
+	int ret;
+
+	if (!wd_base)
+		return -ENODEV;
+
+	ret = misc_register(&mpc8xxx_wdt_miscdev);
+	if (ret) {
+		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
+			WATCHDOG_MINOR, ret);
+		return ret;
+	}
+	return 0;
+}
+module_init(mpc8xxx_wdt_init_late);
+
+static int __init mpc8xxx_wdt_init(void)
+{
+	return of_register_platform_driver(&mpc8xxx_wdt_driver);
+}
+arch_initcall(mpc8xxx_wdt_init);
+
+static void __exit mpc8xxx_wdt_exit(void)
+{
+	of_unregister_platform_driver(&mpc8xxx_wdt_driver);
+}
+module_exit(mpc8xxx_wdt_exit);
+
+MODULE_AUTHOR("Dave Updegraff, Kumar Gala");
+MODULE_DESCRIPTION("Driver for watchdog timer in MPC8xx/MPC83xx/MPC86xx "
+		   "uProcessors");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 009573b..2a9bfa8 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -29,9 +29,9 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/uaccess.h>
 
 #include <asm/hardware/arm_twd.h>
-#include <asm/uaccess.h>
 
 struct mpcore_wdt {
 	unsigned long	timer_alive;
@@ -43,17 +43,20 @@ struct mpcore_wdt {
 };
 
 static struct platform_device *mpcore_wdt_dev;
-
 extern unsigned int mpcore_timer_rate;
 
 #define TIMER_MARGIN	60
 static int mpcore_margin = TIMER_MARGIN;
 module_param(mpcore_margin, int, 0);
-MODULE_PARM_DESC(mpcore_margin, "MPcore timer margin in seconds. (0<mpcore_margin<65536, default=" __MODULE_STRING(TIMER_MARGIN) ")");
+MODULE_PARM_DESC(mpcore_margin,
+	"MPcore timer margin in seconds. (0 < mpcore_margin < 65536, default="
+				__MODULE_STRING(TIMER_MARGIN) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #define ONLY_TESTING	0
 static int mpcore_noboot = ONLY_TESTING;
@@ -70,14 +73,12 @@ static irqreturn_t mpcore_wdt_fire(int irq, void *arg)
 
 	/* Check it really was our interrupt */
 	if (readl(wdt->base + TWD_WDOG_INTSTAT)) {
-		dev_printk(KERN_CRIT, wdt->dev, "Triggered - Reboot ignored.\n");
-
+		dev_printk(KERN_CRIT, wdt->dev,
+					"Triggered - Reboot ignored.\n");
 		/* Clear the interrupt on the watchdog */
 		writel(1, wdt->base + TWD_WDOG_INTSTAT);
-
 		return IRQ_HANDLED;
 	}
-
 	return IRQ_NONE;
 }
 
@@ -96,22 +97,26 @@ static void mpcore_wdt_keepalive(struct mpcore_wdt *wdt)
 	count = (mpcore_timer_rate / 256) * mpcore_margin;
 
 	/* Reload the counter */
+	spin_lock(&wdt_lock);
 	writel(count + wdt->perturb, wdt->base + TWD_WDOG_LOAD);
-
 	wdt->perturb = wdt->perturb ? 0 : 1;
+	spin_unlock(&wdt_lock);
 }
 
 static void mpcore_wdt_stop(struct mpcore_wdt *wdt)
 {
+	spin_lock(&wdt_lock);
 	writel(0x12345678, wdt->base + TWD_WDOG_DISABLE);
 	writel(0x87654321, wdt->base + TWD_WDOG_DISABLE);
 	writel(0x0, wdt->base + TWD_WDOG_CONTROL);
+	spin_unlock(&wdt_lock);
 }
 
 static void mpcore_wdt_start(struct mpcore_wdt *wdt)
 {
 	dev_printk(KERN_INFO, wdt->dev, "enabling watchdog.\n");
 
+	spin_lock(&wdt_lock);
 	/* This loads the count register but does NOT start the count yet */
 	mpcore_wdt_keepalive(wdt);
 
@@ -122,6 +127,7 @@ static void mpcore_wdt_start(struct mpcore_wdt *wdt)
 		/* Enable watchdog - prescale=256, watchdog mode=1, enable=1 */
 		writel(0x0000FF09, wdt->base + TWD_WDOG_CONTROL);
 	}
+	spin_unlock(&wdt_lock);
 }
 
 static int mpcore_wdt_set_heartbeat(int t)
@@ -164,10 +170,11 @@ static int mpcore_wdt_release(struct inode *inode, struct file *file)
 	 *	Shut off the timer.
 	 * 	Lock it in if it's a module and we set nowayout
 	 */
-	if (wdt->expect_close == 42) {
+	if (wdt->expect_close == 42)
 		mpcore_wdt_stop(wdt);
-	} else {
-		dev_printk(KERN_CRIT, wdt->dev, "unexpected close, not stopping watchdog!\n");
+	else {
+		dev_printk(KERN_CRIT, wdt->dev,
+				"unexpected close, not stopping watchdog!\n");
 		mpcore_wdt_keepalive(wdt);
 	}
 	clear_bit(0, &wdt->timer_alive);
@@ -175,7 +182,8 @@ static int mpcore_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t mpcore_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t mpcore_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	struct mpcore_wdt *wdt = file->private_data;
 
@@ -210,8 +218,8 @@ static struct watchdog_info ident = {
 	.identity		= "MPcore Watchdog",
 };
 
-static int mpcore_wdt_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long mpcore_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct mpcore_wdt *wdt = file->private_data;
 	int ret;
@@ -235,6 +243,12 @@ static int mpcore_wdt_ioctl(struct inode *inode, struct file *file,
 		ret = 0;
 		break;
 
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		uarg.i = 0;
+		ret = 0;
+		break;
+
 	case WDIOC_SETOPTIONS:
 		ret = -EINVAL;
 		if (uarg.i & WDIOS_DISABLECARD) {
@@ -247,12 +261,6 @@ static int mpcore_wdt_ioctl(struct inode *inode, struct file *file,
 		}
 		break;
 
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		uarg.i = 0;
-		ret = 0;
-		break;
-
 	case WDIOC_KEEPALIVE:
 		mpcore_wdt_keepalive(wdt);
 		ret = 0;
@@ -301,7 +309,7 @@ static const struct file_operations mpcore_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= mpcore_wdt_write,
-	.ioctl		= mpcore_wdt_ioctl,
+	.unlocked_ioctl	= mpcore_wdt_ioctl,
 	.open		= mpcore_wdt_open,
 	.release	= mpcore_wdt_release,
 };
@@ -349,14 +357,17 @@ static int __devinit mpcore_wdt_probe(struct platform_device *dev)
 	mpcore_wdt_miscdev.parent = &dev->dev;
 	ret = misc_register(&mpcore_wdt_miscdev);
 	if (ret) {
-		dev_printk(KERN_ERR, _dev, "cannot register miscdev on minor=%d (err=%d)\n",
-			   WATCHDOG_MINOR, ret);
+		dev_printk(KERN_ERR, _dev,
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto err_misc;
 	}
 
-	ret = request_irq(wdt->irq, mpcore_wdt_fire, IRQF_DISABLED, "mpcore_wdt", wdt);
+	ret = request_irq(wdt->irq, mpcore_wdt_fire, IRQF_DISABLED,
+							"mpcore_wdt", wdt);
 	if (ret) {
-		dev_printk(KERN_ERR, _dev, "cannot register IRQ%d for watchdog\n", wdt->irq);
+		dev_printk(KERN_ERR, _dev,
+			"cannot register IRQ%d for watchdog\n", wdt->irq);
 		goto err_irq;
 	}
 
@@ -366,13 +377,13 @@ static int __devinit mpcore_wdt_probe(struct platform_device *dev)
 
 	return 0;
 
- err_irq:
+err_irq:
 	misc_deregister(&mpcore_wdt_miscdev);
- err_misc:
+err_misc:
 	iounmap(wdt->base);
- err_free:
+err_free:
 	kfree(wdt);
- err_out:
+err_out:
 	return ret;
 }
 
@@ -415,7 +426,7 @@ static int __init mpcore_wdt_init(void)
 	 */
 	if (mpcore_wdt_set_heartbeat(mpcore_margin)) {
 		mpcore_wdt_set_heartbeat(TIMER_MARGIN);
-		printk(KERN_INFO "mpcore_margin value must be 0<mpcore_margin<65536, using %d\n",
+		printk(KERN_INFO "mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
 
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index a8e6738..b4b7b0a 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -1,7 +1,8 @@
 /*
  *      Driver for the MTX-1 Watchdog.
  *
- *      (C) Copyright 2005 4G Systems <info@4g-systems.biz>, All Rights Reserved.
+ *      (C) Copyright 2005 4G Systems <info@4g-systems.biz>,
+ *							All Rights Reserved.
  *                              http://www.4g-systems.biz
  *
  * 	(C) Copyright 2007 OpenWrt.org, Florian Fainelli <florian@openwrt.org>
@@ -46,12 +47,11 @@
 #include <linux/jiffies.h>
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/gpio.h>
 
 #include <asm/mach-au1x00/au1000.h>
-#include <asm/gpio.h>
 
 #define MTX1_WDT_INTERVAL	(5 * HZ)
 
@@ -59,6 +59,7 @@ static int ticks = 100 * HZ;
 
 static struct {
 	struct completion stop;
+	spinlock_t lock;
 	int running;
 	struct timer_list timer;
 	int queue;
@@ -71,6 +72,7 @@ static void mtx1_wdt_trigger(unsigned long unused)
 {
 	u32 tmp;
 
+	spin_lock(&mtx1_wdt_device.lock);
 	if (mtx1_wdt_device.running)
 		ticks--;
 	/*
@@ -79,13 +81,13 @@ static void mtx1_wdt_trigger(unsigned long unused)
 	tmp = au_readl(GPIO2_DIR);
 	tmp = (tmp & ~(1 << mtx1_wdt_device.gpio)) |
 	      ((~tmp) & (1 << mtx1_wdt_device.gpio));
-	au_writel (tmp, GPIO2_DIR);
+	au_writel(tmp, GPIO2_DIR);
 
 	if (mtx1_wdt_device.queue && ticks)
 		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
-	else {
+	else
 		complete(&mtx1_wdt_device.stop);
-	}
+	spin_unlock(&mtx1_wdt_device.lock);
 }
 
 static void mtx1_wdt_reset(void)
@@ -96,23 +98,25 @@ static void mtx1_wdt_reset(void)
 
 static void mtx1_wdt_start(void)
 {
+	spin_lock_irqsave(&mtx1_wdt_device.lock, flags);
 	if (!mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 1;
 		gpio_set_value(mtx1_wdt_device.gpio, 1);
 		mod_timer(&mtx1_wdt_device.timer, jiffies + MTX1_WDT_INTERVAL);
 	}
 	mtx1_wdt_device.running++;
+	spin_unlock_irqrestore(&mtx1_wdt_device.lock, flags);
 }
 
 static int mtx1_wdt_stop(void)
 {
+	spin_lock_irqsave(&mtx1_wdt_device.lock, flags);
 	if (mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 0;
 		gpio_set_value(mtx1_wdt_device.gpio, 0);
 	}
-
 	ticks = mtx1_wdt_device.default_ticks;
-
+	spin_unlock_irqrestore(&mtx1_wdt_device.lock, flags);
 	return 0;
 }
 
@@ -122,7 +126,6 @@ static int mtx1_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &mtx1_wdt_device.inuse))
 		return -EBUSY;
-
 	return nonseekable_open(inode, file);
 }
 
@@ -133,54 +136,51 @@ static int mtx1_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int mtx1_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long mtx1_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
+	int __user *p = (int __user *)argp;
 	unsigned int value;
-	static struct watchdog_info ident =
-	{
+	static const struct watchdog_info ident = {
 		.options = WDIOF_CARDRESET,
 		.identity = "MTX-1 WDT",
 	};
 
-	switch(cmd) {
-		case WDIOC_KEEPALIVE:
-			mtx1_wdt_reset();
-			break;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			if ( copy_to_user(argp, &value, sizeof(int)) )
-				return -EFAULT;
-			break;
-		case WDIOC_GETSUPPORT:
-			if ( copy_to_user(argp, &ident, sizeof(ident)) )
-				return -EFAULT;
-			break;
-		case WDIOC_SETOPTIONS:
-			if ( copy_from_user(&value, argp, sizeof(int)) )
-				return -EFAULT;
-			switch(value) {
-				case WDIOS_ENABLECARD:
-					mtx1_wdt_start();
-					break;
-				case WDIOS_DISABLECARD:
-					return mtx1_wdt_stop();
-				default:
-					return -EINVAL;
-			}
-			break;
-		default:
-			return -ENOTTY;
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		put_user(0, p);
+		break;
+	case WDIOC_SETOPTIONS:
+		if (get_user(value, p))
+			return -EFAULT;
+		if (value & WDIOS_ENABLECARD)
+			mtx1_wdt_start();
+		else if (value & WDIOS_DISABLECARD)
+			mtx1_wdt_stop();
+		else
+			return -EINVAL;
+		return 0;
+	case WDIOC_KEEPALIVE:
+		mtx1_wdt_reset();
+		break;
+	default:
+		return -ENOTTY;
 	}
 	return 0;
 }
 
 
-static ssize_t mtx1_wdt_write(struct file *file, const char *buf, size_t count, loff_t *ppos)
+static ssize_t mtx1_wdt_write(struct file *file, const char *buf,
+						size_t count, loff_t *ppos)
 {
 	if (!count)
 		return -EIO;
-
 	mtx1_wdt_reset();
 	return count;
 }
@@ -188,17 +188,17 @@ static ssize_t mtx1_wdt_write(struct file *file, const char *buf, size_t count,
 static const struct file_operations mtx1_wdt_fops = {
 	.owner 		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= mtx1_wdt_ioctl,
+	.unlocked_ioctl	= mtx1_wdt_ioctl,
 	.open 		= mtx1_wdt_open,
 	.write 		= mtx1_wdt_write,
-	.release 	= mtx1_wdt_release
+	.release 	= mtx1_wdt_release,
 };
 
 
 static struct miscdevice mtx1_wdt_misc = {
 	.minor 	= WATCHDOG_MINOR,
 	.name 	= "watchdog",
-	.fops 	= &mtx1_wdt_fops
+	.fops 	= &mtx1_wdt_fops,
 };
 
 
@@ -208,29 +208,26 @@ static int mtx1_wdt_probe(struct platform_device *pdev)
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
 
-	if ((ret = misc_register(&mtx1_wdt_misc)) < 0) {
-		printk(KERN_ERR " mtx-1_wdt : failed to register\n");
-		return ret;
-	}
-
+	spin_lock_init(&mtx1_wdt_device.lock);
 	init_completion(&mtx1_wdt_device.stop);
 	mtx1_wdt_device.queue = 0;
-
 	clear_bit(0, &mtx1_wdt_device.inuse);
-
 	setup_timer(&mtx1_wdt_device.timer, mtx1_wdt_trigger, 0L);
-
 	mtx1_wdt_device.default_ticks = ticks;
 
+	ret = misc_register(&mtx1_wdt_misc);
+	if (ret < 0) {
+		printk(KERN_ERR " mtx-1_wdt : failed to register\n");
+		return ret;
+	}
 	mtx1_wdt_start();
-
 	printk(KERN_INFO "MTX-1 Watchdog driver\n");
-
 	return 0;
 }
 
 static int mtx1_wdt_remove(struct platform_device *pdev)
 {
+	/* FIXME: do we need to lock this test ? */
 	if (mtx1_wdt_device.queue) {
 		mtx1_wdt_device.queue = 0;
 		wait_for_completion(&mtx1_wdt_device.stop);
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index b59ca32..acf589d 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -8,7 +8,7 @@
  * and services the watchdog.
  *
  * Derived from mpc8xx_wdt.c, with the following copyright.
- * 
+ *
  * 2002 (c) Florian Schirmer <jolt@tuxbox.org> This file is licensed under
  * the terms of the GNU General Public License version 2. This program
  * is licensed "as is" without any warranty of any kind, whether express
@@ -22,10 +22,9 @@
 #include <linux/module.h>
 #include <linux/watchdog.h>
 #include <linux/platform_device.h>
-
 #include <linux/mv643xx.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define MV64x60_WDT_WDC_OFFSET	0
 
@@ -61,7 +60,9 @@ static DEFINE_SPINLOCK(mv64x60_wdt_spinlock);
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static int mv64x60_wdt_toggle_wdc(int enabled_predicate, int field_shift)
 {
@@ -150,7 +151,7 @@ static int mv64x60_wdt_release(struct inode *inode, struct file *file)
 }
 
 static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
-				 size_t len, loff_t * ppos)
+				 size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -160,7 +161,7 @@ static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
 
 			for (i = 0; i != len; i++) {
 				char c;
-				if(get_user(c, data + i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_close = 42;
@@ -172,8 +173,8 @@ static ssize_t mv64x60_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int mv64x60_wdt_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long mv64x60_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int timeout;
 	int options;
@@ -240,7 +241,7 @@ static const struct file_operations mv64x60_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = mv64x60_wdt_write,
-	.ioctl = mv64x60_wdt_ioctl,
+	.unlocked_ioctl = mv64x60_wdt_ioctl,
 	.open = mv64x60_wdt_open,
 	.release = mv64x60_wdt_release,
 };
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 74bc39a..6f5420f 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -40,10 +40,9 @@
 #include <linux/moduleparam.h>
 #include <linux/clk.h>
 #include <linux/bitops.h>
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/hardware.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/hardware.h>
 
 #include <asm/arch/prcm.h>
 
@@ -54,11 +53,12 @@ module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
 static int omap_wdt_users;
-static struct clk *armwdt_ck = NULL;
-static struct clk *mpu_wdt_ick = NULL;
-static struct clk *mpu_wdt_fck = NULL;
+static struct clk *armwdt_ck;
+static struct clk *mpu_wdt_ick;
+static struct clk *mpu_wdt_fck;
 
 static unsigned int wdt_trgr_pattern = 0x1234;
+static spinlock_t wdt_lock;
 
 static void omap_wdt_ping(void)
 {
@@ -174,30 +174,29 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t
-omap_wdt_write(struct file *file, const char __user *data,
+static ssize_t omap_wdt_write(struct file *file, const char __user *data,
 		size_t len, loff_t *ppos)
 {
 	/* Refresh LOAD_TIME. */
-	if (len)
+	if (len) {
+		spin_lock(&wdt_lock);
 		omap_wdt_ping();
+		spin_unlock(&wdt_lock);
+	}
 	return len;
 }
 
-static int
-omap_wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int new_margin;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.identity = "OMAP Watchdog",
 		.options = WDIOF_SETTIMEOUT,
 		.firmware_version = 0,
 	};
 
 	switch (cmd) {
-	default:
-		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
 		return copy_to_user((struct watchdog_info __user *)arg, &ident,
 				sizeof(ident));
@@ -211,28 +210,34 @@ omap_wdt_ioctl(struct inode *inode, struct file *file,
 			return put_user(omap_prcm_get_reset_sources(),
 					(int __user *)arg);
 	case WDIOC_KEEPALIVE:
+		spin_lock(&wdt_lock);
 		omap_wdt_ping();
+		spin_unlock(&wdt_lock);
 		return 0;
 	case WDIOC_SETTIMEOUT:
 		if (get_user(new_margin, (int __user *)arg))
 			return -EFAULT;
 		omap_wdt_adjust_timeout(new_margin);
 
+		spin_lock(&wdt_lock);
 		omap_wdt_disable();
 		omap_wdt_set_timeout();
 		omap_wdt_enable();
 
 		omap_wdt_ping();
+		spin_unlock(&wdt_lock);
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		return put_user(timer_margin, (int __user *)arg);
+	default:
+		return -ENOTTY;
 	}
 }
 
 static const struct file_operations omap_wdt_fops = {
 	.owner = THIS_MODULE,
 	.write = omap_wdt_write,
-	.ioctl = omap_wdt_ioctl,
+	.unlocked_ioctl = omap_wdt_ioctl,
 	.open = omap_wdt_open,
 	.release = omap_wdt_release,
 };
@@ -240,7 +245,7 @@ static const struct file_operations omap_wdt_fops = {
 static struct miscdevice omap_wdt_miscdev = {
 	.minor = WATCHDOG_MINOR,
 	.name = "watchdog",
-	.fops = &omap_wdt_fops
+	.fops = &omap_wdt_fops,
 };
 
 static int __init omap_wdt_probe(struct platform_device *pdev)
@@ -373,6 +378,7 @@ static struct platform_driver omap_wdt_driver = {
 
 static int __init omap_wdt_init(void)
 {
+	spin_lock_init(&wdt_lock);
 	return platform_driver_register(&omap_wdt_driver);
 }
 
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 15e4f88..e91ada7 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -31,14 +31,14 @@
 #include <linux/spinlock.h>
 #include <linux/moduleparam.h>
 #include <linux/version.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 /* #define DEBUG 1 */
 
-#define DEFAULT_TIMEOUT     1            /* 1 minute */
+#define DEFAULT_TIMEOUT     1		/* 1 minute */
 #define MAX_TIMEOUT         255
 
 #define VERSION             "1.1"
@@ -46,22 +46,22 @@
 #define PFX                 MODNAME ": "
 #define DPFX                MODNAME " - DEBUG: "
 
-#define WDT_INDEX_IO_PORT   (io+0)       /* I/O port base (index register) */
+#define WDT_INDEX_IO_PORT   (io+0)	/* I/O port base (index register) */
 #define WDT_DATA_IO_PORT    (WDT_INDEX_IO_PORT+1)
 #define SWC_LDN             0x04
-#define SIOCFG2             0x22         /* Serial IO register */
-#define WDCTL               0x10         /* Watchdog-Timer-Controll-Register */
-#define WDTO                0x11         /* Watchdog timeout register */
-#define WDCFG               0x12         /* Watchdog config register */
+#define SIOCFG2             0x22	/* Serial IO register */
+#define WDCTL               0x10	/* Watchdog-Timer-Controll-Register */
+#define WDTO                0x11	/* Watchdog timeout register */
+#define WDCFG               0x12	/* Watchdog config register */
 
-static int io = 0x2E;		         /* Address used on Portwell Boards */
+static int io = 0x2E;			/* Address used on Portwell Boards */
 
-static int timeout = DEFAULT_TIMEOUT;    /* timeout value */
-static unsigned long timer_enabled = 0;  /* is the timer enabled? */
+static int timeout = DEFAULT_TIMEOUT;	/* timeout value */
+static unsigned long timer_enabled;	/* is the timer enabled? */
 
-static char expect_close;                /* is the close expected? */
+static char expect_close;		/* is the close expected? */
 
-static DEFINE_SPINLOCK(io_lock);/* to guard the watchdog from io races */
+static DEFINE_SPINLOCK(io_lock);	/* to guard us from io races */
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 
@@ -69,7 +69,7 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 
 /* Select pins for Watchdog output */
 
-static inline void pc87413_select_wdt_out (void)
+static inline void pc87413_select_wdt_out(void)
 {
 	unsigned int cr_data = 0;
 
@@ -77,7 +77,7 @@ static inline void pc87413_select_wdt_out (void)
 
 	outb_p(SIOCFG2, WDT_INDEX_IO_PORT);
 
-	cr_data = inb (WDT_DATA_IO_PORT);
+	cr_data = inb(WDT_DATA_IO_PORT);
 
 	cr_data |= 0x80; /* Set Bit7 to 1*/
 	outb_p(SIOCFG2, WDT_INDEX_IO_PORT);
@@ -85,8 +85,9 @@ static inline void pc87413_select_wdt_out (void)
 	outb_p(cr_data, WDT_DATA_IO_PORT);
 
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Select multiple pin,pin55,as WDT output:"
-	                      " Bit7 to 1: %d\n", cr_data);
+	printk(KERN_INFO DPFX
+		"Select multiple pin,pin55,as WDT output: Bit7 to 1: %d\n",
+								cr_data);
 #endif
 }
 
@@ -94,18 +95,18 @@ static inline void pc87413_select_wdt_out (void)
 
 static inline void pc87413_enable_swc(void)
 {
-	unsigned int cr_data=0;
+	unsigned int cr_data = 0;
 
 	/* Step 2: Enable SWC functions */
 
-	outb_p(0x07, WDT_INDEX_IO_PORT);        /* Point SWC_LDN (LDN=4) */
+	outb_p(0x07, WDT_INDEX_IO_PORT);	/* Point SWC_LDN (LDN=4) */
 	outb_p(SWC_LDN, WDT_DATA_IO_PORT);
 
-	outb_p(0x30, WDT_INDEX_IO_PORT);        /* Read Index 0x30 First */
+	outb_p(0x30, WDT_INDEX_IO_PORT);	/* Read Index 0x30 First */
 	cr_data = inb(WDT_DATA_IO_PORT);
-	cr_data |= 0x01;                        /* Set Bit0 to 1 */
+	cr_data |= 0x01;			/* Set Bit0 to 1 */
 	outb_p(0x30, WDT_INDEX_IO_PORT);
-	outb_p(cr_data, WDT_DATA_IO_PORT);      /* Index0x30_bit0P1 */
+	outb_p(cr_data, WDT_DATA_IO_PORT);	/* Index0x30_bit0P1 */
 
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "pc87413 - Enable SWC functions\n");
@@ -121,20 +122,19 @@ static inline unsigned int pc87413_get_swc_base(void)
 
 	/* Step 3: Read SWC I/O Base Address */
 
-	outb_p(0x60, WDT_INDEX_IO_PORT);        /* Read Index 0x60 */
+	outb_p(0x60, WDT_INDEX_IO_PORT);	/* Read Index 0x60 */
 	addr_h = inb(WDT_DATA_IO_PORT);
 
-	outb_p(0x61, WDT_INDEX_IO_PORT);        /* Read Index 0x61 */
+	outb_p(0x61, WDT_INDEX_IO_PORT);	/* Read Index 0x61 */
 
 	addr_l = inb(WDT_DATA_IO_PORT);
 
 	swc_base_addr = (addr_h << 8) + addr_l;
-
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Read SWC I/O Base Address: low %d, high %d,"
-	                      " res %d\n", addr_l, addr_h, swc_base_addr);
+	printk(KERN_INFO DPFX
+		"Read SWC I/O Base Address: low %d, high %d, res %d\n",
+						addr_l, addr_h, swc_base_addr);
 #endif
-
 	return swc_base_addr;
 }
 
@@ -143,9 +143,7 @@ static inline unsigned int pc87413_get_swc_base(void)
 static inline void pc87413_swc_bank3(unsigned int swc_base_addr)
 {
 	/* Step 4: Select Bank3 of SWC */
-
 	outb_p(inb(swc_base_addr + 0x0f) | 0x03, swc_base_addr + 0x0f);
-
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "Select Bank3 of SWC\n");
 #endif
@@ -157,9 +155,7 @@ static inline void pc87413_programm_wdto(unsigned int swc_base_addr,
 					 char pc87413_time)
 {
 	/* Step 5: Programm WDTO, Twd. */
-
 	outb_p(pc87413_time, swc_base_addr + WDTO);
-
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "Set WDTO to %d minutes\n", pc87413_time);
 #endif
@@ -170,9 +166,7 @@ static inline void pc87413_programm_wdto(unsigned int swc_base_addr,
 static inline void pc87413_enable_wden(unsigned int swc_base_addr)
 {
 	/* Step 6: Enable WDEN */
-
-	outb_p(inb (swc_base_addr + WDCTL) | 0x01, swc_base_addr + WDCTL);
-
+	outb_p(inb(swc_base_addr + WDCTL) | 0x01, swc_base_addr + WDCTL);
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "Enable WDEN\n");
 #endif
@@ -182,9 +176,7 @@ static inline void pc87413_enable_wden(unsigned int swc_base_addr)
 static inline void pc87413_enable_sw_wd_tren(unsigned int swc_base_addr)
 {
 	/* Enable SW_WD_TREN */
-
-	outb_p(inb (swc_base_addr + WDCFG) | 0x80, swc_base_addr + WDCFG);
-
+	outb_p(inb(swc_base_addr + WDCFG) | 0x80, swc_base_addr + WDCFG);
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "Enable SW_WD_TREN\n");
 #endif
@@ -195,9 +187,7 @@ static inline void pc87413_enable_sw_wd_tren(unsigned int swc_base_addr)
 static inline void pc87413_disable_sw_wd_tren(unsigned int swc_base_addr)
 {
 	/* Disable SW_WD_TREN */
-
-	outb_p(inb (swc_base_addr + WDCFG) & 0x7f, swc_base_addr + WDCFG);
-
+	outb_p(inb(swc_base_addr + WDCFG) & 0x7f, swc_base_addr + WDCFG);
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "pc87413 - Disable SW_WD_TREN\n");
 #endif
@@ -208,9 +198,7 @@ static inline void pc87413_disable_sw_wd_tren(unsigned int swc_base_addr)
 static inline void pc87413_enable_sw_wd_trg(unsigned int swc_base_addr)
 {
 	/* Enable SW_WD_TRG */
-
-	outb_p(inb (swc_base_addr + WDCTL) | 0x80, swc_base_addr + WDCTL);
-
+	outb_p(inb(swc_base_addr + WDCTL) | 0x80, swc_base_addr + WDCTL);
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "pc87413 - Enable SW_WD_TRG\n");
 #endif
@@ -221,9 +209,7 @@ static inline void pc87413_enable_sw_wd_trg(unsigned int swc_base_addr)
 static inline void pc87413_disable_sw_wd_trg(unsigned int swc_base_addr)
 {
 	/* Disable SW_WD_TRG */
-
-	outb_p(inb (swc_base_addr + WDCTL) & 0x7f, swc_base_addr + WDCTL);
-
+	outb_p(inb(swc_base_addr + WDCTL) & 0x7f, swc_base_addr + WDCTL);
 #ifdef DEBUG
 	printk(KERN_INFO DPFX "Disable SW_WD_TRG\n");
 #endif
@@ -314,8 +300,8 @@ static int pc87413_open(struct inode *inode, struct file *file)
 	/* Reload and activate timer */
 	pc87413_refresh();
 
-	printk(KERN_INFO MODNAME "Watchdog enabled. Timeout set to"
-	                         " %d minute(s).\n", timeout);
+	printk(KERN_INFO MODNAME
+		"Watchdog enabled. Timeout set to %d minute(s).\n", timeout);
 
 	return nonseekable_open(inode, file);
 }
@@ -338,17 +324,15 @@ static int pc87413_release(struct inode *inode, struct file *file)
 
 	if (expect_close == 42) {
 		pc87413_disable();
-		printk(KERN_INFO MODNAME "Watchdog disabled,"
-		                         " sleeping again...\n");
+		printk(KERN_INFO MODNAME
+				"Watchdog disabled, sleeping again...\n");
 	} else {
-		printk(KERN_CRIT MODNAME "Unexpected close, not stopping"
-		                         " watchdog!\n");
+		printk(KERN_CRIT MODNAME
+				"Unexpected close, not stopping watchdog!\n");
 		pc87413_refresh();
 	}
-
 	clear_bit(0, &timer_enabled);
 	expect_close = 0;
-
 	return 0;
 }
 
@@ -386,10 +370,11 @@ static ssize_t pc87413_write(struct file *file, const char __user *data,
 			/* reset expect flag */
 			expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			   magic character */
 			for (i = 0; i != len; i++) {
 				char c;
-				if (get_user(c, data+i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_close = 42;
@@ -404,7 +389,6 @@ static ssize_t pc87413_write(struct file *file, const char __user *data,
 
 /**
  *	pc87413_ioctl:
- *	@inode: inode of the device
  *	@file: file handle to the device
  *	@cmd: watchdog command
  *	@arg: argument pointer
@@ -414,8 +398,8 @@ static ssize_t pc87413_write(struct file *file, const char __user *data,
  *	querying capabilities and current status.
  */
 
-static int pc87413_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long pc87413_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int new_timeout;
 
@@ -426,75 +410,58 @@ static int pc87413_ioctl(struct inode *inode, struct file *file,
 
 	static struct watchdog_info ident = {
 		.options          = WDIOF_KEEPALIVEPING |
-		                    WDIOF_SETTIMEOUT |
-		                    WDIOF_MAGICCLOSE,
+				    WDIOF_SETTIMEOUT |
+				    WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
-		.identity         = "PC87413(HF/F) watchdog"
+		.identity         = "PC87413(HF/F) watchdog",
 	};
 
 	uarg.i = (int __user *)arg;
 
-	switch(cmd) {
-		default:
-			return -ENOTTY;
-
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(uarg.ident, &ident,
-				sizeof(ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-			return put_user(pc87413_status(), uarg.i);
-
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, uarg.i);
-
-		case WDIOC_KEEPALIVE:
-			pc87413_refresh();
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(uarg.ident, &ident,
+					sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		return put_user(pc87413_status(), uarg.i);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, uarg.i);
+	case WDIOC_SETOPTIONS:
+	{
+		int options, retval = -EINVAL;
+		if (get_user(options, uarg.i))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			pc87413_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			pc87413_enable();
+			retval = 0;
+		}
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		pc87413_refresh();
 #ifdef DEBUG
-	                printk(KERN_INFO DPFX "keepalive\n");
+		printk(KERN_INFO DPFX "keepalive\n");
 #endif
-			return 0;
-
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_timeout, uarg.i))
-				return -EFAULT;
-
-			// the API states this is given in secs
-			new_timeout /= 60;
-
-			if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
-				return -EINVAL;
-
-			timeout = new_timeout;
-			pc87413_refresh();
-
-			// fall through and return the new timeout...
-
-		case WDIOC_GETTIMEOUT:
-
-		        new_timeout = timeout * 60;
-
-			return put_user(new_timeout, uarg.i);
-
-		case WDIOC_SETOPTIONS:
-		{
-			int options, retval = -EINVAL;
-
-			if (get_user(options, uarg.i))
-				return -EFAULT;
-
-			if (options & WDIOS_DISABLECARD) {
-			        pc87413_disable();
-				retval = 0;
-			}
-
-			if (options & WDIOS_ENABLECARD) {
-				pc87413_enable();
-				retval = 0;
-			}
-
-			return retval;
-		}
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, uarg.i))
+			return -EFAULT;
+		/* the API states this is given in secs */
+		new_timeout /= 60;
+		if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
+			return -EINVAL;
+		timeout = new_timeout;
+		pc87413_refresh();
+		/* fall through and return the new timeout... */
+	case WDIOC_GETTIMEOUT:
+		new_timeout = timeout * 60;
+		return put_user(new_timeout, uarg.i);
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -517,10 +484,8 @@ static int pc87413_notify_sys(struct notifier_block *this,
 			      void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
-	{
 		/* Turn the card off */
 		pc87413_disable();
-	}
 	return NOTIFY_DONE;
 }
 
@@ -530,21 +495,19 @@ static const struct file_operations pc87413_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= pc87413_write,
-	.ioctl		= pc87413_ioctl,
+	.unlocked_ioctl	= pc87413_ioctl,
 	.open		= pc87413_open,
 	.release	= pc87413_release,
 };
 
-static struct notifier_block pc87413_notifier =
-{
+static struct notifier_block pc87413_notifier = {
 	.notifier_call  = pc87413_notify_sys,
 };
 
-static struct miscdevice pc87413_miscdev=
-{
+static struct miscdevice pc87413_miscdev = {
 	.minor          = WATCHDOG_MINOR,
 	.name           = "watchdog",
-	.fops           = &pc87413_fops
+	.fops           = &pc87413_fops,
 };
 
 /* -- Module init functions -------------------------------------*/
@@ -561,29 +524,26 @@ static int __init pc87413_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n", WDT_INDEX_IO_PORT);
+	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n",
+							WDT_INDEX_IO_PORT);
 
 	/* request_region(io, 2, "pc87413"); */
 
 	ret = register_reboot_notifier(&pc87413_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 	}
 
 	ret = misc_register(&pc87413_miscdev);
-
 	if (ret != 0) {
 		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&pc87413_notifier);
 		return ret;
 	}
-
 	printk(KERN_INFO PFX "initialized. timeout=%d min \n", timeout);
-
 	pc87413_enable();
-
 	return 0;
 }
 
@@ -600,17 +560,16 @@ static int __init pc87413_init(void)
 static void __exit pc87413_exit(void)
 {
 	/* Stop the timer before we leave */
-	if (!nowayout)
-	{
+	if (!nowayout) {
 		pc87413_disable();
 		printk(KERN_INFO MODNAME "Watchdog disabled.\n");
 	}
 
 	misc_deregister(&pc87413_miscdev);
 	unregister_reboot_notifier(&pc87413_notifier);
-	/* release_region(io,2); */
+	/* release_region(io, 2); */
 
-	printk(MODNAME " watchdog component driver removed.\n");
+	printk(KERN_INFO MODNAME " watchdog component driver removed.\n");
 }
 
 module_init(pc87413_init);
@@ -626,8 +585,12 @@ module_param(io, int, 0);
 MODULE_PARM_DESC(io, MODNAME " I/O port (default: " __MODULE_STRING(io) ").");
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in minutes (default=" __MODULE_STRING(timeout) ").");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in minutes (default="
+				__MODULE_STRING(timeout) ").");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index 7b41434..3b0ddc7 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -40,13 +40,15 @@
  *		fairly useless proc entry.
  * 990610	removed said useless proc code for the merge <alan>
  * 000403	Removed last traces of proc code. <davej>
- * 011214	Added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT <Matt_Domsch@dell.com>
+ * 011214	Added nowayout module option to override
+ *		CONFIG_WATCHDOG_NOWAYOUT <Matt_Domsch@dell.com>
  *              Added timeout module option to override default
  */
 
 /*
  *	A bells and whistles driver is available from http://www.pcwd.de/
- *	More info available at http://www.berkprod.com/ or http://www.pcwatchdog.com/
+ *	More info available at http://www.berkprod.com/ or
+ *	http://www.pcwatchdog.com/
  */
 
 #include <linux/module.h>	/* For module specific items */
@@ -65,9 +67,8 @@
 #include <linux/isa.h>		/* For isa devices */
 #include <linux/ioport.h>	/* For io-port access */
 #include <linux/spinlock.h>	/* For spin_lock/spin_unlock/... */
-
-#include <asm/uaccess.h>	/* For copy_to_user/put_user/... */
-#include <asm/io.h>		/* For inb/outb/... */
+#include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
+#include <linux/io.h>		/* For inb/outb/... */
 
 /* Module and version information */
 #define WATCHDOG_VERSION "1.20"
@@ -111,14 +112,16 @@ static int pcwd_ioports[] = { 0x270, 0x350, 0x370, 0x000 };
 #define WD_REVC_WTRP		0x01	/* Watchdog Trip status */
 #define WD_REVC_HRBT		0x02	/* Watchdog Heartbeat */
 #define WD_REVC_TTRP		0x04	/* Temperature Trip status */
-#define WD_REVC_RL2A		0x08	/* Relay 2 activated by on-board processor */
+#define WD_REVC_RL2A		0x08	/* Relay 2 activated by
+							on-board processor */
 #define WD_REVC_RL1A		0x10	/* Relay 1 active */
 #define WD_REVC_R2DS		0x40	/* Relay 2 disable */
 #define WD_REVC_RLY2		0x80	/* Relay 2 activated? */
 /* Port 2 : Control Status #2 */
 #define WD_WDIS			0x10	/* Watchdog Disabled */
 #define WD_ENTP			0x20	/* Watchdog Enable Temperature Trip */
-#define WD_SSEL			0x40	/* Watchdog Switch Select (1:SW1 <-> 0:SW2) */
+#define WD_SSEL			0x40	/* Watchdog Switch Select
+							(1:SW1 <-> 0:SW2) */
 #define WD_WCMD			0x80	/* Watchdog Command Mode */
 
 /* max. time we give an ISA watchdog card to process a command */
@@ -142,7 +145,7 @@ static int pcwd_ioports[] = { 0x270, 0x350, 0x370, 0x000 };
 #define CMD_ISA_RESET_RELAYS		0x0D
 
 /* Watchdog's Dip Switch heartbeat values */
-static const int heartbeat_tbl [] = {
+static const int heartbeat_tbl[] = {
 	20,	/* OFF-OFF-OFF	= 20 Sec  */
 	40,	/* OFF-OFF-ON	= 40 Sec  */
 	60,	/* OFF-ON-OFF	=  1 Min  */
@@ -168,11 +171,15 @@ static int cards_found;
 static atomic_t open_allowed = ATOMIC_INIT(1);
 static char expect_close;
 static int temp_panic;
-static struct {				/* this is private data for each ISA-PC watchdog card */
+
+/* this is private data for each ISA-PC watchdog card */
+static struct {
 	char fw_ver_str[6];		/* The cards firmware version */
 	int revision;			/* The card's revision */
-	int supports_temp;		/* Wether or not the card has a temperature device */
-	int command_mode;		/* Wether or not the card is in command mode */
+	int supports_temp;		/* Whether or not the card has
+						a temperature device */
+	int command_mode;		/* Whether or not the card is in
+						command mode */
 	int boot_status;		/* The card's boot status */
 	int io_addr;			/* The cards I/O address */
 	spinlock_t io_lock;		/* the lock for io operations */
@@ -186,16 +193,20 @@ static struct {				/* this is private data for each ISA-PC watchdog card */
 #define DEBUG	2	/* print fancy stuff too */
 static int debug = QUIET;
 module_param(debug, int, 0);
-MODULE_PARM_DESC(debug, "Debug level: 0=Quiet, 1=Verbose, 2=Debug (default=0)");
+MODULE_PARM_DESC(debug,
+		"Debug level: 0=Quiet, 1=Verbose, 2=Debug (default=0)");
 
-#define WATCHDOG_HEARTBEAT 0		/* default heartbeat = delay-time from dip-switches */
+/* default heartbeat = delay-time from dip-switches */
+#define WATCHDOG_HEARTBEAT 0
 static int heartbeat = WATCHDOG_HEARTBEAT;
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<=heartbeat<=7200 or 0=delay-time from dip-switches, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2 <= heartbeat <= 7200 or 0=delay-time from dip-switches, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Internal functions
@@ -224,7 +235,7 @@ static int send_isa_command(int cmd)
 		if (port0 == last_port0)
 			break;	/* Data is stable */
 
-		udelay (250);
+		udelay(250);
 	}
 
 	if (debug >= DEBUG)
@@ -236,7 +247,7 @@ static int send_isa_command(int cmd)
 
 static int set_command_mode(void)
 {
-	int i, found=0, count=0;
+	int i, found = 0, count = 0;
 
 	/* Set the card into command mode */
 	spin_lock(&pcwd_private.io_lock);
@@ -261,7 +272,7 @@ static int set_command_mode(void)
 		printk(KERN_DEBUG PFX "command_mode=%d\n",
 				pcwd_private.command_mode);
 
-	return(found);
+	return found;
 }
 
 static void unset_command_mode(void)
@@ -296,7 +307,8 @@ static inline void pcwd_get_firmware(void)
 		ten = send_isa_command(CMD_ISA_VERSION_TENTH);
 		hund = send_isa_command(CMD_ISA_VERSION_HUNDRETH);
 		minor = send_isa_command(CMD_ISA_VERSION_MINOR);
-		sprintf(pcwd_private.fw_ver_str, "%c.%c%c%c", one, ten, hund, minor);
+		sprintf(pcwd_private.fw_ver_str, "%c.%c%c%c",
+					one, ten, hund, minor);
 	}
 	unset_command_mode();
 
@@ -305,7 +317,7 @@ static inline void pcwd_get_firmware(void)
 
 static inline int pcwd_get_option_switches(void)
 {
-	int option_switches=0;
+	int option_switches = 0;
 
 	if (set_command_mode()) {
 		/* Get switch settings */
@@ -313,7 +325,7 @@ static inline int pcwd_get_option_switches(void)
 	}
 
 	unset_command_mode();
-	return(option_switches);
+	return option_switches;
 }
 
 static void pcwd_show_card_info(void)
@@ -322,7 +334,9 @@ static void pcwd_show_card_info(void)
 
 	/* Get some extra info from the hardware (in command/debug/diag mode) */
 	if (pcwd_private.revision == PCWD_REVISION_A)
-		printk(KERN_INFO PFX "ISA-PC Watchdog (REV.A) detected at port 0x%04x\n", pcwd_private.io_addr);
+		printk(KERN_INFO PFX
+			"ISA-PC Watchdog (REV.A) detected at port 0x%04x\n",
+							pcwd_private.io_addr);
 	else if (pcwd_private.revision == PCWD_REVISION_C) {
 		pcwd_get_firmware();
 		printk(KERN_INFO PFX "ISA-PC Watchdog (REV.C) detected at port 0x%04x (Firmware version: %s)\n",
@@ -347,12 +361,15 @@ static void pcwd_show_card_info(void)
 		printk(KERN_INFO PFX "Previous reboot was caused by the card\n");
 
 	if (pcwd_private.boot_status & WDIOF_OVERHEAT) {
-		printk(KERN_EMERG PFX "Card senses a CPU Overheat. Panicking!\n");
-		printk(KERN_EMERG PFX "CPU Overheat\n");
+		printk(KERN_EMERG PFX
+			"Card senses a CPU Overheat. Panicking!\n");
+		printk(KERN_EMERG PFX
+			"CPU Overheat\n");
 	}
 
 	if (pcwd_private.boot_status == 0)
-		printk(KERN_INFO PFX "No previous trip detected - Cold boot or reset\n");
+		printk(KERN_INFO PFX
+			"No previous trip detected - Cold boot or reset\n");
 }
 
 static void pcwd_timer_ping(unsigned long data)
@@ -361,11 +378,12 @@ static void pcwd_timer_ping(unsigned long data)
 
 	/* If we got a heartbeat pulse within the WDT_INTERVAL
 	 * we agree to ping the WDT */
-	if(time_before(jiffies, pcwd_private.next_heartbeat)) {
+	if (time_before(jiffies, pcwd_private.next_heartbeat)) {
 		/* Ping the watchdog */
 		spin_lock(&pcwd_private.io_lock);
 		if (pcwd_private.revision == PCWD_REVISION_A) {
-			/*  Rev A cards are reset by setting the WD_WDRST bit in register 1 */
+			/*  Rev A cards are reset by setting the
+			    WD_WDRST bit in register 1 */
 			wdrst_stat = inb_p(pcwd_private.io_addr);
 			wdrst_stat &= 0x0F;
 			wdrst_stat |= WD_WDRST;
@@ -381,7 +399,8 @@ static void pcwd_timer_ping(unsigned long data)
 
 		spin_unlock(&pcwd_private.io_lock);
 	} else {
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
+		printk(KERN_WARNING PFX
+			"Heartbeat lost! Will not ping the watchdog\n");
 	}
 }
 
@@ -454,7 +473,7 @@ static int pcwd_keepalive(void)
 
 static int pcwd_set_heartbeat(int t)
 {
-	if ((t < 2) || (t > 7200)) /* arbitrary upper limit */
+	if (t < 2 || t > 7200) /* arbitrary upper limit */
 		return -EINVAL;
 
 	heartbeat = t;
@@ -470,7 +489,7 @@ static int pcwd_get_status(int *status)
 {
 	int control_status;
 
-	*status=0;
+	*status = 0;
 	spin_lock(&pcwd_private.io_lock);
 	if (pcwd_private.revision == PCWD_REVISION_A)
 		/* Rev A cards return status information from
@@ -494,9 +513,9 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_T110) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				printk(KERN_INFO PFX "Temperature overheat trip!\n");
+				printk(KERN_INFO PFX
+					"Temperature overheat trip!\n");
 				kernel_power_off();
-				/* or should we just do a: panic(PFX "Temperature overheat trip!\n"); */
 			}
 		}
 	} else {
@@ -506,9 +525,9 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_REVC_TTRP) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				printk(KERN_INFO PFX "Temperature overheat trip!\n");
+				printk(KERN_INFO PFX
+					"Temperature overheat trip!\n");
 				kernel_power_off();
-				/* or should we just do a: panic(PFX "Temperature overheat trip!\n"); */
 			}
 		}
 	}
@@ -524,18 +543,21 @@ static int pcwd_clear_status(void)
 		spin_lock(&pcwd_private.io_lock);
 
 		if (debug >= VERBOSE)
-			printk(KERN_INFO PFX "clearing watchdog trip status\n");
+			printk(KERN_INFO PFX
+					"clearing watchdog trip status\n");
 
 		control_status = inb_p(pcwd_private.io_addr + 1);
 
 		if (debug >= DEBUG) {
-			printk(KERN_DEBUG PFX "status was: 0x%02x\n", control_status);
+			printk(KERN_DEBUG PFX "status was: 0x%02x\n",
+				control_status);
 			printk(KERN_DEBUG PFX "sending: 0x%02x\n",
 				(control_status & WD_REVC_R2DS));
 		}
 
 		/* clear reset status & Keep Relay 2 disable state as it is */
-		outb_p((control_status & WD_REVC_R2DS), pcwd_private.io_addr + 1);
+		outb_p((control_status & WD_REVC_R2DS),
+						pcwd_private.io_addr + 1);
 
 		spin_unlock(&pcwd_private.io_lock);
 	}
@@ -572,8 +594,7 @@ static int pcwd_get_temperature(int *temperature)
  *	/dev/watchdog handling
  */
 
-static int pcwd_ioctl(struct inode *inode, struct file *file,
-		      unsigned int cmd, unsigned long arg)
+static long pcwd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int rv;
 	int status;
@@ -590,12 +611,9 @@ static int pcwd_ioctl(struct inode *inode, struct file *file,
 		.identity =		"PCWD",
 	};
 
-	switch(cmd) {
-	default:
-		return -ENOTTY;
-
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if(copy_to_user(argp, &ident, sizeof(ident)))
+		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
 		return 0;
 
@@ -613,25 +631,22 @@ static int pcwd_ioctl(struct inode *inode, struct file *file,
 		return put_user(temperature, argp);
 
 	case WDIOC_SETOPTIONS:
-		if (pcwd_private.revision == PCWD_REVISION_C)
-		{
-			if(copy_from_user(&rv, argp, sizeof(int)))
+		if (pcwd_private.revision == PCWD_REVISION_C) {
+			if (get_user(rv, argp))
 				return -EFAULT;
 
-			if (rv & WDIOS_DISABLECARD)
-			{
-				return pcwd_stop();
+			if (rv & WDIOS_DISABLECARD) {
+				status = pcwd_stop();
+				if (status < 0)
+					return status;
 			}
-
-			if (rv & WDIOS_ENABLECARD)
-			{
-				return pcwd_start();
+			if (rv & WDIOS_ENABLECARD) {
+				status = pcwd_start();
+				if (status < 0)
+					return status;
 			}
-
 			if (rv & WDIOS_TEMPPANIC)
-			{
 				temp_panic = 1;
-			}
 		}
 		return -EINVAL;
 
@@ -651,6 +666,9 @@ static int pcwd_ioctl(struct inode *inode, struct file *file,
 
 	case WDIOC_GETTIMEOUT:
 		return put_user(heartbeat, argp);
+
+	default:
+		return -ENOTTY;
 	}
 
 	return 0;
@@ -682,16 +700,10 @@ static ssize_t pcwd_write(struct file *file, const char __user *buf, size_t len,
 
 static int pcwd_open(struct inode *inode, struct file *file)
 {
-	if (!atomic_dec_and_test(&open_allowed) ) {
-		if (debug >= VERBOSE)
-			printk(KERN_ERR PFX "Attempt to open already opened device.\n");
-		atomic_inc( &open_allowed );
+	if (test_and_set_bit(0, &open_allowed))
 		return -EBUSY;
-	}
-
 	if (nowayout)
 		__module_get(THIS_MODULE);
-
 	/* Activate */
 	pcwd_start();
 	pcwd_keepalive();
@@ -700,14 +712,15 @@ static int pcwd_open(struct inode *inode, struct file *file)
 
 static int pcwd_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		pcwd_stop();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		pcwd_keepalive();
 	}
 	expect_close = 0;
-	atomic_inc( &open_allowed );
+	clear_bit(0, &open_allowed);
 	return 0;
 }
 
@@ -750,7 +763,7 @@ static const struct file_operations pcwd_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= pcwd_write,
-	.ioctl		= pcwd_ioctl,
+	.unlocked_ioctl	= pcwd_ioctl,
 	.open		= pcwd_open,
 	.release	= pcwd_close,
 };
@@ -788,7 +801,7 @@ static inline int get_revision(void)
 	 * presumes a floating bus reads as 0xff. */
 	if ((inb(pcwd_private.io_addr + 2) == 0xFF) ||
 	    (inb(pcwd_private.io_addr + 3) == 0xFF))
-		r=PCWD_REVISION_A;
+		r = PCWD_REVISION_A;
 	spin_unlock(&pcwd_private.io_lock);
 
 	return r;
@@ -803,7 +816,7 @@ static inline int get_revision(void)
  */
 static int __devinit pcwd_isa_match(struct device *dev, unsigned int id)
 {
-	int base_addr=pcwd_ioports[id];
+	int base_addr = pcwd_ioports[id];
 	int port0, last_port0;	/* Reg 0, in case it's REV A */
 	int port1, last_port1;	/* Register 1 for REV C cards */
 	int i;
@@ -813,7 +826,7 @@ static int __devinit pcwd_isa_match(struct device *dev, unsigned int id)
 		printk(KERN_DEBUG PFX "pcwd_isa_match id=%d\n",
 			id);
 
-	if (!request_region (base_addr, 4, "PCWD")) {
+	if (!request_region(base_addr, 4, "PCWD")) {
 		printk(KERN_INFO PFX "Port 0x%04x unavailable\n", base_addr);
 		return 0;
 	}
@@ -842,7 +855,7 @@ static int __devinit pcwd_isa_match(struct device *dev, unsigned int id)
 			}
 		}
 	}
-	release_region (base_addr, 4);
+	release_region(base_addr, 4);
 
 	return retval;
 }
@@ -857,7 +870,8 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 
 	cards_found++;
 	if (cards_found == 1)
-		printk(KERN_INFO PFX "v%s Ken Hollis (kenji@bitgate.com)\n", WD_VER);
+		printk(KERN_INFO PFX "v%s Ken Hollis (kenji@bitgate.com)\n",
+								WD_VER);
 
 	if (cards_found > 1) {
 		printk(KERN_ERR PFX "This driver only supports 1 device\n");
@@ -875,10 +889,11 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 	/* Check card's revision */
 	pcwd_private.revision = get_revision();
 
-	if (!request_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4, "PCWD")) {
+	if (!request_region(pcwd_private.io_addr,
+		(pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4, "PCWD")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			pcwd_private.io_addr);
-		ret=-EIO;
+		ret = -EIO;
 		goto error_request_region;
 	}
 
@@ -908,26 +923,30 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 	if (heartbeat == 0)
 		heartbeat = heartbeat_tbl[(pcwd_get_option_switches() & 0x07)];
 
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
+	/* Check that the heartbeat value is within it's range;
+	   if not reset to the default */
 	if (pcwd_set_heartbeat(heartbeat)) {
 		pcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX "heartbeat value must be 2<=heartbeat<=7200, using %d\n",
-			WATCHDOG_HEARTBEAT);
+		printk(KERN_INFO PFX
+		  "heartbeat value must be 2 <= heartbeat <= 7200, using %d\n",
+							WATCHDOG_HEARTBEAT);
 	}
 
 	if (pcwd_private.supports_temp) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-				TEMP_MINOR, ret);
+			printk(KERN_ERR PFX
+			    "cannot register miscdev on minor=%d (err=%d)\n",
+							TEMP_MINOR, ret);
 			goto error_misc_register_temp;
 		}
 	}
 
 	ret = misc_register(&pcwd_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+					WATCHDOG_MINOR, ret);
 		goto error_misc_register_watchdog;
 	}
 
@@ -940,7 +959,8 @@ error_misc_register_watchdog:
 	if (pcwd_private.supports_temp)
 		misc_deregister(&temp_miscdev);
 error_misc_register_temp:
-	release_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
+	release_region(pcwd_private.io_addr,
+			(pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
 error_request_region:
 	pcwd_private.io_addr = 0x0000;
 	cards_found--;
@@ -964,7 +984,8 @@ static int __devexit pcwd_isa_remove(struct device *dev, unsigned int id)
 	misc_deregister(&pcwd_miscdev);
 	if (pcwd_private.supports_temp)
 		misc_deregister(&temp_miscdev);
-	release_region(pcwd_private.io_addr, (pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
+	release_region(pcwd_private.io_addr,
+			(pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4);
 	pcwd_private.io_addr = 0x0000;
 	cards_found--;
 
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 61a89e9..90eb1d4 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -46,9 +46,8 @@
 #include <linux/pci.h>		/* For pci functions */
 #include <linux/ioport.h>	/* For io-port access */
 #include <linux/spinlock.h>	/* For spin_lock/spin_unlock/... */
-
-#include <asm/uaccess.h>	/* For copy_to_user/put_user/... */
-#include <asm/io.h>		/* For inb/outb/... */
+#include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
+#include <linux/io.h>		/* For inb/outb/... */
 
 /* Module and version information */
 #define WATCHDOG_VERSION "1.03"
@@ -97,7 +96,7 @@
 #define CMD_GET_CLEAR_RESET_COUNT		0x84
 
 /* Watchdog's Dip Switch heartbeat values */
-static const int heartbeat_tbl [] = {
+static const int heartbeat_tbl[] = {
 	5,	/* OFF-OFF-OFF	=  5 Sec  */
 	10,	/* OFF-OFF-ON	= 10 Sec  */
 	30,	/* OFF-ON-OFF	= 30 Sec  */
@@ -220,11 +219,10 @@ static void pcipcwd_show_card_info(void)
 	int option_switches;
 
 	got_fw_rev = send_command(CMD_GET_FIRMWARE_VERSION, &fw_rev_major, &fw_rev_minor);
-	if (got_fw_rev) {
+	if (got_fw_rev)
 		sprintf(fw_ver_str, "%u.%02u", fw_rev_major, fw_rev_minor);
-	} else {
+	else
 		sprintf(fw_ver_str, "<card no answer>");
-	}
 
 	/* Get switch settings */
 	option_switches = pcipcwd_get_option_switches();
@@ -331,7 +329,7 @@ static int pcipcwd_get_status(int *status)
 {
 	int control_status;
 
-	*status=0;
+	*status = 0;
 	control_status = inb_p(pcipcwd_private.io_addr + 1);
 	if (control_status & WD_PCI_WTRP)
 		*status |= WDIOF_CARDRESET;
@@ -369,8 +367,8 @@ static int pcipcwd_clear_status(void)
 	outb_p((control_status & WD_PCI_R2DS) | WD_PCI_WTRP, pcipcwd_private.io_addr + 1);
 
 	/* clear reset counter */
-	msb=0;
-	reset_counter=0xff;
+	msb = 0;
+	reset_counter = 0xff;
 	send_command(CMD_GET_CLEAR_RESET_COUNT, &msb, &reset_counter);
 
 	if (debug >= DEBUG) {
@@ -442,7 +440,7 @@ static ssize_t pcipcwd_write(struct file *file, const char __user *data,
 			/* scan to see whether or not we got the magic character */
 			for (i = 0; i != len; i++) {
 				char c;
-				if(get_user(c, data+i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_release = 42;
@@ -455,8 +453,8 @@ static ssize_t pcipcwd_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int pcipcwd_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long pcipcwd_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -471,92 +469,89 @@ static int pcipcwd_ioctl(struct inode *inode, struct file *file,
 	};
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof (ident)) ? -EFAULT : 0;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	{
+		int status;
+		pcipcwd_get_status(&status);
+		return put_user(status, p);
+	}
 
-		case WDIOC_GETSTATUS:
-		{
-			int status;
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(pcipcwd_private.boot_status, p);
 
-			pcipcwd_get_status(&status);
+	case WDIOC_GETTEMP:
+	{
+		int temperature;
 
-			return put_user(status, p);
-		}
+		if (pcipcwd_get_temperature(&temperature))
+			return -EFAULT;
 
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(pcipcwd_private.boot_status, p);
+		return put_user(temperature, p);
+	}
 
-		case WDIOC_GETTEMP:
-		{
-			int temperature;
+	case WDIOC_SETOPTIONS:
+	{
+		int new_options, retval = -EINVAL;
 
-			if (pcipcwd_get_temperature(&temperature))
-				return -EFAULT;
+		if (get_user(new_options, p))
+			return -EFAULT;
 
-			return put_user(temperature, p);
+		if (new_options & WDIOS_DISABLECARD) {
+			if (pcipcwd_stop())
+				return -EIO;
+			retval = 0;
 		}
 
-		case WDIOC_KEEPALIVE:
-			pcipcwd_keepalive();
-			return 0;
-
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
-
-			if (get_user (new_options, p))
-				return -EFAULT;
-
-			if (new_options & WDIOS_DISABLECARD) {
-				if (pcipcwd_stop())
-					return -EIO;
-				retval = 0;
-			}
+		if (new_options & WDIOS_ENABLECARD) {
+			if (pcipcwd_start())
+				return -EIO;
+			retval = 0;
+		}
 
-			if (new_options & WDIOS_ENABLECARD) {
-				if (pcipcwd_start())
-					return -EIO;
-				retval = 0;
-			}
+		if (new_options & WDIOS_TEMPPANIC) {
+			temp_panic = 1;
+			retval = 0;
+		}
 
-			if (new_options & WDIOS_TEMPPANIC) {
-				temp_panic = 1;
-				retval = 0;
-			}
+		return retval;
+	}
 
-			return retval;
-		}
+	case WDIOC_KEEPALIVE:
+		pcipcwd_keepalive();
+		return 0;
 
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_heartbeat;
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_heartbeat;
 
-			if (get_user(new_heartbeat, p))
-				return -EFAULT;
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
 
-			if (pcipcwd_set_heartbeat(new_heartbeat))
-			    return -EINVAL;
+		if (pcipcwd_set_heartbeat(new_heartbeat))
+		    return -EINVAL;
 
-			pcipcwd_keepalive();
-			/* Fall */
-		}
+		pcipcwd_keepalive();
+		/* Fall */
+	}
 
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
 
-		case WDIOC_GETTIMELEFT:
-		{
-			int time_left;
+	case WDIOC_GETTIMELEFT:
+	{
+		int time_left;
 
-			if (pcipcwd_get_timeleft(&time_left))
-				return -EFAULT;
+		if (pcipcwd_get_timeleft(&time_left))
+			return -EFAULT;
 
-			return put_user(time_left, p);
-		}
+		return put_user(time_left, p);
+	}
 
-		default:
-			return -ENOTTY;
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -603,7 +598,7 @@ static ssize_t pcipcwd_temp_read(struct file *file, char __user *data,
 	if (pcipcwd_get_temperature(&temperature))
 		return -EFAULT;
 
-	if (copy_to_user (data, &temperature, 1))
+	if (copy_to_user(data, &temperature, 1))
 		return -EFAULT;
 
 	return 1;
@@ -628,10 +623,8 @@ static int pcipcwd_temp_release(struct inode *inode, struct file *file)
 
 static int pcipcwd_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
 {
-	if (code==SYS_DOWN || code==SYS_HALT) {
-		/* Turn the WDT off */
-		pcipcwd_stop();
-	}
+	if (code == SYS_DOWN || code == SYS_HALT)
+		pcipcwd_stop();	/* Turn the WDT off */
 
 	return NOTIFY_DONE;
 }
@@ -644,7 +637,7 @@ static const struct file_operations pcipcwd_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.write =	pcipcwd_write,
-	.ioctl =	pcipcwd_ioctl,
+	.unlocked_ioctl = pcipcwd_ioctl,
 	.open =		pcipcwd_open,
 	.release =	pcipcwd_release,
 };
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index bf443d0..c1685c9 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -40,8 +40,7 @@
 #include <linux/slab.h>		/* For kmalloc, ... */
 #include <linux/mutex.h>	/* For mutex locking */
 #include <linux/hid.h>		/* For HID_REQ_SET_REPORT & HID_DT_REPORT */
-
-#include <asm/uaccess.h>	/* For copy_to_user/put_user/... */
+#include <linux/uaccess.h>	/* For copy_to_user/put_user/... */
 
 
 #ifdef CONFIG_USB_DEBUG
@@ -88,7 +87,7 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" _
 #define USB_PCWD_PRODUCT_ID	0x1140
 
 /* table of devices that work with this driver */
-static struct usb_device_id usb_pcwd_table [] = {
+static struct usb_device_id usb_pcwd_table[] = {
 	{ USB_DEVICE(USB_PCWD_VENDOR_ID, USB_PCWD_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
@@ -110,7 +109,7 @@ MODULE_DEVICE_TABLE (usb, usb_pcwd_table);
 #define CMD_DISABLE_WATCHDOG		CMD_ENABLE_WATCHDOG
 
 /* Watchdog's Dip Switch heartbeat values */
-static const int heartbeat_tbl [] = {
+static const int heartbeat_tbl[] = {
 	5,	/* OFF-OFF-OFF	=  5 Sec  */
 	10,	/* OFF-OFF-ON	= 10 Sec  */
 	30,	/* OFF-ON-OFF	= 30 Sec  */
@@ -130,15 +129,15 @@ static char expect_release;
 
 /* Structure to hold all of our device specific stuff */
 struct usb_pcwd_private {
-	struct usb_device *	udev;			/* save off the usb device pointer */
-	struct usb_interface *	interface;		/* the interface for this device */
+	struct usb_device	*udev;			/* save off the usb device pointer */
+	struct usb_interface	*interface;		/* the interface for this device */
 
 	unsigned int		interface_number;	/* the interface number used for cmd's */
 
-	unsigned char *		intr_buffer;		/* the buffer to intr data */
+	unsigned char		*intr_buffer;		/* the buffer to intr data */
 	dma_addr_t		intr_dma;		/* the dma address for the intr buffer */
 	size_t			intr_size;		/* the size of the intr buffer */
-	struct urb *		intr_urb;		/* the urb used for the intr pipe */
+	struct urb		*intr_urb;		/* the urb used for the intr pipe */
 
 	unsigned char		cmd_command;		/* The command that is reported back */
 	unsigned char		cmd_data_msb;		/* The data MSB that is reported back */
@@ -154,8 +153,8 @@ static struct usb_pcwd_private *usb_pcwd_device;
 static DEFINE_MUTEX(disconnect_mutex);
 
 /* local function prototypes */
-static int usb_pcwd_probe	(struct usb_interface *interface, const struct usb_device_id *id);
-static void usb_pcwd_disconnect	(struct usb_interface *interface);
+static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_device_id *id);
+static void usb_pcwd_disconnect(struct usb_interface *interface);
 
 /* usb specific object needed to register this driver with the usb subsystem */
 static struct usb_driver usb_pcwd_driver = {
@@ -195,10 +194,10 @@ static void usb_pcwd_intr_done(struct urb *urb)
 	usb_pcwd->cmd_data_lsb = data[2];
 
 	/* notify anyone waiting that the cmd has finished */
-	atomic_set (&usb_pcwd->cmd_received, 1);
+	atomic_set(&usb_pcwd->cmd_received, 1);
 
 resubmit:
-	retval = usb_submit_urb (urb, GFP_ATOMIC);
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		printk(KERN_ERR PFX "can't resubmit intr, usb_submit_urb failed with result %d\n",
 			retval);
@@ -224,7 +223,7 @@ static int usb_pcwd_send_command(struct usb_pcwd_private *usb_pcwd, unsigned cha
 	dbg("sending following data cmd=0x%02x msb=0x%02x lsb=0x%02x",
 		buf[0], buf[1], buf[2]);
 
-	atomic_set (&usb_pcwd->cmd_received, 0);
+	atomic_set(&usb_pcwd->cmd_received, 0);
 
 	if (usb_control_msg(usb_pcwd->udev, usb_sndctrlpipe(usb_pcwd->udev, 0),
 			HID_REQ_SET_REPORT, HID_DT_REPORT,
@@ -237,7 +236,7 @@ static int usb_pcwd_send_command(struct usb_pcwd_private *usb_pcwd, unsigned cha
 	got_response = 0;
 	for (count = 0; (count < USB_COMMAND_TIMEOUT) && (!got_response); count++) {
 		mdelay(1);
-		if (atomic_read (&usb_pcwd->cmd_received))
+		if (atomic_read(&usb_pcwd->cmd_received))
 			got_response = 1;
 	}
 
@@ -356,7 +355,7 @@ static ssize_t usb_pcwd_write(struct file *file, const char __user *data,
 			/* scan to see whether or not we got the magic character */
 			for (i = 0; i != len; i++) {
 				char c;
-				if(get_user(c, data+i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_release = 42;
@@ -369,8 +368,8 @@ static ssize_t usb_pcwd_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int usb_pcwd_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long usb_pcwd_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -383,77 +382,76 @@ static int usb_pcwd_ioctl(struct inode *inode, struct file *file,
 	};
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof (ident)) ? -EFAULT : 0;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
 
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
 
-		case WDIOC_GETTEMP:
-		{
-			int temperature;
+	case WDIOC_GETTEMP:
+	{
+		int temperature;
 
-			if (usb_pcwd_get_temperature(usb_pcwd_device, &temperature))
-				return -EFAULT;
+		if (usb_pcwd_get_temperature(usb_pcwd_device, &temperature))
+			return -EFAULT;
 
-			return put_user(temperature, p);
-		}
+		return put_user(temperature, p);
+	}
 
-		case WDIOC_KEEPALIVE:
-			usb_pcwd_keepalive(usb_pcwd_device);
-			return 0;
+	case WDIOC_SETOPTIONS:
+	{
+		int new_options, retval = -EINVAL;
 
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
+		if (get_user(new_options, p))
+			return -EFAULT;
 
-			if (get_user (new_options, p))
-				return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			usb_pcwd_stop(usb_pcwd_device);
+			retval = 0;
+		}
 
-			if (new_options & WDIOS_DISABLECARD) {
-				usb_pcwd_stop(usb_pcwd_device);
-				retval = 0;
-			}
+		if (new_options & WDIOS_ENABLECARD) {
+			usb_pcwd_start(usb_pcwd_device);
+			retval = 0;
+		}
 
-			if (new_options & WDIOS_ENABLECARD) {
-				usb_pcwd_start(usb_pcwd_device);
-				retval = 0;
-			}
+		return retval;
+	}
 
-			return retval;
-		}
+	case WDIOC_KEEPALIVE:
+		usb_pcwd_keepalive(usb_pcwd_device);
+		return 0;
 
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_heartbeat;
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_heartbeat;
 
-			if (get_user(new_heartbeat, p))
-				return -EFAULT;
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
 
-			if (usb_pcwd_set_heartbeat(usb_pcwd_device, new_heartbeat))
-			    return -EINVAL;
+		if (usb_pcwd_set_heartbeat(usb_pcwd_device, new_heartbeat))
+		    return -EINVAL;
 
-			usb_pcwd_keepalive(usb_pcwd_device);
-			/* Fall */
-		}
+		usb_pcwd_keepalive(usb_pcwd_device);
+		/* Fall */
+	}
 
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, p);
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
 
-		case WDIOC_GETTIMELEFT:
-		{
-			int time_left;
+	case WDIOC_GETTIMELEFT:
+	{
+		int time_left;
 
-			if (usb_pcwd_get_timeleft(usb_pcwd_device, &time_left))
-				return -EFAULT;
+		if (usb_pcwd_get_timeleft(usb_pcwd_device, &time_left))
+			return -EFAULT;
 
-			return put_user(time_left, p);
-		}
+		return put_user(time_left, p);
+	}
 
-		default:
-			return -ENOTTY;
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -519,10 +517,8 @@ static int usb_pcwd_temperature_release(struct inode *inode, struct file *file)
 
 static int usb_pcwd_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
 {
-	if (code==SYS_DOWN || code==SYS_HALT) {
-		/* Turn the WDT off */
-		usb_pcwd_stop(usb_pcwd_device);
-	}
+	if (code == SYS_DOWN || code == SYS_HALT)
+		usb_pcwd_stop(usb_pcwd_device);	/* Turn the WDT off */
 
 	return NOTIFY_DONE;
 }
@@ -535,7 +531,7 @@ static const struct file_operations usb_pcwd_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.write =	usb_pcwd_write,
-	.ioctl =	usb_pcwd_ioctl,
+	.unlocked_ioctl = usb_pcwd_ioctl,
 	.open =		usb_pcwd_open,
 	.release =	usb_pcwd_release,
 };
@@ -567,13 +563,13 @@ static struct notifier_block usb_pcwd_notifier = {
 /**
  *	usb_pcwd_delete
  */
-static inline void usb_pcwd_delete (struct usb_pcwd_private *usb_pcwd)
+static inline void usb_pcwd_delete(struct usb_pcwd_private *usb_pcwd)
 {
 	usb_free_urb(usb_pcwd->intr_urb);
 	if (usb_pcwd->intr_buffer != NULL)
 		usb_buffer_free(usb_pcwd->udev, usb_pcwd->intr_size,
 				usb_pcwd->intr_buffer, usb_pcwd->intr_dma);
-	kfree (usb_pcwd);
+	kfree(usb_pcwd);
 }
 
 /**
@@ -626,7 +622,7 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 	maxp = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
 
 	/* allocate memory for our device and initialize it */
-	usb_pcwd = kzalloc (sizeof(struct usb_pcwd_private), GFP_KERNEL);
+	usb_pcwd = kzalloc(sizeof(struct usb_pcwd_private), GFP_KERNEL);
 	if (usb_pcwd == NULL) {
 		printk(KERN_ERR PFX "Out of memory\n");
 		goto error;
@@ -641,7 +637,8 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 	usb_pcwd->intr_size = (le16_to_cpu(endpoint->wMaxPacketSize) > 8 ? le16_to_cpu(endpoint->wMaxPacketSize) : 8);
 
 	/* set up the memory buffer's */
-	if (!(usb_pcwd->intr_buffer = usb_buffer_alloc(udev, usb_pcwd->intr_size, GFP_ATOMIC, &usb_pcwd->intr_dma))) {
+	usb_pcwd->intr_buffer = usb_buffer_alloc(udev, usb_pcwd->intr_size, GFP_ATOMIC, &usb_pcwd->intr_dma);
+	if (!usb_pcwd->intr_buffer) {
 		printk(KERN_ERR PFX "Out of memory\n");
 		goto error;
 	}
@@ -675,11 +672,10 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 
 	/* Get the Firmware Version */
 	got_fw_rev = usb_pcwd_send_command(usb_pcwd, CMD_GET_FIRMWARE_VERSION, &fw_rev_major, &fw_rev_minor);
-	if (got_fw_rev) {
+	if (got_fw_rev)
 		sprintf(fw_ver_str, "%u.%02u", fw_rev_major, fw_rev_minor);
-	} else {
+	else
 		sprintf(fw_ver_str, "<card no answer>");
-	}
 
 	printk(KERN_INFO PFX "Found card (Firmware: %s) with temp option\n",
 		fw_ver_str);
@@ -725,7 +721,7 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 	}
 
 	/* we can register the device now, as it is ready */
-	usb_set_intfdata (interface, usb_pcwd);
+	usb_set_intfdata(interface, usb_pcwd);
 
 	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
@@ -759,8 +755,8 @@ static void usb_pcwd_disconnect(struct usb_interface *interface)
 	/* prevent races with open() */
 	mutex_lock(&disconnect_mutex);
 
-	usb_pcwd = usb_get_intfdata (interface);
-	usb_set_intfdata (interface, NULL);
+	usb_pcwd = usb_get_intfdata(interface);
+	usb_set_intfdata(interface, NULL);
 
 	mutex_lock(&usb_pcwd->mtx);
 
@@ -820,5 +816,5 @@ static void __exit usb_pcwd_exit(void)
 }
 
 
-module_init (usb_pcwd_init);
-module_exit (usb_pcwd_exit);
+module_init(usb_pcwd_init);
+module_exit(usb_pcwd_exit);
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index 6b8483d..6eadf5e 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -28,10 +28,10 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
 
 #define MODULE_NAME "PNX4008-WDT: "
 
@@ -144,9 +144,8 @@ static int pnx4008_wdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static ssize_t
-pnx4008_wdt_write(struct file *file, const char *data, size_t len,
-		  loff_t * ppos)
+static ssize_t pnx4008_wdt_write(struct file *file, const char *data,
+					size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -169,15 +168,14 @@ pnx4008_wdt_write(struct file *file, const char *data, size_t len,
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE |
 	    WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	.identity = "PNX4008 Watchdog",
 };
 
-static int
-pnx4008_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		  unsigned long arg)
+static long pnx4008_wdt_ioctl(struct inode *inode, struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -196,6 +194,11 @@ pnx4008_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		ret = put_user(boot_status, (int *)arg);
 		break;
 
+	case WDIOC_KEEPALIVE:
+		wdt_enable();
+		ret = 0;
+		break;
+
 	case WDIOC_SETTIMEOUT:
 		ret = get_user(time, (int *)arg);
 		if (ret)
@@ -213,11 +216,6 @@ pnx4008_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	case WDIOC_GETTIMEOUT:
 		ret = put_user(heartbeat, (int *)arg);
 		break;
-
-	case WDIOC_KEEPALIVE:
-		wdt_enable();
-		ret = 0;
-		break;
 	}
 	return ret;
 }
@@ -238,7 +236,7 @@ static const struct file_operations pnx4008_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = pnx4008_wdt_write,
-	.ioctl = pnx4008_wdt_ioctl,
+	.unlocked_ioctl = pnx4008_wdt_ioctl,
 	.open = pnx4008_wdt_open,
 	.release = pnx4008_wdt_release,
 };
diff --git a/drivers/watchdog/rm9k_wdt.c b/drivers/watchdog/rm9k_wdt.c
index 5c921e4..f1ae372 100644
--- a/drivers/watchdog/rm9k_wdt.c
+++ b/drivers/watchdog/rm9k_wdt.c
@@ -29,10 +29,10 @@
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <asm/io.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/atomic.h>
 #include <asm/processor.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/rm9k-ocd.h>
 
@@ -53,10 +53,12 @@ static void wdt_gpi_stop(void);
 static void wdt_gpi_set_timeout(unsigned int);
 static int wdt_gpi_open(struct inode *, struct file *);
 static int wdt_gpi_release(struct inode *, struct file *);
-static ssize_t wdt_gpi_write(struct file *, const char __user *, size_t, loff_t *);
+static ssize_t wdt_gpi_write(struct file *, const char __user *, size_t,
+								loff_t *);
 static long wdt_gpi_ioctl(struct file *, unsigned int, unsigned long);
 static int wdt_gpi_notify(struct notifier_block *, unsigned long, void *);
-static const struct resource *wdt_gpi_get_resource(struct platform_device *, const char *, unsigned int);
+static const struct resource *wdt_gpi_get_resource(struct platform_device *,
+						const char *, unsigned int);
 static int __init wdt_gpi_probe(struct device *);
 static int __exit wdt_gpi_remove(struct device *);
 
@@ -68,7 +70,7 @@ static int locked;
 
 
 /* These are set from device resources */
-static void __iomem * wd_regs;
+static void __iomem *wd_regs;
 static unsigned int wd_irq, wd_ctr;
 
 
@@ -216,7 +218,8 @@ static int wdt_gpi_release(struct inode *inode, struct file *file)
 		if (expect_close) {
 			wdt_gpi_stop();
 			free_irq(wd_irq, &miscdev);
-			printk(KERN_INFO "%s: watchdog stopped\n", wdt_gpi_name);
+			printk(KERN_INFO "%s: watchdog stopped\n",
+							wdt_gpi_name);
 		} else {
 			printk(KERN_CRIT "%s: unexpected close() -"
 				" watchdog left running\n",
@@ -231,8 +234,8 @@ static int wdt_gpi_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t
-wdt_gpi_write(struct file *f, const char __user *d, size_t s, loff_t *o)
+static ssize_t wdt_gpi_write(struct file *f, const char __user *d, size_t s,
+								loff_t *o)
 {
 	char val;
 
@@ -241,8 +244,7 @@ wdt_gpi_write(struct file *f, const char __user *d, size_t s, loff_t *o)
 	return s ? 1 : 0;
 }
 
-static long
-wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static long wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	long res = -ENOTTY;
 	const long size = _IOC_SIZE(cmd);
@@ -271,7 +273,8 @@ wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	case WDIOC_GETSUPPORT:
 		wdinfo.options = nowayout ?
 			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING :
-			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE;
+			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+			WDIOF_MAGICCLOSE;
 		res = __copy_to_user(argp, &wdinfo, size) ?  -EFAULT : size;
 		break;
 
@@ -322,8 +325,8 @@ wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 
 
 /* Shutdown notifier */
-static int
-wdt_gpi_notify(struct notifier_block *this, unsigned long code, void *unused)
+static int wdt_gpi_notify(struct notifier_block *this, unsigned long code,
+			  void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_gpi_stop();
@@ -333,9 +336,8 @@ wdt_gpi_notify(struct notifier_block *this, unsigned long code, void *unused)
 
 
 /* Init & exit procedures */
-static const struct resource *
-wdt_gpi_get_resource(struct platform_device *pdv, const char *name,
-		      unsigned int type)
+static const struct resource *wdt_gpi_get_resource(struct platform_device *pdv,
+					const char *name, unsigned int type)
 {
 	char buf[80];
 	if (snprintf(buf, sizeof buf, "%s_0", name) >= sizeof buf)
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 97b4a2e..44bf5e4 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -305,8 +305,6 @@ static long s3c2410wdt_ioctl(struct file *file,	unsigned int cmd,
 	int new_margin;
 
 	switch (cmd) {
-	default:
-		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &s3c2410_wdt_ident,
 			sizeof(s3c2410_wdt_ident)) ? -EFAULT : 0;
@@ -325,6 +323,8 @@ static long s3c2410wdt_ioctl(struct file *file,	unsigned int cmd,
 		return put_user(tmr_margin, p);
 	case WDIOC_GETTIMEOUT:
 		return put_user(tmr_margin, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index 34a2b3b..27d6898 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -26,13 +26,13 @@
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
+#include <linux/uaccess.h>
 
 #ifdef CONFIG_ARCH_PXA
 #include <asm/arch/pxa-regs.h>
 #endif
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
 
 #define OSCR_FREQ		CLOCK_TICK_RATE
 
@@ -45,7 +45,7 @@ static int boot_status;
  */
 static int sa1100dog_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(1,&sa1100wdt_users))
+	if (test_and_set_bit(1, &sa1100wdt_users))
 		return -EBUSY;
 
 	/* Activate SA1100 Watchdog timer */
@@ -66,28 +66,27 @@ static int sa1100dog_open(struct inode *inode, struct file *file)
 static int sa1100dog_release(struct inode *inode, struct file *file)
 {
 	printk(KERN_CRIT "WATCHDOG: Device closed - timer will not stop\n");
-
 	clear_bit(1, &sa1100wdt_users);
-
 	return 0;
 }
 
-static ssize_t sa1100dog_write(struct file *file, const char __user *data, size_t len, loff_t *ppos)
+static ssize_t sa1100dog_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
 {
 	if (len)
 		/* Refresh OSMR3 timer. */
 		OSMR3 = OSCR + pre_margin;
-
 	return len;
 }
 
-static struct watchdog_info ident = {
-	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+static const struct watchdog_info ident = {
+	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT
+				| WDIOF_KEEPALIVEPING,
 	.identity	= "SA1100/PXA255 Watchdog",
 };
 
-static int sa1100dog_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long sa1100dog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -108,6 +107,11 @@ static int sa1100dog_ioctl(struct inode *inode, struct file *file,
 		ret = put_user(boot_status, p);
 		break;
 
+	case WDIOC_KEEPALIVE:
+		OSMR3 = OSCR + pre_margin;
+		ret = 0;
+		break;
+
 	case WDIOC_SETTIMEOUT:
 		ret = get_user(time, p);
 		if (ret)
@@ -125,27 +129,20 @@ static int sa1100dog_ioctl(struct inode *inode, struct file *file,
 	case WDIOC_GETTIMEOUT:
 		ret = put_user(pre_margin / OSCR_FREQ, p);
 		break;
-
-	case WDIOC_KEEPALIVE:
-		OSMR3 = OSCR + pre_margin;
-		ret = 0;
-		break;
 	}
 	return ret;
 }
 
-static const struct file_operations sa1100dog_fops =
-{
+static const struct file_operations sa1100dog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sa1100dog_write,
-	.ioctl		= sa1100dog_ioctl,
+	.unlocked_ioctl	= sa1100dog_ioctl,
 	.open		= sa1100dog_open,
 	.release	= sa1100dog_release,
 };
 
-static struct miscdevice sa1100dog_miscdev =
-{
+static struct miscdevice sa1100dog_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &sa1100dog_fops,
@@ -167,8 +164,9 @@ static int __init sa1100dog_init(void)
 
 	ret = misc_register(&sa1100dog_miscdev);
 	if (ret == 0)
-		printk("SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
-		       margin);
+		printk(KERN_INFO
+			"SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
+						margin);
 	return ret;
 }
 
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index b944314..27e526a 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -57,6 +57,7 @@
 #include <asm/sibyte/sb1250_int.h>
 #include <asm/sibyte/sb1250_scd.h>
 
+static DEFINE_SPINLOCK(sbwd_lock);
 
 /*
  * set the initial count value of a timer
@@ -65,8 +66,10 @@
  */
 void sbwdog_set(char __iomem *wdog, unsigned long t)
 {
+	spin_lock(&sbwd_lock);
 	__raw_writeb(0, wdog - 0x10);
 	__raw_writeq(t & 0x7fffffUL, wdog);
+	spin_unlock(&sbwd_lock);
 }
 
 /*
@@ -77,7 +80,9 @@ void sbwdog_set(char __iomem *wdog, unsigned long t)
  */
 void sbwdog_pet(char __iomem *wdog)
 {
+	spin_lock(&sbwd_lock);
 	__raw_writeb(__raw_readb(wdog) | 1, wdog);
+	spin_unlock(&sbwd_lock);
 }
 
 static unsigned long sbwdog_gate; /* keeps it to one thread only */
@@ -86,8 +91,9 @@ static char __iomem *user_dog = (char __iomem *)(IO_BASE + (A_SCD_WDOG_CFG_1));
 static unsigned long timeout = 0x7fffffUL;	/* useconds: 8.3ish secs. */
 static int expect_close;
 
-static struct watchdog_info ident = {
-	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+static const struct watchdog_info ident = {
+	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT |
+						WDIOF_KEEPALIVEPING,
 	.identity	= "SiByte Watchdog",
 };
 
@@ -97,9 +103,8 @@ static struct watchdog_info ident = {
 static int sbwdog_open(struct inode *inode, struct file *file)
 {
 	nonseekable_open(inode, file);
-	if (test_and_set_bit(0, &sbwdog_gate)) {
+	if (test_and_set_bit(0, &sbwdog_gate))
 		return -EBUSY;
-	}
 	__module_get(THIS_MODULE);
 
 	/*
@@ -120,8 +125,9 @@ static int sbwdog_release(struct inode *inode, struct file *file)
 		__raw_writeb(0, user_dog);
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT "%s: Unexpected close, not stopping watchdog!\n",
-			ident.identity);
+		printk(KERN_CRIT
+			"%s: Unexpected close, not stopping watchdog!\n",
+						ident.identity);
 		sbwdog_pet(user_dog);
 	}
 	clear_bit(0, &sbwdog_gate);
@@ -147,12 +153,10 @@ static ssize_t sbwdog_write(struct file *file, const char __user *data,
 		for (i = 0; i != len; i++) {
 			char c;
 
-			if (get_user(c, data + i)) {
+			if (get_user(c, data + i))
 				return -EFAULT;
-			}
-			if (c == 'V') {
+			if (c == 'V')
 				expect_close = 42;
-			}
 		}
 		sbwdog_pet(user_dog);
 	}
@@ -160,8 +164,8 @@ static ssize_t sbwdog_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int sbwdog_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long sbwdog_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int ret = -ENOTTY;
 	unsigned long time;
@@ -178,11 +182,15 @@ static int sbwdog_ioctl(struct inode *inode, struct file *file,
 		ret = put_user(0, p);
 		break;
 
+	case WDIOC_KEEPALIVE:
+		sbwdog_pet(user_dog);
+		ret = 0;
+		break;
+
 	case WDIOC_SETTIMEOUT:
 		ret = get_user(time, p);
-		if (ret) {
+		if (ret)
 			break;
-		}
 
 		time *= 1000000;
 		if (time > 0x7fffffUL) {
@@ -200,11 +208,6 @@ static int sbwdog_ioctl(struct inode *inode, struct file *file,
 		 */
 		ret = put_user(__raw_readq(user_dog - 8) / 1000000, p);
 		break;
-
-	case WDIOC_KEEPALIVE:
-		sbwdog_pet(user_dog);
-		ret = 0;
-		break;
 	}
 	return ret;
 }
@@ -212,8 +215,8 @@ static int sbwdog_ioctl(struct inode *inode, struct file *file,
 /*
  *	Notifier for system down
  */
-static int
-sbwdog_notify_sys(struct notifier_block *this, unsigned long code, void *erf)
+static int sbwdog_notify_sys(struct notifier_block *this, unsigned long code,
+								void *erf)
 {
 	if (code == SYS_DOWN || code == SYS_HALT) {
 		/*
@@ -226,18 +229,16 @@ sbwdog_notify_sys(struct notifier_block *this, unsigned long code, void *erf)
 	return NOTIFY_DONE;
 }
 
-static const struct file_operations sbwdog_fops =
-{
+static const struct file_operations sbwdog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sbwdog_write,
-	.ioctl		= sbwdog_ioctl,
+	.unlocked_ioctl	= sbwdog_ioctl,
 	.open		= sbwdog_open,
 	.release	= sbwdog_release,
 };
 
-static struct miscdevice sbwdog_miscdev =
-{
+static struct miscdevice sbwdog_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &sbwdog_fops,
@@ -267,13 +268,12 @@ irqreturn_t sbwdog_interrupt(int irq, void *addr)
 	/*
 	 * if it's the second watchdog timer, it's for those users
 	 */
-	if (wd_cfg_reg == user_dog) {
+	if (wd_cfg_reg == user_dog)
 		printk(KERN_CRIT
 			"%s in danger of initiating system reset in %ld.%01ld seconds\n",
 			ident.identity, wd_init / 1000000, (wd_init / 100000) % 10);
-	} else {
+	else
 		cfg |= 1;
-	}
 
 	__raw_writeb(cfg, wd_cfg_reg);
 
@@ -289,28 +289,31 @@ static int __init sbwdog_init(void)
 	 */
 	ret = register_reboot_notifier(&sbwdog_notifier);
 	if (ret) {
-		printk (KERN_ERR "%s: cannot register reboot notifier (err=%d)\n",
-			ident.identity, ret);
+		printk(KERN_ERR
+			"%s: cannot register reboot notifier (err=%d)\n",
+						ident.identity, ret);
 		return ret;
 	}
 
 	/*
 	 * get the resources
 	 */
-	ret = misc_register(&sbwdog_miscdev);
-	if (ret == 0) {
-		printk(KERN_INFO "%s: timeout is %ld.%ld secs\n", ident.identity,
-			timeout / 1000000, (timeout / 100000) % 10);
-	}
 
 	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
 		ident.identity, (void *)user_dog);
 	if (ret) {
-		printk(KERN_ERR "%s: failed to request irq 1 - %d\n", ident.identity,
-			ret);
-		misc_deregister(&sbwdog_miscdev);
+		printk(KERN_ERR "%s: failed to request irq 1 - %d\n",
+						ident.identity, ret);
+		return ret;
 	}
 
+	ret = misc_register(&sbwdog_miscdev);
+	if (ret == 0) {
+		printk(KERN_INFO "%s: timeout is %ld.%ld secs\n",
+				ident.identity,
+				timeout / 1000000, (timeout / 100000) % 10);
+	} else
+		free_irq(1, (void *)user_dog);
 	return ret;
 }
 
@@ -327,7 +330,7 @@ MODULE_DESCRIPTION("SiByte Watchdog");
 
 module_param(timeout, ulong, 0);
 MODULE_PARM_DESC(timeout,
-	"Watchdog timeout in microseconds (max/default 8388607 or 8.3ish secs)");
+      "Watchdog timeout in microseconds (max/default 8388607 or 8.3ish secs)");
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
@@ -336,16 +339,15 @@ MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
  * example code that can be put in a platform code area to utilize the
  * first watchdog timer for the kernels own purpose.
 
- void
-platform_wd_setup(void)
+void platform_wd_setup(void)
 {
 	int ret;
 
-	ret = request_irq(0, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
 		"Kernel Watchdog", IOADDR(A_SCD_WDOG_CFG_0));
 	if (ret) {
-		printk(KERN_CRIT "Watchdog IRQ zero(0) failed to be requested - %d\n",
-			ret);
+		printk(KERN_CRIT
+		  "Watchdog IRQ zero(0) failed to be requested - %d\n", ret);
 	}
 }
 
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index ef76f01..3266daa 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -16,19 +16,23 @@
  *
  *           12/4 - 2000      [Initial revision]
  *           25/4 - 2000      Added /dev/watchdog support
- *           09/5 - 2001      [smj@oro.net] fixed fop_write to "return 1" on success
+ *           09/5 - 2001      [smj@oro.net] fixed fop_write to "return 1"
+ *					on success
  *           12/4 - 2002      [rob@osinvestor.com] eliminate fop_read
  *                            fix possible wdt_is_open race
  *                            add CONFIG_WATCHDOG_NOWAYOUT support
  *                            remove lock_kernel/unlock_kernel pairs
  *                            added KERN_* to printk's
  *                            got rid of extraneous comments
- *                            changed watchdog_info to correctly reflect what the driver offers
- *                            added WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS, WDIOC_SETTIMEOUT,
- *                            WDIOC_GETTIMEOUT, and WDIOC_SETOPTIONS ioctls
+ *                            changed watchdog_info to correctly reflect what
+ *			      the driver offers
+ *			      added WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS,
+ *			      WDIOC_SETTIMEOUT, WDIOC_GETTIMEOUT, and
+ *			      WDIOC_SETOPTIONS ioctls
  *           09/8 - 2003      [wim@iguana.be] cleanup of trailing spaces
  *                            use module_param
- *                            made timeout (the emulated heartbeat) a module_param
+ *                            made timeout (the emulated heartbeat) a
+ *			      module_param
  *                            made the keepalive ping an internal subroutine
  *                            made wdt_stop and wdt_start module params
  *                            added extra printk's for startup problems
@@ -56,9 +60,9 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define OUR_NAME "sbc60xxwdt"
@@ -94,13 +98,18 @@ MODULE_PARM_DESC(wdt_start, "SBC60xx WDT 'start' io port (default 0x443)");
  */
 
 #define WATCHDOG_TIMEOUT 30		/* 30 sec default timeout */
-static int timeout = WATCHDOG_TIMEOUT;	/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+static int timeout = WATCHDOG_TIMEOUT;	/* in seconds, multiplied by HZ to
+					   get seconds to wait for a ping */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
 static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
@@ -117,15 +126,14 @@ static void wdt_timer_ping(unsigned long data)
 	/* If we got a heartbeat pulse within the WDT_US_INTERVAL
 	 * we agree to ping the WDT
 	 */
-	if(time_before(jiffies, next_heartbeat))
-	{
+	if (time_before(jiffies, next_heartbeat)) {
 		/* Ping the WDT by reading from wdt_start */
 		inb_p(wdt_start);
 		/* Re-set the timer interval */
 		mod_timer(&timer, jiffies + WDT_INTERVAL);
-	} else {
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
-	}
+	} else
+		printk(KERN_WARNING PFX
+			"Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -159,40 +167,40 @@ static void wdt_keepalive(void)
  * /dev/watchdog handling
  */
 
-static ssize_t fop_write(struct file * file, const char __user * buf, size_t count, loff_t * ppos)
+static ssize_t fop_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count)
-	{
-		if (!nowayout)
-		{
+	if (count) {
+		if (!nowayout) {
 			size_t ofs;
 
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
+			/* note: just in case someone wrote the
+			   magic character five months ago... */
 			wdt_expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
-			for(ofs = 0; ofs != count; ofs++)
-			{
+			/* scan to see whether or not we got the
+			   magic character */
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
-				if(get_user(c, buf+ofs))
+				if (get_user(c, buf + ofs))
 					return -EFAULT;
-				if(c == 'V')
+				if (c == 'V')
 					wdt_expect_close = 42;
 			}
 		}
 
-		/* Well, anyhow someone wrote to us, we should return that favour */
+		/* Well, anyhow someone wrote to us, we should
+		   return that favour */
 		wdt_keepalive();
 	}
 	return count;
 }
 
-static int fop_open(struct inode * inode, struct file * file)
+static int fop_open(struct inode *inode, struct file *file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 
 	if (nowayout)
@@ -203,78 +211,72 @@ static int fop_open(struct inode * inode, struct file * file)
 	return nonseekable_open(inode, file);
 }
 
-static int fop_close(struct inode * inode, struct file * file)
+static int fop_close(struct inode *inode, struct file *file)
 {
-	if(wdt_expect_close == 42)
+	if (wdt_expect_close == 42)
 		wdt_turnoff();
 	else {
 		del_timer(&timer);
-		printk(KERN_CRIT PFX "device file closed unexpectedly. Will not stop the WDT!\n");
+		printk(KERN_CRIT PFX
+		  "device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
 	return 0;
 }
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident=
-	{
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+							WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "SBC60xx",
 	};
 
-	switch(cmd)
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
 	{
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident))?-EFAULT:0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			wdt_keepalive();
-			return 0;
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
-
-			if(get_user(new_options, p))
-				return -EFAULT;
-
-			if(new_options & WDIOS_DISABLECARD) {
-				wdt_turnoff();
-				retval = 0;
-			}
-
-			if(new_options & WDIOS_ENABLECARD) {
-				wdt_startup();
-				retval = 0;
-			}
-
-			return retval;
+		int new_options, retval = -EINVAL;
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			wdt_turnoff();
+			retval = 0;
 		}
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_timeout;
-
-			if(get_user(new_timeout, p))
-				return -EFAULT;
-
-			if(new_timeout < 1 || new_timeout > 3600) /* arbitrary upper limit */
-				return -EINVAL;
-
-			timeout = new_timeout;
-			wdt_keepalive();
-			/* Fall through */
+		if (new_options & WDIOS_ENABLECARD) {
+			wdt_startup();
+			retval = 0;
 		}
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		/* arbitrary upper limit */
+		if (new_timeout < 1 || new_timeout > 3600)
+			return -EINVAL;
+
+		timeout = new_timeout;
+		wdt_keepalive();
+		/* Fall through */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -284,7 +286,7 @@ static const struct file_operations wdt_fops = {
 	.write		= fop_write,
 	.open		= fop_open,
 	.release	= fop_close,
-	.ioctl		= fop_ioctl,
+	.unlocked_ioctl	= fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
@@ -300,7 +302,7 @@ static struct miscdevice wdt_miscdev = {
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 	return NOTIFY_DONE;
 }
@@ -310,8 +312,7 @@ static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
  *	turn the timebomb registers off.
  */
 
-static struct notifier_block wdt_notifier=
-{
+static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
@@ -324,23 +325,22 @@ static void __exit sbc60xxwdt_unload(void)
 
 	unregister_reboot_notifier(&wdt_notifier);
 	if ((wdt_stop != 0x45) && (wdt_stop != wdt_start))
-		release_region(wdt_stop,1);
-	release_region(wdt_start,1);
+		release_region(wdt_stop, 1);
+	release_region(wdt_start, 1);
 }
 
 static int __init sbc60xxwdt_init(void)
 {
 	int rc = -EBUSY;
 
-	if(timeout < 1 || timeout > 3600) /* arbitrary upper limit */
-	{
+	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX "timeout value must be 1<=x<=3600, using %d\n",
-			timeout);
- 	}
+		printk(KERN_INFO PFX
+			"timeout value must be 1 <= x <= 3600, using %d\n",
+								timeout);
+	}
 
-	if (!request_region(wdt_start, 1, "SBC 60XX WDT"))
-	{
+	if (!request_region(wdt_start, 1, "SBC 60XX WDT")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		rc = -EIO;
@@ -348,33 +348,30 @@ static int __init sbc60xxwdt_init(void)
 	}
 
 	/* We cannot reserve 0x45 - the kernel already has! */
-	if ((wdt_stop != 0x45) && (wdt_stop != wdt_start))
-	{
-		if (!request_region(wdt_stop, 1, "SBC 60XX WDT"))
-		{
-			printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				wdt_stop);
+	if (wdt_stop != 0x45 && wdt_stop != wdt_start) {
+		if (!request_region(wdt_stop, 1, "SBC 60XX WDT")) {
+			printk(KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+							wdt_stop);
 			rc = -EIO;
 			goto err_out_region1;
 		}
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region2;
 	}
 
 	rc = misc_register(&wdt_miscdev);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
-
 	printk(KERN_INFO PFX "WDT driver for 60XX single board computer initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
@@ -383,10 +380,10 @@ static int __init sbc60xxwdt_init(void)
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out_region2:
-	if ((wdt_stop != 0x45) && (wdt_stop != wdt_start))
-		release_region(wdt_stop,1);
+	if (wdt_stop != 0x45 && wdt_stop != wdt_start)
+		release_region(wdt_stop, 1);
 err_out_region1:
-	release_region(wdt_start,1);
+	release_region(wdt_start, 1);
 err_out:
 	return rc;
 }
diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
index 4c8cefb..67ddeb1 100644
--- a/drivers/watchdog/sbc7240_wdt.c
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -27,10 +27,10 @@
 #include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/atomic.h>
-#include <asm/io.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define SBC7240_PREFIX "sbc7240_wdt: "
 
@@ -159,7 +159,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options = WDIOF_KEEPALIVEPING|
 		   WDIOF_SETTIMEOUT|
 		   WDIOF_MAGICCLOSE,
@@ -168,50 +168,50 @@ static struct watchdog_info ident = {
 };
 
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		     unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		return copy_to_user
-			((void __user *)arg, &ident, sizeof(ident))
-			 ? -EFAULT : 0;
+		return copy_to_user((void __user *)arg, &ident, sizeof(ident))
+						 ? -EFAULT : 0;
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, (int __user *)arg);
-	case WDIOC_KEEPALIVE:
-		wdt_keepalive();
-		return 0;
-	case WDIOC_SETOPTIONS:{
-			int options;
-			int retval = -EINVAL;
+	case WDIOC_SETOPTIONS:
+	{
+		int options;
+		int retval = -EINVAL;
 
-			if (get_user(options, (int __user *)arg))
-				return -EFAULT;
+		if (get_user(options, (int __user *)arg))
+			return -EFAULT;
 
-			if (options & WDIOS_DISABLECARD) {
-				wdt_disable();
-				retval = 0;
-			}
-
-			if (options & WDIOS_ENABLECARD) {
-				wdt_enable();
-				retval = 0;
-			}
+		if (options & WDIOS_DISABLECARD) {
+			wdt_disable();
+			retval = 0;
+		}
 
-			return retval;
+		if (options & WDIOS_ENABLECARD) {
+			wdt_enable();
+			retval = 0;
 		}
-	case WDIOC_SETTIMEOUT:{
-			int new_timeout;
 
-			if (get_user(new_timeout, (int __user *)arg))
-				return -EFAULT;
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
 
-			if (wdt_set_timeout(new_timeout))
-				return -EINVAL;
+		if (get_user(new_timeout, (int __user *)arg))
+			return -EFAULT;
 
-			/* Fall through */
-		}
+		if (wdt_set_timeout(new_timeout))
+			return -EINVAL;
+
+		/* Fall through */
+	}
 	case WDIOC_GETTIMEOUT:
 		return put_user(timeout, (int __user *)arg);
 	default:
@@ -225,7 +225,7 @@ static const struct file_operations wdt_fops = {
 	.write = fop_write,
 	.open = fop_open,
 	.release = fop_close,
-	.ioctl = fop_ioctl,
+	.unlocked_ioctl = fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index 2ee2677..fd83dd0 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -48,13 +48,12 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/moduleparam.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static unsigned long sbc8360_is_open;
-static DEFINE_SPINLOCK(sbc8360_lock);
 static char expect_close;
 
 #define PFX "sbc8360: "
@@ -204,7 +203,8 @@ module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Index into timeout table (0-63) (default=27 (60s))");
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout,
-		 "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+		 "Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Kernel methods.
@@ -231,9 +231,16 @@ static void sbc8360_ping(void)
 	outb(wd_margin, SBC8360_BASETIME);
 }
 
+/* stop watchdog */
+static void sbc8360_stop(void)
+{
+	/* De-activate the watchdog */
+	outb(0, SBC8360_ENABLE);
+}
+
 /* Userspace pings kernel driver, or requests clean close */
-static ssize_t sbc8360_write(struct file *file, const char __user * buf,
-			     size_t count, loff_t * ppos)
+static ssize_t sbc8360_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -257,16 +264,12 @@ static ssize_t sbc8360_write(struct file *file, const char __user * buf,
 
 static int sbc8360_open(struct inode *inode, struct file *file)
 {
-	spin_lock(&sbc8360_lock);
-	if (test_and_set_bit(0, &sbc8360_is_open)) {
-		spin_unlock(&sbc8360_lock);
+	if (test_and_set_bit(0, &sbc8360_is_open))
 		return -EBUSY;
-	}
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
 	/* Activate and ping once to start the countdown */
-	spin_unlock(&sbc8360_lock);
 	sbc8360_activate();
 	sbc8360_ping();
 	return nonseekable_open(inode, file);
@@ -274,16 +277,14 @@ static int sbc8360_open(struct inode *inode, struct file *file)
 
 static int sbc8360_close(struct inode *inode, struct file *file)
 {
-	spin_lock(&sbc8360_lock);
 	if (expect_close == 42)
-		outb(0, SBC8360_ENABLE);
+		sbc8360_stop();
 	else
 		printk(KERN_CRIT PFX
-		       "SBC8360 device closed unexpectedly.  SBC8360 will not stop!\n");
+			"SBC8360 device closed unexpectedly.  SBC8360 will not stop!\n");
 
 	clear_bit(0, &sbc8360_is_open);
 	expect_close = 0;
-	spin_unlock(&sbc8360_lock);
 	return 0;
 }
 
@@ -294,10 +295,9 @@ static int sbc8360_close(struct inode *inode, struct file *file)
 static int sbc8360_notify_sys(struct notifier_block *this, unsigned long code,
 			      void *unused)
 {
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		/* Disable the SBC8360 Watchdog */
-		outb(0, SBC8360_ENABLE);
-	}
+	if (code == SYS_DOWN || code == SYS_HALT)
+		sbc8360_stop();	/* Disable the SBC8360 Watchdog */
+
 	return NOTIFY_DONE;
 }
 
@@ -382,13 +382,13 @@ static int __init sbc8360_init(void)
 
 	return 0;
 
-      out_nomisc:
+out_nomisc:
 	unregister_reboot_notifier(&sbc8360_notifier);
-      out_noreboot:
+out_noreboot:
 	release_region(SBC8360_BASETIME, 1);
-      out_nobasetimereg:
+out_nobasetimereg:
 	release_region(SBC8360_ENABLE, 1);
-      out:
+out:
 	return res;
 }
 
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index 82cbd88..e5e470c 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -25,8 +25,8 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define PFX "epx_c3: "
 static int epx_c3_alive;
@@ -100,12 +100,12 @@ static ssize_t epx_c3_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int epx_c3_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long epx_c3_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	int __user *argp = (void __user *)arg;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options		= WDIOF_KEEPALIVEPING |
 					  WDIOF_MAGICCLOSE,
 		.firmware_version	= 0,
@@ -120,11 +120,6 @@ static int epx_c3_ioctl(struct inode *inode, struct file *file,
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, argp);
-	case WDIOC_KEEPALIVE:
-		epx_c3_pet();
-		return 0;
-	case WDIOC_GETTIMEOUT:
-		return put_user(WATCHDOG_TIMEOUT, argp);
 	case WDIOC_SETOPTIONS:
 		if (get_user(options, argp))
 			return -EFAULT;
@@ -140,6 +135,11 @@ static int epx_c3_ioctl(struct inode *inode, struct file *file,
 		}
 
 		return retval;
+	case WDIOC_KEEPALIVE:
+		epx_c3_pet();
+		return 0;
+	case WDIOC_GETTIMEOUT:
+		return put_user(WATCHDOG_TIMEOUT, argp);
 	default:
 		return -ENOTTY;
 	}
@@ -158,7 +158,7 @@ static const struct file_operations epx_c3_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= epx_c3_write,
-	.ioctl		= epx_c3_ioctl,
+	.unlocked_ioctl	= epx_c3_ioctl,
 	.open		= epx_c3_open,
 	.release	= epx_c3_release,
 };
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index 621ebad..23da3cc 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -196,7 +196,6 @@ static long sc1200wdt_ioctl(struct file *file, unsigned int cmd,
 	};
 
 	switch (cmd) {
-
 	case WDIOC_GETSUPPORT:
 		if (copy_to_user(argp, &ident, sizeof ident))
 			return -EFAULT;
@@ -208,24 +207,6 @@ static long sc1200wdt_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 
-	case WDIOC_KEEPALIVE:
-		sc1200wdt_write_data(WDTO, timeout);
-		return 0;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_timeout, p))
-			return -EFAULT;
-		/* the API states this is given in secs */
-		new_timeout /= 60;
-		if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
-			return -EINVAL;
-		timeout = new_timeout;
-		sc1200wdt_write_data(WDTO, timeout);
-		/* fall through and return the new timeout */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout * 60, p);
-
 	case WDIOC_SETOPTIONS:
 	{
 		int options, retval = -EINVAL;
@@ -245,6 +226,24 @@ static long sc1200wdt_ioctl(struct file *file, unsigned int cmd,
 
 		return retval;
 	}
+	case WDIOC_KEEPALIVE:
+		sc1200wdt_write_data(WDTO, timeout);
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		/* the API states this is given in secs */
+		new_timeout /= 60;
+		if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
+			return -EINVAL;
+		timeout = new_timeout;
+		sc1200wdt_write_data(WDTO, timeout);
+		/* fall through and return the new timeout */
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout * 60, p);
+
 	default:
 		return -ENOTTY;
 	}
@@ -280,7 +279,7 @@ static ssize_t sc1200wdt_write(struct file *file, const char __user *data,
 			for (i = 0; i != len; i++) {
 				char c;
 
-				if (get_user(c, data+i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_close = 42;
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index 2847324..a2b6c10 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -64,9 +64,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define OUR_NAME "sc520_wdt"
@@ -91,13 +91,18 @@
  */
 
 #define WATCHDOG_TIMEOUT 30		/* 30 sec default timeout */
-static int timeout = WATCHDOG_TIMEOUT;	/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1 <= timeout <= 3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * AMD Elan SC520 - Watchdog Timer Registers
@@ -136,8 +141,7 @@ static void wdt_timer_ping(unsigned long data)
 	/* If we got a heartbeat pulse within the WDT_US_INTERVAL
 	 * we agree to ping the WDT
 	 */
-	if(time_before(jiffies, next_heartbeat))
-	{
+	if (time_before(jiffies, next_heartbeat)) {
 		/* Ping the WDT */
 		spin_lock(&wdt_spinlock);
 		writew(0xAAAA, wdtmrctl);
@@ -146,9 +150,9 @@ static void wdt_timer_ping(unsigned long data)
 
 		/* Re-set the timer interval */
 		mod_timer(&timer, jiffies + WDT_INTERVAL);
-	} else {
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
-	}
+	} else
+		printk(KERN_WARNING PFX
+			"Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -162,7 +166,7 @@ static void wdt_config(int writeval)
 
 	/* buy some time (ping) */
 	spin_lock_irqsave(&wdt_spinlock, flags);
-	dummy=readw(wdtmrctl);	/* ensure write synchronization */
+	dummy = readw(wdtmrctl);	/* ensure write synchronization */
 	writew(0xAAAA, wdtmrctl);
 	writew(0x5555, wdtmrctl);
 	/* unlock WDT = make WDT configuration register writable one time */
@@ -219,10 +223,11 @@ static int wdt_set_heartbeat(int t)
  *	/dev/watchdog handling
  */
 
-static ssize_t fop_write(struct file * file, const char __user * buf, size_t count, loff_t * ppos)
+static ssize_t fop_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count) {
+	if (count) {
 		if (!nowayout) {
 			size_t ofs;
 
@@ -231,25 +236,26 @@ static ssize_t fop_write(struct file * file, const char __user * buf, size_t cou
 			wdt_expect_close = 0;
 
 			/* now scan */
-			for(ofs = 0; ofs != count; ofs++) {
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
 				if (get_user(c, buf + ofs))
 					return -EFAULT;
-				if(c == 'V')
+				if (c == 'V')
 					wdt_expect_close = 42;
 			}
 		}
 
-		/* Well, anyhow someone wrote to us, we should return that favour */
+		/* Well, anyhow someone wrote to us, we should
+		   return that favour */
 		wdt_keepalive();
 	}
 	return count;
 }
 
-static int fop_open(struct inode * inode, struct file * file)
+static int fop_open(struct inode *inode, struct file *file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 	if (nowayout)
 		__module_get(THIS_MODULE);
@@ -259,12 +265,13 @@ static int fop_open(struct inode * inode, struct file * file)
 	return nonseekable_open(inode, file);
 }
 
-static int fop_close(struct inode * inode, struct file * file)
+static int fop_close(struct inode *inode, struct file *file)
 {
-	if(wdt_expect_close == 42) {
+	if (wdt_expect_close == 42)
 		wdt_turnoff();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		wdt_keepalive();
 	}
 	clear_bit(0, &wdt_is_open);
@@ -272,63 +279,62 @@ static int fop_close(struct inode * inode, struct file * file)
 	return 0;
 }
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "SC520",
 	};
 
-	switch(cmd)
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
 	{
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident))?-EFAULT:0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			wdt_keepalive();
-			return 0;
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
-
-			if(get_user(new_options, p))
-				return -EFAULT;
-
-			if(new_options & WDIOS_DISABLECARD) {
-				wdt_turnoff();
-				retval = 0;
-			}
+		int new_options, retval = -EINVAL;
 
-			if(new_options & WDIOS_ENABLECARD) {
-				wdt_startup();
-				retval = 0;
-			}
+		if (get_user(new_options, p))
+			return -EFAULT;
 
-			return retval;
+		if (new_options & WDIOS_DISABLECARD) {
+			wdt_turnoff();
+			retval = 0;
 		}
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_timeout;
 
-			if(get_user(new_timeout, p))
-				return -EFAULT;
+		if (new_options & WDIOS_ENABLECARD) {
+			wdt_startup();
+			retval = 0;
+		}
 
-			if(wdt_set_heartbeat(new_timeout))
-				return -EINVAL;
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
 
-			wdt_keepalive();
-			/* Fall through */
-		}
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+
+		if (wdt_set_heartbeat(new_timeout))
+			return -EINVAL;
+
+		wdt_keepalive();
+		/* Fall through */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -338,7 +344,7 @@ static const struct file_operations wdt_fops = {
 	.write		= fop_write,
 	.open		= fop_open,
 	.release	= fop_close,
-	.ioctl		= fop_ioctl,
+	.unlocked_ioctl	= fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
@@ -354,7 +360,7 @@ static struct miscdevice wdt_miscdev = {
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 	return NOTIFY_DONE;
 }
@@ -383,11 +389,13 @@ static int __init sc520_wdt_init(void)
 {
 	int rc = -EBUSY;
 
-	/* Check that the timeout value is within it's range ; if not reset to the default */
+	/* Check that the timeout value is within it's range ;
+	   if not reset to the default */
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX "timeout value must be 1<=timeout<=3600, using %d\n",
-			WATCHDOG_TIMEOUT);
+		printk(KERN_INFO PFX
+		    "timeout value must be 1 <= timeout <= 3600, using %d\n",
+							WATCHDOG_TIMEOUT);
 	}
 
 	wdtmrctl = ioremap((unsigned long)(MMCR_BASE + OFFS_WDTMRCTL), 2);
@@ -399,20 +407,22 @@ static int __init sc520_wdt_init(void)
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_ioremap;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, rc);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, rc);
 		goto err_out_notifier;
 	}
 
-	printk(KERN_INFO PFX "WDT driver for SC520 initialised. timeout=%d sec (nowayout=%d)\n",
-		timeout,nowayout);
+	printk(KERN_INFO PFX
+	   "WDT driver for SC520 initialised. timeout=%d sec (nowayout=%d)\n",
+							timeout, nowayout);
 
 	return 0;
 
diff --git a/drivers/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
index d55882b..9e19a10 100644
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -27,9 +27,8 @@
 #include <linux/fs.h>
 #include <linux/ioport.h>
 #include <linux/scx200.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define NAME "scx200_wdt"
 
@@ -47,8 +46,9 @@ module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 
 static u16 wdto_restart;
-static struct semaphore open_semaphore;
 static char expect_close;
+static unsigned long open_lock;
+static DEFINE_SPINLOCK(scx_lock);
 
 /* Bits of the WDCNFG register */
 #define W_ENABLE 0x00fa		/* Enable watchdog */
@@ -59,7 +59,9 @@ static char expect_close;
 
 static void scx200_wdt_ping(void)
 {
+	spin_lock(&scx_lock);
 	outw(wdto_restart, scx200_cb_base + SCx200_WDT_WDTO);
+	spin_unlock(&scx_lock);
 }
 
 static void scx200_wdt_update_margin(void)
@@ -73,9 +75,11 @@ static void scx200_wdt_enable(void)
 	printk(KERN_DEBUG NAME ": enabling watchdog timer, wdto_restart = %d\n",
 	       wdto_restart);
 
+	spin_lock(&scx_lock);
 	outw(0, scx200_cb_base + SCx200_WDT_WDTO);
 	outb(SCx200_WDT_WDSTS_WDOVF, scx200_cb_base + SCx200_WDT_WDSTS);
 	outw(W_ENABLE, scx200_cb_base + SCx200_WDT_WDCNFG);
+	spin_unlock(&scx_lock);
 
 	scx200_wdt_ping();
 }
@@ -84,15 +88,17 @@ static void scx200_wdt_disable(void)
 {
 	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
 
+	spin_lock(&scx_lock);
 	outw(0, scx200_cb_base + SCx200_WDT_WDTO);
 	outb(SCx200_WDT_WDSTS_WDOVF, scx200_cb_base + SCx200_WDT_WDSTS);
 	outw(W_DISABLE, scx200_cb_base + SCx200_WDT_WDCNFG);
+	spin_unlock(&scx_lock);
 }
 
 static int scx200_wdt_open(struct inode *inode, struct file *file)
 {
 	/* only allow one at a time */
-	if (down_trylock(&open_semaphore))
+	if (test_and_set_bit(0, &open_lock))
 		return -EBUSY;
 	scx200_wdt_enable();
 
@@ -101,13 +107,12 @@ static int scx200_wdt_open(struct inode *inode, struct file *file)
 
 static int scx200_wdt_release(struct inode *inode, struct file *file)
 {
-	if (expect_close != 42) {
+	if (expect_close != 42)
 		printk(KERN_WARNING NAME ": watchdog device closed unexpectedly, will not disable the watchdog timer\n");
-	} else if (!nowayout) {
+	else if (!nowayout)
 		scx200_wdt_disable();
-	}
 	expect_close = 0;
-	up(&open_semaphore);
+	clear_bit(0, &open_lock);
 
 	return 0;
 }
@@ -122,8 +127,7 @@ static int scx200_wdt_notify_sys(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block scx200_wdt_notifier =
-{
+static struct notifier_block scx200_wdt_notifier = {
 	.notifier_call = scx200_wdt_notify_sys,
 };
 
@@ -131,8 +135,7 @@ static ssize_t scx200_wdt_write(struct file *file, const char __user *data,
 				     size_t len, loff_t *ppos)
 {
 	/* check for a magic close character */
-	if (len)
-	{
+	if (len) {
 		size_t i;
 
 		scx200_wdt_ping();
@@ -140,7 +143,7 @@ static ssize_t scx200_wdt_write(struct file *file, const char __user *data,
 		expect_close = 0;
 		for (i = 0; i < len; ++i) {
 			char c;
-			if (get_user(c, data+i))
+			if (get_user(c, data + i))
 				return -EFAULT;
 			if (c == 'V')
 				expect_close = 42;
@@ -152,23 +155,21 @@ static ssize_t scx200_wdt_write(struct file *file, const char __user *data,
 	return 0;
 }
 
-static int scx200_wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long scx200_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.identity = "NatSemi SCx200 Watchdog",
 		.firmware_version = 1,
-		.options = (WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING),
+		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	};
 	int new_margin;
 
 	switch (cmd) {
-	default:
-		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
-		if(copy_to_user(argp, &ident, sizeof(ident)))
+		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
 		return 0;
 	case WDIOC_GETSTATUS:
@@ -191,22 +192,24 @@ static int scx200_wdt_ioctl(struct inode *inode, struct file *file,
 		if (put_user(margin, p))
 			return -EFAULT;
 		return 0;
+	default:
+		return -ENOTTY;
 	}
 }
 
 static const struct file_operations scx200_wdt_fops = {
-	.owner	 = THIS_MODULE,
-	.llseek	 = no_llseek,
-	.write   = scx200_wdt_write,
-	.ioctl   = scx200_wdt_ioctl,
-	.open    = scx200_wdt_open,
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = scx200_wdt_write,
+	.unlocked_ioctl = scx200_wdt_ioctl,
+	.open = scx200_wdt_open,
 	.release = scx200_wdt_release,
 };
 
 static struct miscdevice scx200_wdt_miscdev = {
 	.minor = WATCHDOG_MINOR,
-	.name  = "watchdog",
-	.fops  = &scx200_wdt_fops,
+	.name = "watchdog",
+	.fops = &scx200_wdt_fops,
 };
 
 static int __init scx200_wdt_init(void)
@@ -229,8 +232,6 @@ static int __init scx200_wdt_init(void)
 	scx200_wdt_update_margin();
 	scx200_wdt_disable();
 
-	sema_init(&open_semaphore, 1);
-
 	r = register_reboot_notifier(&scx200_wdt_notifier);
 	if (r) {
 		printk(KERN_ERR NAME ": unable to register reboot notifier");
@@ -263,7 +264,7 @@ module_exit(scx200_wdt_cleanup);
 
 /*
     Local variables:
-        compile-command: "make -k -C ../.. SUBDIRS=drivers/char modules"
-        c-basic-offset: 8
+	compile-command: "make -k -C ../.. SUBDIRS=drivers/char modules"
+	c-basic-offset: 8
     End:
 */
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 1277f7e..824125a 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -28,9 +28,9 @@
 #include <linux/ioport.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/watchdog.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
 
 #define PFX "shwdt: "
 
@@ -72,6 +72,7 @@ static struct watchdog_info sh_wdt_info;
 static char shwdt_expect_close;
 static DEFINE_TIMER(timer, sh_wdt_ping, 0, 0);
 static unsigned long next_heartbeat;
+static DEFINE_SPINLOCK(shwdt_lock);
 
 #define WATCHDOG_HEARTBEAT 30			/* 30 sec default heartbeat */
 static int heartbeat = WATCHDOG_HEARTBEAT;	/* in seconds */
@@ -86,6 +87,9 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static void sh_wdt_start(void)
 {
 	__u8 csr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 
 	next_heartbeat = jiffies + (heartbeat * HZ);
 	mod_timer(&timer, next_ping_period(clock_division_ratio));
@@ -123,6 +127,7 @@ static void sh_wdt_start(void)
 	csr &= ~RSTCSR_RSTS;
 	sh_wdt_write_rstcsr(csr);
 #endif
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -132,12 +137,16 @@ static void sh_wdt_start(void)
 static void sh_wdt_stop(void)
 {
 	__u8 csr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 
 	del_timer(&timer);
 
 	csr = sh_wdt_read_csr();
 	csr &= ~WTCSR_TME;
 	sh_wdt_write_csr(csr);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -146,7 +155,11 @@ static void sh_wdt_stop(void)
  */
 static inline void sh_wdt_keepalive(void)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 	next_heartbeat = jiffies + (heartbeat * HZ);
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -155,10 +168,14 @@ static inline void sh_wdt_keepalive(void)
  */
 static int sh_wdt_set_heartbeat(int t)
 {
-	if (unlikely((t < 1) || (t > 3600))) /* arbitrary upper limit */
+	unsigned long flags;
+
+	if (unlikely(t < 1 || t > 3600)) /* arbitrary upper limit */
 		return -EINVAL;
 
+	spin_lock_irqsave(&wdt_lock, flags);
 	heartbeat = t;
+	spin_unlock_irqrestore(&wdt_lock, flags);
 	return 0;
 }
 
@@ -170,6 +187,9 @@ static int sh_wdt_set_heartbeat(int t)
  */
 static void sh_wdt_ping(unsigned long data)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdt_lock, flags);
 	if (time_before(jiffies, next_heartbeat)) {
 		__u8 csr;
 
@@ -183,6 +203,7 @@ static void sh_wdt_ping(unsigned long data)
 	} else
 		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping "
 		       "the watchdog\n");
+	spin_unlock_irqrestore(&wdt_lock, flags);
 }
 
 /**
@@ -310,7 +331,6 @@ static int sh_wdt_mmap(struct file *file, struct vm_area_struct *vma)
 
 /**
  * 	sh_wdt_ioctl - Query Device
- * 	@inode: inode of device
  * 	@file: file handle of device
  * 	@cmd: watchdog command
  * 	@arg: argument
@@ -318,53 +338,51 @@ static int sh_wdt_mmap(struct file *file, struct vm_area_struct *vma)
  * 	Query basic information from the device or ping it, as outlined by the
  * 	watchdog API.
  */
-static int sh_wdt_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long sh_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int new_heartbeat;
 	int options, retval = -EINVAL;
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user((struct watchdog_info *)arg,
-					  &sh_wdt_info,
-					  sizeof(sh_wdt_info)) ? -EFAULT : 0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, (int *)arg);
-		case WDIOC_KEEPALIVE:
-			sh_wdt_keepalive();
-			return 0;
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_heartbeat, (int *)arg))
-				return -EFAULT;
-
-			if (sh_wdt_set_heartbeat(new_heartbeat))
-				return -EINVAL;
-
-			sh_wdt_keepalive();
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, (int *)arg);
-		case WDIOC_SETOPTIONS:
-			if (get_user(options, (int *)arg))
-				return -EFAULT;
-
-			if (options & WDIOS_DISABLECARD) {
-				sh_wdt_stop();
-				retval = 0;
-			}
+	case WDIOC_GETSUPPORT:
+		return copy_to_user((struct watchdog_info *)arg,
+			  &sh_wdt_info, sizeof(sh_wdt_info)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int *)arg);
+	case WDIOC_SETOPTIONS:
+		if (get_user(options, (int *)arg))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD) {
+			sh_wdt_stop();
+			retval = 0;
+		}
 
-			if (options & WDIOS_ENABLECARD) {
-				sh_wdt_start();
-				retval = 0;
-			}
+		if (options & WDIOS_ENABLECARD) {
+			sh_wdt_start();
+			retval = 0;
+		}
 
-			return retval;
-		default:
-			return -ENOTTY;
-	}
+		return retval;
+	case WDIOC_KEEPALIVE:
+		sh_wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_heartbeat, (int *)arg))
+			return -EFAULT;
+
+		if (sh_wdt_set_heartbeat(new_heartbeat))
+			return -EINVAL;
 
+		sh_wdt_keepalive();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, (int *)arg);
+	default:
+		return -ENOTTY;
+	}
 	return 0;
 }
 
@@ -390,13 +408,13 @@ static const struct file_operations sh_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sh_wdt_write,
-	.ioctl		= sh_wdt_ioctl,
+	.unlocked_ioctl	= sh_wdt_ioctl,
 	.open		= sh_wdt_open,
 	.release	= sh_wdt_close,
 	.mmap		= sh_wdt_mmap,
 };
 
-static struct watchdog_info sh_wdt_info = {
+static const struct watchdog_info sh_wdt_info = {
 	.options		= WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
 				  WDIOF_MAGICCLOSE,
 	.firmware_version	= 1,
@@ -422,30 +440,33 @@ static int __init sh_wdt_init(void)
 {
 	int rc;
 
-	if ((clock_division_ratio < 0x5) || (clock_division_ratio > 0x7)) {
+	if (clock_division_ratio < 0x5 || clock_division_ratio > 0x7) {
 		clock_division_ratio = WTCSR_CKS_4096;
-		printk(KERN_INFO PFX "clock_division_ratio value must "
-		       "be 0x5<=x<=0x7, using %d\n", clock_division_ratio);
+		printk(KERN_INFO PFX
+		  "clock_division_ratio value must be 0x5<=x<=0x7, using %d\n",
+				clock_division_ratio);
 	}
 
 	rc = sh_wdt_set_heartbeat(heartbeat);
 	if (unlikely(rc)) {
 		heartbeat = WATCHDOG_HEARTBEAT;
-		printk(KERN_INFO PFX "heartbeat value must "
-		       "be 1<=x<=3600, using %d\n", heartbeat);
+		printk(KERN_INFO PFX
+			"heartbeat value must be 1<=x<=3600, using %d\n",
+								heartbeat);
 	}
 
 	rc = register_reboot_notifier(&sh_wdt_notifier);
 	if (unlikely(rc)) {
-		printk(KERN_ERR PFX "Can't register reboot notifier (err=%d)\n",
-		       rc);
+		printk(KERN_ERR PFX
+			"Can't register reboot notifier (err=%d)\n", rc);
 		return rc;
 	}
 
 	rc = misc_register(&sh_wdt_miscdev);
 	if (unlikely(rc)) {
-		printk(KERN_ERR PFX "Can't register miscdev on "
-		       "minor=%d (err=%d)\n", sh_wdt_miscdev.minor, rc);
+		printk(KERN_ERR PFX
+			"Can't register miscdev on minor=%d (err=%d)\n",
+						sh_wdt_miscdev.minor, rc);
 		unregister_reboot_notifier(&sh_wdt_notifier);
 		return rc;
 	}
@@ -476,10 +497,14 @@ module_param(clock_division_ratio, int, 0);
 MODULE_PARM_DESC(clock_division_ratio, "Clock division ratio. Valid ranges are from 0x5 (1.31ms) to 0x7 (5.25ms). (default=" __MODULE_STRING(clock_division_ratio) ")");
 
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (1<=heartbeat<=3600, default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+MODULE_PARM_DESC(heartbeat,
+	"Watchdog heartbeat in seconds. (1 <= heartbeat <= 3600, default="
+				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 module_init(sh_wdt_init);
 module_exit(sh_wdt_exit);
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 5d2b5ba..988ff1d 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -18,7 +18,7 @@
  *  History:
  *	2003 - Created version 1.0 for Linux 2.4.x.
  *	2006 - Ported to Linux 2.6, added nowayout and MAGICCLOSE
- *             features. Released version 1.1
+ *	       features. Released version 1.1
  *
  *  Theory of operation:
  *
@@ -55,9 +55,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 /* enable support for minutes as units? */
@@ -71,15 +71,15 @@
 #define UNIT_MINUTE     1
 
 #define MODNAME		"smsc37b787_wdt: "
-#define VERSION         "1.1"
+#define VERSION		"1.1"
 
-#define IOPORT          0x3F0
+#define IOPORT		0x3F0
 #define IOPORT_SIZE     2
-#define IODEV_NO        8
+#define IODEV_NO	8
 
-static int unit = UNIT_SECOND;  /* timer's unit */
-static int timeout = 60;        /* timeout value: default is 60 "units" */
-static unsigned long timer_enabled = 0;   /* is the timer enabled? */
+static int unit = UNIT_SECOND;	/* timer's unit */
+static int timeout = 60;	/* timeout value: default is 60 "units" */
+static unsigned long timer_enabled;   /* is the timer enabled? */
 
 static char expect_close;       /* is the close expected? */
 
@@ -93,114 +93,121 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 
 static inline void open_io_config(void)
 {
-        outb(0x55, IOPORT);
+	outb(0x55, IOPORT);
 	mdelay(1);
-        outb(0x55, IOPORT);
+	outb(0x55, IOPORT);
 }
 
 /* lock the IO chip */
 static inline void close_io_config(void)
 {
-        outb(0xAA, IOPORT);
+	outb(0xAA, IOPORT);
 }
 
 /* select the IO device */
 static inline void select_io_device(unsigned char devno)
 {
-        outb(0x07, IOPORT);
-        outb(devno, IOPORT+1);
+	outb(0x07, IOPORT);
+	outb(devno, IOPORT+1);
 }
 
 /* write to the control register */
 static inline void write_io_cr(unsigned char reg, unsigned char data)
 {
-        outb(reg, IOPORT);
-        outb(data, IOPORT+1);
+	outb(reg, IOPORT);
+	outb(data, IOPORT+1);
 }
 
 /* read from the control register */
 static inline char read_io_cr(unsigned char reg)
 {
-        outb(reg, IOPORT);
-        return inb(IOPORT+1);
+	outb(reg, IOPORT);
+	return inb(IOPORT+1);
 }
 
 /* -- Medium level functions ------------------------------------*/
 
 static inline void gpio_bit12(unsigned char reg)
 {
-	// -- General Purpose I/O Bit 1.2 --
-	// Bit 0,   In/Out: 0 = Output, 1 = Input
-	// Bit 1,   Polarity: 0 = No Invert, 1 = Invert
-	// Bit 2,   Group Enable Intr.: 0 = Disable, 1 = Enable
-	// Bit 3/4, Function select: 00 = GPI/O, 01 = WDT, 10 = P17,
-	//                           11 = Either Edge Triggered Intr. 2
-        // Bit 5/6  (Reserved)
-	// Bit 7,   Output Type: 0 = Push Pull Bit, 1 = Open Drain
-        write_io_cr(0xE2, reg);
+	/* -- General Purpose I/O Bit 1.2 --
+	 * Bit 0,   In/Out: 0 = Output, 1 = Input
+	 * Bit 1,   Polarity: 0 = No Invert, 1 = Invert
+	 * Bit 2,   Group Enable Intr.: 0 = Disable, 1 = Enable
+	 * Bit 3/4, Function select: 00 = GPI/O, 01 = WDT, 10 = P17,
+	 *                           11 = Either Edge Triggered Intr. 2
+	 * Bit 5/6  (Reserved)
+	 * Bit 7,   Output Type: 0 = Push Pull Bit, 1 = Open Drain
+	 */
+	write_io_cr(0xE2, reg);
 }
 
 static inline void gpio_bit13(unsigned char reg)
 {
-	// -- General Purpose I/O Bit 1.3 --
-	// Bit 0,  In/Out: 0 = Output, 1 = Input
-	// Bit 1,  Polarity: 0 = No Invert, 1 = Invert
-	// Bit 2,  Group Enable Intr.: 0 = Disable, 1 = Enable
-	// Bit 3,  Function select: 0 = GPI/O, 1 = LED
-        // Bit 4-6 (Reserved)
-	// Bit 7,  Output Type: 0 = Push Pull Bit, 1 = Open Drain
-        write_io_cr(0xE3, reg);
+	/* -- General Purpose I/O Bit 1.3 --
+	 * Bit 0,  In/Out: 0 = Output, 1 = Input
+	 * Bit 1,  Polarity: 0 = No Invert, 1 = Invert
+	 * Bit 2,  Group Enable Intr.: 0 = Disable, 1 = Enable
+	 * Bit 3,  Function select: 0 = GPI/O, 1 = LED
+	 * Bit 4-6 (Reserved)
+	 * Bit 7,  Output Type: 0 = Push Pull Bit, 1 = Open Drain
+	 */
+	write_io_cr(0xE3, reg);
 }
 
 static inline void wdt_timer_units(unsigned char new_units)
 {
-	// -- Watchdog timer units --
-	// Bit 0-6 (Reserved)
-	// Bit 7,  WDT Time-out Value Units Select
-	//         (0 = Minutes, 1 = Seconds)
-        write_io_cr(0xF1, new_units);
+	/* -- Watchdog timer units --
+	 * Bit 0-6 (Reserved)
+	 * Bit 7,  WDT Time-out Value Units Select
+	 *         (0 = Minutes, 1 = Seconds)
+	 */
+	write_io_cr(0xF1, new_units);
 }
 
 static inline void wdt_timeout_value(unsigned char new_timeout)
 {
-	// -- Watchdog Timer Time-out Value --
-	// Bit 0-7 Binary coded units (0=Disabled, 1..255)
-        write_io_cr(0xF2, new_timeout);
+	/* -- Watchdog Timer Time-out Value --
+	 * Bit 0-7 Binary coded units (0=Disabled, 1..255)
+	 */
+	write_io_cr(0xF2, new_timeout);
 }
 
 static inline void wdt_timer_conf(unsigned char conf)
 {
-	// -- Watchdog timer configuration --
-	// Bit 0   Joystick enable: 0* = No Reset, 1 = Reset WDT upon Gameport I/O
-	// Bit 1   Keyboard enable: 0* = No Reset, 1 = Reset WDT upon KBD Intr.
-	// Bit 2   Mouse enable: 0* = No Reset, 1 = Reset WDT upon Mouse Intr.
-        // Bit 3   Reset the timer
-        //         (Wrong in SMsC documentation? Given as: PowerLED Timout Enabled)
-	// Bit 4-7 WDT Interrupt Mapping: (0000* = Disabled,
-	//            0001=IRQ1, 0010=(Invalid), 0011=IRQ3 to 1111=IRQ15)
-        write_io_cr(0xF3, conf);
+	/* -- Watchdog timer configuration --
+	 * Bit 0   Joystick enable: 0* = No Reset, 1 = Reset WDT upon
+	 *							Gameport I/O
+	 * Bit 1   Keyboard enable: 0* = No Reset, 1 = Reset WDT upon KBD Intr.
+	 * Bit 2   Mouse enable: 0* = No Reset, 1 = Reset WDT upon Mouse Intr
+	 * Bit 3   Reset the timer
+	 *         (Wrong in SMsC documentation? Given as: PowerLED Timout
+	 *							Enabled)
+	 * Bit 4-7 WDT Interrupt Mapping: (0000* = Disabled,
+	 *            0001=IRQ1, 0010=(Invalid), 0011=IRQ3 to 1111=IRQ15)
+	 */
+	write_io_cr(0xF3, conf);
 }
 
 static inline void wdt_timer_ctrl(unsigned char reg)
 {
-	// -- Watchdog timer control --
-	// Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
-	// Bit 1   Power LED Toggle: 0 = Disable Toggle, 1 = Toggle at 1 Hz
-	// Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
-	// Bit 3   P20 Force Timeout enabled:
-	//          0 = P20 activity does not generate the WD timeout event
-	//          1 = P20 Allows rising edge of P20, from the keyboard
-	//              controller, to force the WD timeout event.
-	// Bit 4   (Reserved)
-	// -- Soft power management --
-	// Bit 5   Stop Counter: 1 = Stop software power down counter
-	//            set via register 0xB8, (self-cleaning)
-	//            (Upon read: 0 = Counter running, 1 = Counter stopped)
-	// Bit 6   Restart Counter: 1 = Restart software power down counter
-	//            set via register 0xB8, (self-cleaning)
-	// Bit 7   SPOFF: 1 = Force software power down (self-cleaning)
-
-        write_io_cr(0xF4, reg);
+	/* -- Watchdog timer control --
+	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
+	 * Bit 1   Power LED Toggle: 0 = Disable Toggle, 1 = Toggle at 1 Hz
+	 * Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
+	 * Bit 3   P20 Force Timeout enabled:
+	 *          0 = P20 activity does not generate the WD timeout event
+	 *          1 = P20 Allows rising edge of P20, from the keyboard
+	 *              controller, to force the WD timeout event.
+	 * Bit 4   (Reserved)
+	 * -- Soft power management --
+	 * Bit 5   Stop Counter: 1 = Stop software power down counter
+	 *            set via register 0xB8, (self-cleaning)
+	 *            (Upon read: 0 = Counter running, 1 = Counter stopped)
+	 * Bit 6   Restart Counter: 1 = Restart software power down counter
+	 *            set via register 0xB8, (self-cleaning)
+	 * Bit 7   SPOFF: 1 = Force software power down (self-cleaning)
+	 */
+	write_io_cr(0xF4, reg);
 }
 
 /* -- Higher level functions ------------------------------------*/
@@ -209,33 +216,34 @@ static inline void wdt_timer_ctrl(unsigned char reg)
 
 static void wb_smsc_wdt_initialize(void)
 {
-        unsigned char old;
+	unsigned char old;
 
 	spin_lock(&io_lock);
-        open_io_config();
-        select_io_device(IODEV_NO);
+	open_io_config();
+	select_io_device(IODEV_NO);
 
-	// enable the watchdog
-	gpio_bit13(0x08);  // Select pin 80 = LED not GPIO
-	gpio_bit12(0x0A);  // Set pin 79 = WDT not GPIO/Output/Polarity=Invert
+	/* enable the watchdog */
+	gpio_bit13(0x08);  /* Select pin 80 = LED not GPIO */
+	gpio_bit12(0x0A);  /* Set pin 79 = WDT not
+			      GPIO/Output/Polarity=Invert */
+	/* disable the timeout */
+	wdt_timeout_value(0);
 
-	// disable the timeout
-        wdt_timeout_value(0);
+	/* reset control register */
+	wdt_timer_ctrl(0x00);
 
-	// reset control register
-        wdt_timer_ctrl(0x00);
-
-	// reset configuration register
+	/* reset configuration register */
 	wdt_timer_conf(0x00);
 
-	// read old (timer units) register
-        old = read_io_cr(0xF1) & 0x7F;
-        if (unit == UNIT_SECOND) old |= 0x80; // set to seconds
+	/* read old (timer units) register */
+	old = read_io_cr(0xF1) & 0x7F;
+	if (unit == UNIT_SECOND)
+		old |= 0x80;	/* set to seconds */
 
-	// set the watchdog timer units
-        wdt_timer_units(old);
+	/* set the watchdog timer units */
+	wdt_timer_units(old);
 
-        close_io_config();
+	close_io_config();
 	spin_unlock(&io_lock);
 }
 
@@ -244,23 +252,23 @@ static void wb_smsc_wdt_initialize(void)
 static void wb_smsc_wdt_shutdown(void)
 {
 	spin_lock(&io_lock);
-        open_io_config();
-        select_io_device(IODEV_NO);
+	open_io_config();
+	select_io_device(IODEV_NO);
 
-	// disable the watchdog
-        gpio_bit13(0x09);
-        gpio_bit12(0x09);
+	/* disable the watchdog */
+	gpio_bit13(0x09);
+	gpio_bit12(0x09);
 
-	// reset watchdog config register
+	/* reset watchdog config register */
 	wdt_timer_conf(0x00);
 
-	// reset watchdog control register
-        wdt_timer_ctrl(0x00);
+	/* reset watchdog control register */
+	wdt_timer_ctrl(0x00);
 
-	// disable timeout
-        wdt_timeout_value(0x00);
+	/* disable timeout */
+	wdt_timeout_value(0x00);
 
-        close_io_config();
+	close_io_config();
 	spin_unlock(&io_lock);
 }
 
@@ -269,16 +277,16 @@ static void wb_smsc_wdt_shutdown(void)
 static void wb_smsc_wdt_set_timeout(unsigned char new_timeout)
 {
 	spin_lock(&io_lock);
-        open_io_config();
-        select_io_device(IODEV_NO);
+	open_io_config();
+	select_io_device(IODEV_NO);
 
-	// set Power LED to blink, if we enable the timeout
-        wdt_timer_ctrl((new_timeout == 0) ? 0x00 : 0x02);
+	/* set Power LED to blink, if we enable the timeout */
+	wdt_timer_ctrl((new_timeout == 0) ? 0x00 : 0x02);
 
-	// set timeout value
-        wdt_timeout_value(new_timeout);
+	/* set timeout value */
+	wdt_timeout_value(new_timeout);
 
-        close_io_config();
+	close_io_config();
 	spin_unlock(&io_lock);
 }
 
@@ -286,32 +294,32 @@ static void wb_smsc_wdt_set_timeout(unsigned char new_timeout)
 
 static unsigned char wb_smsc_wdt_get_timeout(void)
 {
-        unsigned char set_timeout;
+	unsigned char set_timeout;
 
 	spin_lock(&io_lock);
-        open_io_config();
-        select_io_device(IODEV_NO);
-        set_timeout = read_io_cr(0xF2);
-        close_io_config();
+	open_io_config();
+	select_io_device(IODEV_NO);
+	set_timeout = read_io_cr(0xF2);
+	close_io_config();
 	spin_unlock(&io_lock);
 
-        return set_timeout;
+	return set_timeout;
 }
 
 /* disable watchdog */
 
 static void wb_smsc_wdt_disable(void)
 {
-        // set the timeout to 0 to disable the watchdog
-        wb_smsc_wdt_set_timeout(0);
+	/* set the timeout to 0 to disable the watchdog */
+	wb_smsc_wdt_set_timeout(0);
 }
 
 /* enable watchdog by setting the current timeout */
 
 static void wb_smsc_wdt_enable(void)
 {
-        // set the current timeout...
-        wb_smsc_wdt_set_timeout(timeout);
+	/* set the current timeout... */
+	wb_smsc_wdt_set_timeout(timeout);
 }
 
 /* reset the timer */
@@ -319,14 +327,14 @@ static void wb_smsc_wdt_enable(void)
 static void wb_smsc_wdt_reset_timer(void)
 {
 	spin_lock(&io_lock);
-        open_io_config();
-        select_io_device(IODEV_NO);
+	open_io_config();
+	select_io_device(IODEV_NO);
 
-	// reset the timer
+	/* reset the timer */
 	wdt_timeout_value(timeout);
 	wdt_timer_conf(0x08);
 
-        close_io_config();
+	close_io_config();
 	spin_unlock(&io_lock);
 }
 
@@ -355,7 +363,9 @@ static int wb_smsc_wdt_open(struct inode *inode, struct file *file)
 	/* Reload and activate timer */
 	wb_smsc_wdt_enable();
 
-	printk(KERN_INFO MODNAME "Watchdog enabled. Timeout set to %d %s.\n", timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
+	printk(KERN_INFO MODNAME
+		"Watchdog enabled. Timeout set to %d %s.\n",
+		timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
 
 	return nonseekable_open(inode, file);
 }
@@ -367,10 +377,12 @@ static int wb_smsc_wdt_release(struct inode *inode, struct file *file)
 	/* Shut off the timer. */
 
 	if (expect_close == 42) {
-	        wb_smsc_wdt_disable();
-		printk(KERN_INFO MODNAME "Watchdog disabled, sleeping again...\n");
+		wb_smsc_wdt_disable();
+		printk(KERN_INFO MODNAME
+				"Watchdog disabled, sleeping again...\n");
 	} else {
-		printk(KERN_CRIT MODNAME "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT MODNAME
+				"Unexpected close, not stopping watchdog!\n");
 		wb_smsc_wdt_reset_timer();
 	}
 
@@ -392,10 +404,11 @@ static ssize_t wb_smsc_wdt_write(struct file *file, const char __user *data,
 			/* reset expect flag */
 			expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			   magic character */
 			for (i = 0; i != len; i++) {
 				char c;
-				if (get_user(c, data+i))
+				if (get_user(c, data + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_close = 42;
@@ -410,8 +423,8 @@ static ssize_t wb_smsc_wdt_write(struct file *file, const char __user *data,
 
 /* ioctl => control interface */
 
-static int wb_smsc_wdt_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long wb_smsc_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int new_timeout;
 
@@ -420,89 +433,73 @@ static int wb_smsc_wdt_ioctl(struct inode *inode, struct file *file,
 		int __user *i;
 	} uarg;
 
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options = 		WDIOF_KEEPALIVEPING |
-		                        WDIOF_SETTIMEOUT |
+					WDIOF_SETTIMEOUT |
 					WDIOF_MAGICCLOSE,
 		.firmware_version =	0,
-		.identity = 		"SMsC 37B787 Watchdog"
+		.identity = 		"SMsC 37B787 Watchdog",
 	};
 
 	uarg.i = (int __user *)arg;
 
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(uarg.ident, &ident,
-				sizeof(ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-			return put_user(wb_smsc_wdt_status(), uarg.i);
-
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, uarg.i);
-
-		case WDIOC_KEEPALIVE:
-			wb_smsc_wdt_reset_timer();
-			return 0;
-
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_timeout, uarg.i))
-				return -EFAULT;
-
-			// the API states this is given in secs
-			if (unit == UNIT_MINUTE)
-			  new_timeout /= 60;
-
-			if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
-				return -EINVAL;
-
-			timeout = new_timeout;
-			wb_smsc_wdt_set_timeout(timeout);
-
-			// fall through and return the new timeout...
-
-		case WDIOC_GETTIMEOUT:
-
-		        new_timeout = timeout;
-
-			if (unit == UNIT_MINUTE)
-			  new_timeout *= 60;
-
-			return put_user(new_timeout, uarg.i);
-
-		case WDIOC_SETOPTIONS:
-		{
-			int options, retval = -EINVAL;
-
-			if (get_user(options, uarg.i))
-				return -EFAULT;
-
-			if (options & WDIOS_DISABLECARD) {
-				wb_smsc_wdt_disable();
-				retval = 0;
-			}
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(uarg.ident, &ident, sizeof(ident))
+								? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+		return put_user(wb_smsc_wdt_status(), uarg.i);
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, uarg.i);
+	case WDIOC_SETOPTIONS:
+	{
+		int options, retval = -EINVAL;
 
-			if (options & WDIOS_ENABLECARD) {
-				wb_smsc_wdt_enable();
-				retval = 0;
-			}
+		if (get_user(options, uarg.i))
+			return -EFAULT;
 
-			return retval;
+		if (options & WDIOS_DISABLECARD) {
+			wb_smsc_wdt_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			wb_smsc_wdt_enable();
+			retval = 0;
 		}
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		wb_smsc_wdt_reset_timer();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, uarg.i))
+			return -EFAULT;
+		/* the API states this is given in secs */
+		if (unit == UNIT_MINUTE)
+			new_timeout /= 60;
+		if (new_timeout < 0 || new_timeout > MAX_TIMEOUT)
+			return -EINVAL;
+		timeout = new_timeout;
+		wb_smsc_wdt_set_timeout(timeout);
+		/* fall through and return the new timeout... */
+	case WDIOC_GETTIMEOUT:
+		new_timeout = timeout;
+		if (unit == UNIT_MINUTE)
+			  new_timeout *= 60;
+		return put_user(new_timeout, uarg.i);
+	default:
+		return -ENOTTY;
 	}
 }
 
 /* -- Notifier funtions -----------------------------------------*/
 
-static int wb_smsc_wdt_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int wb_smsc_wdt_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
 {
-	if (code == SYS_DOWN || code == SYS_HALT)
-	{
-                // set timeout to 0, to avoid possible race-condition
-	        timeout = 0;
+	if (code == SYS_DOWN || code == SYS_HALT) {
+		/* set timeout to 0, to avoid possible race-condition */
+		timeout = 0;
 		wb_smsc_wdt_disable();
 	}
 	return NOTIFY_DONE;
@@ -510,23 +507,20 @@ static int wb_smsc_wdt_notify_sys(struct notifier_block *this, unsigned long cod
 
 /* -- Module's structures ---------------------------------------*/
 
-static const struct file_operations wb_smsc_wdt_fops =
-{
-	.owner          = THIS_MODULE,
+static const struct file_operations wb_smsc_wdt_fops = {
+	.owner	  = THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wb_smsc_wdt_write,
-	.ioctl		= wb_smsc_wdt_ioctl,
+	.unlocked_ioctl	= wb_smsc_wdt_ioctl,
 	.open		= wb_smsc_wdt_open,
 	.release	= wb_smsc_wdt_release,
 };
 
-static struct notifier_block wb_smsc_wdt_notifier =
-{
+static struct notifier_block wb_smsc_wdt_notifier = {
 	.notifier_call  = wb_smsc_wdt_notify_sys,
 };
 
-static struct miscdevice wb_smsc_wdt_miscdev =
-{
+static struct miscdevice wb_smsc_wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &wb_smsc_wdt_fops,
@@ -540,39 +534,44 @@ static int __init wb_smsc_wdt_init(void)
 {
 	int ret;
 
-	printk("SMsC 37B787 watchdog component driver " VERSION " initialising...\n");
+	printk(KERN_INFO "SMsC 37B787 watchdog component driver "
+					VERSION " initialising...\n");
 
 	if (!request_region(IOPORT, IOPORT_SIZE, "SMsC 37B787 watchdog")) {
-		printk(KERN_ERR MODNAME "Unable to register IO port %#x\n", IOPORT);
+		printk(KERN_ERR MODNAME "Unable to register IO port %#x\n",
+								IOPORT);
 		ret = -EBUSY;
 		goto out_pnp;
 	}
 
-        // set new maximum, if it's too big
-        if (timeout > MAX_TIMEOUT)
-               timeout = MAX_TIMEOUT;
+	/* set new maximum, if it's too big */
+	if (timeout > MAX_TIMEOUT)
+		timeout = MAX_TIMEOUT;
 
-        // init the watchdog timer
-        wb_smsc_wdt_initialize();
+	/* init the watchdog timer */
+	wb_smsc_wdt_initialize();
 
 	ret = register_reboot_notifier(&wb_smsc_wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR MODNAME "Unable to register reboot notifier err = %d\n", ret);
+		printk(KERN_ERR MODNAME
+			"Unable to register reboot notifier err = %d\n", ret);
 		goto out_io;
 	}
 
 	ret = misc_register(&wb_smsc_wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR MODNAME "Unable to register miscdev on minor %d\n", WATCHDOG_MINOR);
+		printk(KERN_ERR MODNAME
+			"Unable to register miscdev on minor %d\n",
+							WATCHDOG_MINOR);
 		goto out_rbt;
 	}
 
-	// output info
-	printk(KERN_INFO MODNAME "Timeout set to %d %s.\n", timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
-	printk(KERN_INFO MODNAME "Watchdog initialized and sleeping (nowayout=%d)...\n", nowayout);
-
-	// ret = 0
-
+	/* output info */
+	printk(KERN_INFO MODNAME "Timeout set to %d %s.\n",
+		timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
+	printk(KERN_INFO MODNAME
+		"Watchdog initialized and sleeping (nowayout=%d)...\n",
+								nowayout);
 out_clean:
 	return ret;
 
@@ -591,8 +590,7 @@ out_pnp:
 static void __exit wb_smsc_wdt_exit(void)
 {
 	/* Stop the timer before we leave */
-	if (!nowayout)
-	{
+	if (!nowayout) {
 		wb_smsc_wdt_shutdown();
 		printk(KERN_INFO MODNAME "Watchdog disabled.\n");
 	}
@@ -601,25 +599,29 @@ static void __exit wb_smsc_wdt_exit(void)
 	unregister_reboot_notifier(&wb_smsc_wdt_notifier);
 	release_region(IOPORT, IOPORT_SIZE);
 
-	printk("SMsC 37B787 watchdog component driver removed.\n");
+	printk(KERN_INFO "SMsC 37B787 watchdog component driver removed.\n");
 }
 
 module_init(wb_smsc_wdt_init);
 module_exit(wb_smsc_wdt_exit);
 
 MODULE_AUTHOR("Sven Anders <anders@anduras.de>");
-MODULE_DESCRIPTION("Driver for SMsC 37B787 watchdog component (Version " VERSION ")");
+MODULE_DESCRIPTION("Driver for SMsC 37B787 watchdog component (Version "
+								VERSION ")");
 MODULE_LICENSE("GPL");
 
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 #ifdef SMSC_SUPPORT_MINUTES
 module_param(unit, int, 0);
-MODULE_PARM_DESC(unit, "set unit to use, 0=seconds or 1=minutes, default is 0");
+MODULE_PARM_DESC(unit,
+		"set unit to use, 0=seconds or 1=minutes, default is 0");
 #endif
 
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "range is 1-255 units, default is 60");
 
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index 9c36949..c650464 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -47,19 +47,22 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define PFX "SoftDog: "
 
 #define TIMER_MARGIN	60		/* Default is 60 seconds */
 static int soft_margin = TIMER_MARGIN;	/* in seconds */
 module_param(soft_margin, int, 0);
-MODULE_PARM_DESC(soft_margin, "Watchdog soft_margin in seconds. (0<soft_margin<65536, default=" __MODULE_STRING(TIMER_MARGIN) ")");
+MODULE_PARM_DESC(soft_margin,
+	"Watchdog soft_margin in seconds. (0 < soft_margin < 65536, default="
+					__MODULE_STRING(TIMER_MARGIN) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 #ifdef ONLY_TESTING
 static int soft_noboot = 1;
@@ -93,8 +96,7 @@ static void watchdog_fire(unsigned long data)
 
 	if (soft_noboot)
 		printk(KERN_CRIT PFX "Triggered - Reboot ignored.\n");
-	else
-	{
+	else {
 		printk(KERN_CRIT PFX "Initiating system reboot.\n");
 		emergency_restart();
 		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
@@ -153,7 +155,8 @@ static int softdog_release(struct inode *inode, struct file *file)
 		softdog_stop();
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		set_bit(0, &orphan_timer);
 		softdog_keepalive();
 	}
@@ -162,12 +165,13 @@ static int softdog_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t softdog_write(struct file *file, const char __user *data, size_t len, loff_t *ppos)
+static ssize_t softdog_write(struct file *file, const char __user *data,
+						size_t len, loff_t *ppos)
 {
 	/*
 	 *	Refresh the timer.
 	 */
-	if(len) {
+	if (len) {
 		if (!nowayout) {
 			size_t i;
 
@@ -188,13 +192,13 @@ static ssize_t softdog_write(struct file *file, const char __user *data, size_t
 	return len;
 }
 
-static int softdog_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long softdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_margin;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
@@ -202,26 +206,25 @@ static int softdog_ioctl(struct inode *inode, struct file *file,
 		.identity =		"Software Watchdog",
 	};
 	switch (cmd) {
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof(ident)) ? -EFAULT : 0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			softdog_keepalive();
-			return 0;
-		case WDIOC_SETTIMEOUT:
-			if (get_user(new_margin, p))
-				return -EFAULT;
-			if (softdog_set_heartbeat(new_margin))
-				return -EINVAL;
-			softdog_keepalive();
-			/* Fall */
-		case WDIOC_GETTIMEOUT:
-			return put_user(soft_margin, p);
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		softdog_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, p))
+			return -EFAULT;
+		if (softdog_set_heartbeat(new_margin))
+			return -EINVAL;
+		softdog_keepalive();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(soft_margin, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -232,10 +235,9 @@ static int softdog_ioctl(struct inode *inode, struct file *file,
 static int softdog_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT) {
+	if (code == SYS_DOWN || code == SYS_HALT)
 		/* Turn the WDT off */
 		softdog_stop();
-	}
 	return NOTIFY_DONE;
 }
 
@@ -247,7 +249,7 @@ static const struct file_operations softdog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= softdog_write,
-	.ioctl		= softdog_ioctl,
+	.unlocked_ioctl	= softdog_ioctl,
 	.open		= softdog_open,
 	.release	= softdog_release,
 };
@@ -268,24 +270,27 @@ static int __init watchdog_init(void)
 {
 	int ret;
 
-	/* Check that the soft_margin value is within it's range ; if not reset to the default */
+	/* Check that the soft_margin value is within it's range;
+	   if not reset to the default */
 	if (softdog_set_heartbeat(soft_margin)) {
 		softdog_set_heartbeat(TIMER_MARGIN);
-		printk(KERN_INFO PFX "soft_margin value must be 0<soft_margin<65536, using %d\n",
+		printk(KERN_INFO PFX
+		    "soft_margin must be 0 < soft_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
 
 	ret = register_reboot_notifier(&softdog_notifier);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&softdog_miscdev);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&softdog_notifier);
 		return ret;
 	}
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 57cefef..dbbc018 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -45,27 +45,34 @@ static unsigned long txx9wdt_alive;
 static int expect_close;
 static struct txx9_tmr_reg __iomem *txx9wdt_reg;
 static struct clk *txx9_imclk;
+static DECLARE_LOCK(txx9_lock);
 
 static void txx9wdt_ping(void)
 {
+	spin_lock(&txx9_lock);
 	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
+	spin_unlock(&txx9_lock);
 }
 
 static void txx9wdt_start(void)
 {
+	spin_lock(&txx9_lock);
 	__raw_writel(WD_TIMER_CLK * timeout, &txx9wdt_reg->cpra);
 	__raw_writel(WD_TIMER_CCD, &txx9wdt_reg->ccdr);
 	__raw_writel(0, &txx9wdt_reg->tisr);	/* clear pending interrupt */
 	__raw_writel(TXx9_TMTCR_TCE | TXx9_TMTCR_CCDE | TXx9_TMTCR_TMODE_WDOG,
 		     &txx9wdt_reg->tcr);
 	__raw_writel(TXx9_TMWTMR_TWIE | TXx9_TMWTMR_TWC, &txx9wdt_reg->wtmr);
+	spin_unlock(&txx9_lock);
 }
 
 static void txx9wdt_stop(void)
 {
+	spin_lock(&txx9_lock);
 	__raw_writel(TXx9_TMWTMR_WDIS, &txx9wdt_reg->wtmr);
 	__raw_writel(__raw_readl(&txx9wdt_reg->tcr) & ~TXx9_TMTCR_TCE,
 		     &txx9wdt_reg->tcr);
+	spin_unlock(&txx9_lock);
 }
 
 static int txx9wdt_open(struct inode *inode, struct file *file)
@@ -120,13 +127,13 @@ static ssize_t txx9wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int txx9wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long txx9wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options =		WDIOF_SETTIMEOUT |
 					WDIOF_KEEPALIVEPING |
 					WDIOF_MAGICCLOSE,
@@ -135,8 +142,6 @@ static int txx9wdt_ioctl(struct inode *inode, struct file *file,
 	};
 
 	switch (cmd) {
-	default:
-		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
 	case WDIOC_GETSTATUS:
@@ -156,6 +161,8 @@ static int txx9wdt_ioctl(struct inode *inode, struct file *file,
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -168,22 +175,22 @@ static int txx9wdt_notify_sys(struct notifier_block *this, unsigned long code,
 }
 
 static const struct file_operations txx9wdt_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	no_llseek,
-	.write =	txx9wdt_write,
-	.ioctl =	txx9wdt_ioctl,
-	.open =		txx9wdt_open,
-	.release =	txx9wdt_release,
+	.owner		=	THIS_MODULE,
+	.llseek		=	no_llseek,
+	.write		=	txx9wdt_write,
+	.unlocked_ioctl =	txx9wdt_ioctl,
+	.open		=	txx9wdt_open,
+	.release	=	txx9wdt_release,
 };
 
 static struct miscdevice txx9wdt_miscdev = {
-	.minor =	WATCHDOG_MINOR,
-	.name =		"watchdog",
-	.fops =		&txx9wdt_fops,
+	.minor	=	WATCHDOG_MINOR,
+	.name	=	"watchdog",
+	.fops	=	&txx9wdt_fops,
 };
 
 static struct notifier_block txx9wdt_notifier = {
-	.notifier_call = txx9wdt_notify_sys
+	.notifier_call = txx9wdt_notify_sys,
 };
 
 static int __init txx9wdt_probe(struct platform_device *dev)
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 3864928..69396ad 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -37,9 +37,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define WATCHDOG_NAME "w83627hf/thf/hg WDT"
@@ -57,22 +57,26 @@ MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds. 1 <= timeout <= 255, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Kernel methods.
  */
 
 #define WDT_EFER (wdt_io+0)   /* Extended Function Enable Registers */
-#define WDT_EFIR (wdt_io+0)   /* Extended Function Index Register (same as EFER) */
+#define WDT_EFIR (wdt_io+0)   /* Extended Function Index Register
+							(same as EFER) */
 #define WDT_EFDR (WDT_EFIR+1) /* Extended Function Data Register */
 
-static void
-w83627hf_select_wd_register(void)
+static void w83627hf_select_wd_register(void)
 {
 	unsigned char c;
 	outb_p(0x87, WDT_EFER); /* Enter extended function mode */
@@ -93,43 +97,45 @@ w83627hf_select_wd_register(void)
 	outb_p(0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
 }
 
-static void
-w83627hf_unselect_wd_register(void)
+static void w83627hf_unselect_wd_register(void)
 {
 	outb_p(0xAA, WDT_EFER); /* Leave extended function mode */
 }
 
 /* tyan motherboards seem to set F5 to 0x4C ?
  * So explicitly init to appropriate value. */
-static void
-w83627hf_init(void)
+
+static void w83627hf_init(void)
 {
 	unsigned char t;
 
 	w83627hf_select_wd_register();
 
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
-	t=inb_p(WDT_EFDR);      /* read CRF6 */
+	t = inb_p(WDT_EFDR);      /* read CRF6 */
 	if (t != 0) {
-		printk (KERN_INFO PFX "Watchdog already running. Resetting timeout to %d sec\n", timeout);
+		printk(KERN_INFO PFX
+		     "Watchdog already running. Resetting timeout to %d sec\n",
+								timeout);
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
 	}
 
 	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
-	t=inb_p(WDT_EFDR);      /* read CRF5 */
-	t&=~0x0C;               /* set second mode & disable keyboard turning off watchdog */
+	t = inb_p(WDT_EFDR);      /* read CRF5 */
+	t &= ~0x0C;               /* set second mode & disable keyboard
+				    turning off watchdog */
 	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
 
 	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
-	t=inb_p(WDT_EFDR);      /* read CRF7 */
-	t&=~0xC0;               /* disable keyboard & mouse turning off watchdog */
+	t = inb_p(WDT_EFDR);      /* read CRF7 */
+	t &= ~0xC0;               /* disable keyboard & mouse turning off
+				    watchdog */
 	outb_p(t, WDT_EFDR);    /* Write back to CRF7 */
 
 	w83627hf_unselect_wd_register();
 }
 
-static void
-wdt_ctrl(int timeout)
+static void wdt_ctrl(int timeout)
 {
 	spin_lock(&io_lock);
 
@@ -143,32 +149,28 @@ wdt_ctrl(int timeout)
 	spin_unlock(&io_lock);
 }
 
-static int
-wdt_ping(void)
+static int wdt_ping(void)
 {
 	wdt_ctrl(timeout);
 	return 0;
 }
 
-static int
-wdt_disable(void)
+static int wdt_disable(void)
 {
 	wdt_ctrl(0);
 	return 0;
 }
 
-static int
-wdt_set_heartbeat(int t)
+static int wdt_set_heartbeat(int t)
 {
-	if ((t < 1) || (t > 255))
+	if (t < 1 || t > 255)
 		return -EINVAL;
-
 	timeout = t;
 	return 0;
 }
 
-static ssize_t
-wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t wdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -178,7 +180,7 @@ wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 
 			for (i = 0; i != count; i++) {
 				char c;
-				if (get_user(c, buf+i))
+				if (get_user(c, buf + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_close = 42;
@@ -189,72 +191,61 @@ wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	return count;
 }
 
-static int
-wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
 	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+							WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "W83627HF WDT",
 	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  if (copy_to_user(argp, &ident, sizeof(ident)))
-	    return -EFAULT;
-	  break;
-
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		break;
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
-
-	case WDIOC_KEEPALIVE:
-	  wdt_ping();
-	  break;
-
-	case WDIOC_SETTIMEOUT:
-	  if (get_user(new_timeout, p))
-		  return -EFAULT;
-	  if (wdt_set_heartbeat(new_timeout))
-		  return -EINVAL;
-	  wdt_ping();
-	  /* Fall */
-
-	case WDIOC_GETTIMEOUT:
-	  return put_user(timeout, p);
-
+		return put_user(0, p);
 	case WDIOC_SETOPTIONS:
 	{
-	  int options, retval = -EINVAL;
-
-	  if (get_user(options, p))
-	    return -EFAULT;
-
-	  if (options & WDIOS_DISABLECARD) {
-	    wdt_disable();
-	    retval = 0;
-	  }
-
-	  if (options & WDIOS_ENABLECARD) {
-	    wdt_ping();
-	    retval = 0;
-	  }
+		int options, retval = -EINVAL;
 
-	  return retval;
+		if (get_user(options, p))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			wdt_disable();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			wdt_ping();
+			retval = 0;
+		}
+		return retval;
 	}
-
+	case WDIOC_KEEPALIVE:
+		wdt_ping();
+		break;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (wdt_set_heartbeat(new_timeout))
+			return -EINVAL;
+		wdt_ping();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
 	default:
-	  return -ENOTTY;
+		return -ENOTTY;
 	}
 	return 0;
 }
 
-static int
-wdt_open(struct inode *inode, struct file *file)
+static int wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
@@ -266,13 +257,13 @@ wdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static int
-wdt_close(struct inode *inode, struct file *file)
+static int wdt_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		wdt_disable();
-	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -284,14 +275,12 @@ wdt_close(struct inode *inode, struct file *file)
  *	Notifier for system down
  */
 
-static int
-wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		/* Turn the WDT off */
-		wdt_disable();
-	}
+	if (code == SYS_DOWN || code == SYS_HALT)
+		wdt_disable();	/* Turn the WDT off */
+
 	return NOTIFY_DONE;
 }
 
@@ -303,7 +292,7 @@ static const struct file_operations wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt_write,
-	.ioctl		= wdt_ioctl,
+	.unlocked_ioctl	= wdt_ioctl,
 	.open		= wdt_open,
 	.release	= wdt_close,
 };
@@ -323,8 +312,7 @@ static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
-static int __init
-wdt_init(void)
+static int __init wdt_init(void)
 {
 	int ret;
 
@@ -332,12 +320,13 @@ wdt_init(void)
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk (KERN_INFO PFX "timeout value must be 1<=timeout<=255, using %d\n",
-			WATCHDOG_TIMEOUT);
+		printk(KERN_INFO PFX
+		     "timeout value must be 1 <= timeout <= 255, using %d\n",
+				WATCHDOG_TIMEOUT);
 	}
 
 	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			wdt_io);
 		ret = -EIO;
 		goto out;
@@ -347,20 +336,22 @@ wdt_init(void)
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
-		timeout, nowayout);
+	printk(KERN_INFO PFX
+			"initialized. timeout=%d sec (nowayout=%d)\n",
+							timeout, nowayout);
 
 out:
 	return ret;
@@ -371,12 +362,11 @@ unreg_regions:
 	goto out;
 }
 
-static void __exit
-wdt_exit(void)
+static void __exit wdt_exit(void)
 {
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
-	release_region(wdt_io,1);
+	release_region(wdt_io, 1);
 }
 
 module_init(wdt_init);
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index 528b882..445d30a 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -36,9 +36,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 #define WATCHDOG_NAME "w83697hf/hg WDT"
@@ -53,37 +53,43 @@ static DEFINE_SPINLOCK(io_lock);
 /* You must set this - there is no sane way to probe for this board. */
 static int wdt_io = 0x2e;
 module_param(wdt_io, int, 0);
-MODULE_PARM_DESC(wdt_io, "w83697hf/hg WDT io port (default 0x2e, 0 = autodetect)");
+MODULE_PARM_DESC(wdt_io,
+		"w83697hf/hg WDT io port (default 0x2e, 0 = autodetect)");
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255 (default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<= timeout <=255 (default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static int early_disable = WATCHDOG_EARLY_DISABLE;
 module_param(early_disable, int, 0);
-MODULE_PARM_DESC(early_disable, "Watchdog gets disabled at boot time (default=" __MODULE_STRING(WATCHDOG_EARLY_DISABLE) ")");
+MODULE_PARM_DESC(early_disable,
+	"Watchdog gets disabled at boot time (default="
+				__MODULE_STRING(WATCHDOG_EARLY_DISABLE) ")");
 
 /*
  *	Kernel methods.
  */
 
-#define W83697HF_EFER (wdt_io+0)	/* Extended Function Enable Register */
-#define W83697HF_EFIR (wdt_io+0)	/* Extended Function Index Register (same as EFER) */
-#define W83697HF_EFDR (wdt_io+1)	/* Extended Function Data Register */
+#define W83697HF_EFER (wdt_io + 0)  /* Extended Function Enable Register */
+#define W83697HF_EFIR (wdt_io + 0)  /* Extended Function Index Register
+							(same as EFER) */
+#define W83697HF_EFDR (wdt_io + 1)  /* Extended Function Data Register */
 
-static inline void
-w83697hf_unlock(void)
+static inline void w83697hf_unlock(void)
 {
 	outb_p(0x87, W83697HF_EFER);	/* Enter extended function mode */
 	outb_p(0x87, W83697HF_EFER);	/* Again according to manual */
 }
 
-static inline void
-w83697hf_lock(void)
+static inline void w83697hf_lock(void)
 {
 	outb_p(0xAA, W83697HF_EFER);	/* Leave extended function mode */
 }
@@ -93,41 +99,36 @@ w83697hf_lock(void)
  *	w83697hf_write_timeout() must be called with the device unlocked.
  */
 
-static unsigned char
-w83697hf_get_reg(unsigned char reg)
+static unsigned char w83697hf_get_reg(unsigned char reg)
 {
 	outb_p(reg, W83697HF_EFIR);
 	return inb_p(W83697HF_EFDR);
 }
 
-static void
-w83697hf_set_reg(unsigned char reg, unsigned char data)
+static void w83697hf_set_reg(unsigned char reg, unsigned char data)
 {
 	outb_p(reg, W83697HF_EFIR);
 	outb_p(data, W83697HF_EFDR);
 }
 
-static void
-w83697hf_write_timeout(int timeout)
+static void w83697hf_write_timeout(int timeout)
 {
-	w83697hf_set_reg(0xF4, timeout);	/* Write Timeout counter to CRF4 */
+	/* Write Timeout counter to CRF4 */
+	w83697hf_set_reg(0xF4, timeout);
 }
 
-static void
-w83697hf_select_wdt(void)
+static void w83697hf_select_wdt(void)
 {
 	w83697hf_unlock();
 	w83697hf_set_reg(0x07, 0x08);	/* Switch to logic device 8 (GPIO2) */
 }
 
-static inline void
-w83697hf_deselect_wdt(void)
+static inline void w83697hf_deselect_wdt(void)
 {
 	w83697hf_lock();
 }
 
-static void
-w83697hf_init(void)
+static void w83697hf_init(void)
 {
 	unsigned char bbuf;
 
@@ -136,7 +137,9 @@ w83697hf_init(void)
 	bbuf = w83697hf_get_reg(0x29);
 	bbuf &= ~0x60;
 	bbuf |= 0x20;
-	w83697hf_set_reg(0x29, bbuf);	/* Set pin 119 to WDTO# mode (= CR29, WDT0) */
+
+	/* Set pin 119 to WDTO# mode (= CR29, WDT0) */
+	w83697hf_set_reg(0x29, bbuf);
 
 	bbuf = w83697hf_get_reg(0xF3);
 	bbuf &= ~0x04;
@@ -145,8 +148,7 @@ w83697hf_init(void)
 	w83697hf_deselect_wdt();
 }
 
-static void
-wdt_ping(void)
+static void wdt_ping(void)
 {
 	spin_lock(&io_lock);
 	w83697hf_select_wdt();
@@ -157,8 +159,7 @@ wdt_ping(void)
 	spin_unlock(&io_lock);
 }
 
-static void
-wdt_enable(void)
+static void wdt_enable(void)
 {
 	spin_lock(&io_lock);
 	w83697hf_select_wdt();
@@ -170,8 +171,7 @@ wdt_enable(void)
 	spin_unlock(&io_lock);
 }
 
-static void
-wdt_disable(void)
+static void wdt_disable(void)
 {
 	spin_lock(&io_lock);
 	w83697hf_select_wdt();
@@ -183,8 +183,7 @@ wdt_disable(void)
 	spin_unlock(&io_lock);
 }
 
-static unsigned char
-wdt_running(void)
+static unsigned char wdt_running(void)
 {
 	unsigned char t;
 
@@ -199,18 +198,17 @@ wdt_running(void)
 	return t;
 }
 
-static int
-wdt_set_heartbeat(int t)
+static int wdt_set_heartbeat(int t)
 {
-	if ((t < 1) || (t > 255))
+	if (t < 1 || t > 255)
 		return -EINVAL;
 
 	timeout = t;
 	return 0;
 }
 
-static ssize_t
-wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t wdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	if (count) {
 		if (!nowayout) {
@@ -220,7 +218,7 @@ wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 
 			for (i = 0; i != count; i++) {
 				char c;
-				if (get_user(c, buf+i))
+				if (get_user(c, buf + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_close = 42;
@@ -231,15 +229,14 @@ wdt_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	return count;
 }
 
-static int
-wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg)
+static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
 	int new_timeout;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "W83697HF WDT",
 	};
@@ -254,21 +251,6 @@ wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 
-	case WDIOC_KEEPALIVE:
-		wdt_ping();
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_timeout, p))
-			return -EFAULT;
-		if (wdt_set_heartbeat(new_timeout))
-			return -EINVAL;
-		wdt_ping();
-		/* Fall */
-
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout, p);
-
 	case WDIOC_SETOPTIONS:
 	{
 		int options, retval = -EINVAL;
@@ -289,14 +271,28 @@ wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		return retval;
 	}
 
+	case WDIOC_KEEPALIVE:
+		wdt_ping();
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if (wdt_set_heartbeat(new_timeout))
+			return -EINVAL;
+		wdt_ping();
+		/* Fall */
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+
 	default:
 		return -ENOTTY;
 	}
 	return 0;
 }
 
-static int
-wdt_open(struct inode *inode, struct file *file)
+static int wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
@@ -308,13 +304,13 @@ wdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static int
-wdt_close(struct inode *inode, struct file *file)
+static int wdt_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		wdt_disable();
-	} else {
-		printk (KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+	else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -326,14 +322,12 @@ wdt_close(struct inode *inode, struct file *file)
  *	Notifier for system down
  */
 
-static int
-wdt_notify_sys(struct notifier_block *this, unsigned long code,
+static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		/* Turn the WDT off */
-		wdt_disable();
-	}
+	if (code == SYS_DOWN || code == SYS_HALT)
+		wdt_disable();	/* Turn the WDT off */
+
 	return NOTIFY_DONE;
 }
 
@@ -345,7 +339,7 @@ static const struct file_operations wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt_write,
-	.ioctl		= wdt_ioctl,
+	.unlocked_ioctl	= wdt_ioctl,
 	.open		= wdt_open,
 	.release	= wdt_close,
 };
@@ -365,36 +359,38 @@ static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
-static int
-w83697hf_check_wdt(void)
+static int w83697hf_check_wdt(void)
 {
 	if (!request_region(wdt_io, 2, WATCHDOG_NAME)) {
-		printk (KERN_ERR PFX "I/O address 0x%x already in use\n", wdt_io);
+		printk(KERN_ERR PFX
+			"I/O address 0x%x already in use\n", wdt_io);
 		return -EIO;
 	}
 
-	printk (KERN_DEBUG PFX "Looking for watchdog at address 0x%x\n", wdt_io);
+	printk(KERN_DEBUG PFX
+			"Looking for watchdog at address 0x%x\n", wdt_io);
 	w83697hf_unlock();
 	if (w83697hf_get_reg(0x20) == 0x60) {
-		printk (KERN_INFO PFX "watchdog found at address 0x%x\n", wdt_io);
+		printk(KERN_INFO PFX
+			"watchdog found at address 0x%x\n", wdt_io);
 		w83697hf_lock();
 		return 0;
 	}
-	w83697hf_lock();	/* Reprotect in case it was a compatible device */
+	/* Reprotect in case it was a compatible device */
+	w83697hf_lock();
 
-	printk (KERN_INFO PFX "watchdog not found at address 0x%x\n", wdt_io);
+	printk(KERN_INFO PFX "watchdog not found at address 0x%x\n", wdt_io);
 	release_region(wdt_io, 2);
 	return -EIO;
 }
 
 static int w83697hf_ioports[] = { 0x2e, 0x4e, 0x00 };
 
-static int __init
-wdt_init(void)
+static int __init wdt_init(void)
 {
 	int ret, i, found = 0;
 
-	printk (KERN_INFO PFX "WDT driver for W83697HF/HG initializing\n");
+	printk(KERN_INFO PFX "WDT driver for W83697HF/HG initializing\n");
 
 	if (wdt_io == 0) {
 		/* we will autodetect the W83697HF/HG watchdog */
@@ -409,7 +405,7 @@ wdt_init(void)
 	}
 
 	if (!found) {
-		printk (KERN_ERR PFX "No W83697HF/HG could be found\n");
+		printk(KERN_ERR PFX "No W83697HF/HG could be found\n");
 		ret = -EIO;
 		goto out;
 	}
@@ -417,31 +413,33 @@ wdt_init(void)
 	w83697hf_init();
 	if (early_disable) {
 		if (wdt_running())
-			printk (KERN_WARNING PFX "Stopping previously enabled watchdog until userland kicks in\n");
+			printk(KERN_WARNING PFX "Stopping previously enabled watchdog until userland kicks in\n");
 		wdt_disable();
 	}
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk (KERN_INFO PFX "timeout value must be 1<=timeout<=255, using %d\n",
-			WATCHDOG_TIMEOUT);
+		printk(KERN_INFO PFX
+		     "timeout value must be 1 <= timeout <= 255, using %d\n",
+							WATCHDOG_TIMEOUT);
 	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
@@ -453,8 +451,7 @@ unreg_regions:
 	goto out;
 }
 
-static void __exit
-wdt_exit(void)
+static void __exit wdt_exit(void)
 {
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index f510a3a..24587d2 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -23,13 +23,16 @@
  *                            Added KERN_* tags to printks
  *                            add CONFIG_WATCHDOG_NOWAYOUT support
  *                            fix possible wdt_is_open race
- *                            changed watchdog_info to correctly reflect what the driver offers
- *                            added WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS, WDIOC_SETTIMEOUT,
+ *                            changed watchdog_info to correctly reflect what
+ *			      the driver offers
+ *                            added WDIOC_GETSTATUS, WDIOC_GETBOOTSTATUS,
+ *			      WDIOC_SETTIMEOUT,
  *                            WDIOC_GETTIMEOUT, and WDIOC_SETOPTIONS ioctls
  *           09/8 - 2003      [wim@iguana.be] cleanup of trailing spaces
  *                            added extra printk's for startup problems
  *                            use module_param
- *                            made timeout (the emulated heartbeat) a module_param
+ *                            made timeout (the emulated heartbeat) a
+ *			      module_param
  *                            made the keepalive ping an internal subroutine
  *
  *  This WDT driver is different from most other Linux WDT
@@ -51,8 +54,8 @@
 #include <linux/notifier.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 #define OUR_NAME "w83877f_wdt"
@@ -80,14 +83,19 @@
  */
 
 #define WATCHDOG_TIMEOUT 30            /* 30 sec default timeout */
-static int timeout = WATCHDOG_TIMEOUT; /* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+/* in seconds, will be multiplied by HZ to get seconds to wait for a ping */
+static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<=3600, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. (1<=timeout<=3600, default="
+				__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wdt_timer_ping(unsigned long);
 static DEFINE_TIMER(timer, wdt_timer_ping, 0, 0);
@@ -105,8 +113,7 @@ static void wdt_timer_ping(unsigned long data)
 	/* If we got a heartbeat pulse within the WDT_US_INTERVAL
 	 * we agree to ping the WDT
 	 */
-	if(time_before(jiffies, next_heartbeat))
-	{
+	if (time_before(jiffies, next_heartbeat)) {
 		/* Ping the WDT */
 		spin_lock(&wdt_spinlock);
 
@@ -118,9 +125,9 @@ static void wdt_timer_ping(unsigned long data)
 
 		spin_unlock(&wdt_spinlock);
 
-	} else {
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping the watchdog\n");
-	}
+	} else
+		printk(KERN_WARNING PFX
+			"Heartbeat lost! Will not ping the watchdog\n");
 }
 
 /*
@@ -181,22 +188,21 @@ static void wdt_keepalive(void)
  * /dev/watchdog handling
  */
 
-static ssize_t fop_write(struct file * file, const char __user * buf, size_t count, loff_t * ppos)
+static ssize_t fop_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count)
-	{
-		if (!nowayout)
-		{
+	if (count) {
+		if (!nowayout) {
 			size_t ofs;
 
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
+			/* note: just in case someone wrote the magic
+			   character five months ago... */
 			wdt_expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
-			for(ofs = 0; ofs != count; ofs++)
-			{
+			/* scan to see whether or not we got the
+			   magic character */
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
 				if (get_user(c, buf + ofs))
 					return -EFAULT;
@@ -211,10 +217,10 @@ static ssize_t fop_write(struct file * file, const char __user * buf, size_t cou
 	return count;
 }
 
-static int fop_open(struct inode * inode, struct file * file)
+static int fop_open(struct inode *inode, struct file *file)
 {
 	/* Just in case we're already talking to someone... */
-	if(test_and_set_bit(0, &wdt_is_open))
+	if (test_and_set_bit(0, &wdt_is_open))
 		return -EBUSY;
 
 	/* Good, fire up the show */
@@ -222,78 +228,78 @@ static int fop_open(struct inode * inode, struct file * file)
 	return nonseekable_open(inode, file);
 }
 
-static int fop_close(struct inode * inode, struct file * file)
+static int fop_close(struct inode *inode, struct file *file)
 {
-	if(wdt_expect_close == 42)
+	if (wdt_expect_close == 42)
 		wdt_turnoff();
 	else {
 		del_timer(&timer);
-		printk(KERN_CRIT PFX "device file closed unexpectedly. Will not stop the WDT!\n");
+		printk(KERN_CRIT PFX
+		  "device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
 	wdt_expect_close = 0;
 	return 0;
 }
 
-static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident=
-	{
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT
+							| WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "W83877F",
 	};
 
-	switch(cmd)
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
 	{
-		default:
-			return -ENOTTY;
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident, sizeof(ident))?-EFAULT:0;
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-		case WDIOC_KEEPALIVE:
-			wdt_keepalive();
-			return 0;
-		case WDIOC_SETOPTIONS:
-		{
-			int new_options, retval = -EINVAL;
-
-			if(get_user(new_options, p))
-				return -EFAULT;
-
-			if(new_options & WDIOS_DISABLECARD) {
-				wdt_turnoff();
-				retval = 0;
-			}
+		int new_options, retval = -EINVAL;
 
-			if(new_options & WDIOS_ENABLECARD) {
-				wdt_startup();
-				retval = 0;
-			}
+		if (get_user(new_options, p))
+			return -EFAULT;
 
-			return retval;
+		if (new_options & WDIOS_DISABLECARD) {
+			wdt_turnoff();
+			retval = 0;
 		}
-		case WDIOC_SETTIMEOUT:
-		{
-			int new_timeout;
 
-			if(get_user(new_timeout, p))
-				return -EFAULT;
+		if (new_options & WDIOS_ENABLECARD) {
+			wdt_startup();
+			retval = 0;
+		}
 
-			if(new_timeout < 1 || new_timeout > 3600) /* arbitrary upper limit */
-				return -EINVAL;
+		return retval;
+	}
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+	{
+		int new_timeout;
 
-			timeout = new_timeout;
-			wdt_keepalive();
-			/* Fall through */
-		}
-		case WDIOC_GETTIMEOUT:
-			return put_user(timeout, p);
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+
+		/* arbitrary upper limit */
+		if (new_timeout < 1 || new_timeout > 3600)
+			return -EINVAL;
+
+		timeout = new_timeout;
+		wdt_keepalive();
+		/* Fall through */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -303,7 +309,7 @@ static const struct file_operations wdt_fops = {
 	.write		= fop_write,
 	.open		= fop_open,
 	.release	= fop_close,
-	.ioctl		= fop_ioctl,
+	.unlocked_ioctl	= fop_ioctl,
 };
 
 static struct miscdevice wdt_miscdev = {
@@ -319,7 +325,7 @@ static struct miscdevice wdt_miscdev = {
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 	return NOTIFY_DONE;
 }
@@ -329,8 +335,7 @@ static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
  *	turn the timebomb registers off.
  */
 
-static struct notifier_block wdt_notifier=
-{
+static struct notifier_block wdt_notifier = {
 	.notifier_call = wdt_notify_sys,
 };
 
@@ -342,31 +347,29 @@ static void __exit w83877f_wdt_unload(void)
 	misc_deregister(&wdt_miscdev);
 
 	unregister_reboot_notifier(&wdt_notifier);
-	release_region(WDT_PING,1);
-	release_region(ENABLE_W83877F_PORT,2);
+	release_region(WDT_PING, 1);
+	release_region(ENABLE_W83877F_PORT, 2);
 }
 
 static int __init w83877f_wdt_init(void)
 {
 	int rc = -EBUSY;
 
-	if(timeout < 1 || timeout > 3600) /* arbitrary upper limit */
-	{
+	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX "timeout value must be 1<=x<=3600, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+			"timeout value must be 1 <= x <= 3600, using %d\n",
+							timeout);
 	}
 
-	if (!request_region(ENABLE_W83877F_PORT, 2, "W83877F WDT"))
-	{
+	if (!request_region(ENABLE_W83877F_PORT, 2, "W83877F WDT")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			ENABLE_W83877F_PORT);
 		rc = -EIO;
 		goto err_out;
 	}
 
-	if (!request_region(WDT_PING, 1, "W8387FF WDT"))
-	{
+	if (!request_region(WDT_PING, 1, "W8387FF WDT")) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			WDT_PING);
 		rc = -EIO;
@@ -374,22 +377,22 @@ static int __init w83877f_wdt_init(void)
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region2;
 	}
 
 	rc = misc_register(&wdt_miscdev);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX "WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO PFX
+	  "WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return 0;
@@ -397,9 +400,9 @@ static int __init w83877f_wdt_init(void)
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out_region2:
-	release_region(WDT_PING,1);
+	release_region(WDT_PING, 1);
 err_out_region1:
-	release_region(ENABLE_W83877F_PORT,2);
+	release_region(ENABLE_W83877F_PORT, 2);
 err_out:
 	return rc;
 }
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index b209bcd..2525da5 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -26,10 +26,10 @@
 #include <linux/watchdog.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
-#include <asm/io.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define WATCHDOG_VERSION  "1.00"
 #define WATCHDOG_NAME     "W83977F WDT"
@@ -53,13 +53,17 @@ static	char expect_close;
 static	DEFINE_SPINLOCK(spinlock);
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout,"Watchdog timeout in seconds (15..7635), default=" __MODULE_STRING(DEFAULT_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds (15..7635), default="
+				__MODULE_STRING(DEFAULT_TIMEOUT) ")");
 module_param(testmode, int, 0);
-MODULE_PARM_DESC(testmode,"Watchdog testmode (1 = no reboot), default=0");
+MODULE_PARM_DESC(testmode, "Watchdog testmode (1 = no reboot), default=0");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Start the watchdog
@@ -72,8 +76,8 @@ static int wdt_start(void)
 	spin_lock_irqsave(&spinlock, flags);
 
 	/* Unlock the SuperIO chip */
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
 
 	/*
 	 * Select device Aux2 (device=8) to set watchdog regs F2, F3 and F4.
@@ -81,50 +85,49 @@ static int wdt_start(void)
 	 * F3 is set to enable watchdog LED blink at timeout.
 	 * F4 is used to just clear the TIMEOUT'ed state (bit 0).
 	 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
-	outb_p(0xF2,IO_INDEX_PORT);
-	outb_p(timeoutW,IO_DATA_PORT);
-	outb_p(0xF3,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
-	outb_p(0xF4,IO_INDEX_PORT);
-	outb_p(0x00,IO_DATA_PORT);
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
+	outb_p(0xF2, IO_INDEX_PORT);
+	outb_p(timeoutW, IO_DATA_PORT);
+	outb_p(0xF3, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
+	outb_p(0xF4, IO_INDEX_PORT);
+	outb_p(0x00, IO_DATA_PORT);
 
 	/* Set device Aux2 active */
-	outb_p(0x30,IO_INDEX_PORT);
-	outb_p(0x01,IO_DATA_PORT);
+	outb_p(0x30, IO_INDEX_PORT);
+	outb_p(0x01, IO_DATA_PORT);
 
-	/* 
+	/*
 	 * Select device Aux1 (dev=7) to set GP16 as the watchdog output
 	 * (in reg E6) and GP13 as the watchdog LED output (in reg E3).
 	 * Map GP16 at pin 119.
 	 * In test mode watch the bit 0 on F4 to indicate "triggered" or
 	 * check watchdog LED on SBC.
 	 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x07,IO_DATA_PORT);
-	if (!testmode)
-	{
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x07, IO_DATA_PORT);
+	if (!testmode) {
 		unsigned pin_map;
 
-		outb_p(0xE6,IO_INDEX_PORT);
-		outb_p(0x0A,IO_DATA_PORT);
-		outb_p(0x2C,IO_INDEX_PORT);
+		outb_p(0xE6, IO_INDEX_PORT);
+		outb_p(0x0A, IO_DATA_PORT);
+		outb_p(0x2C, IO_INDEX_PORT);
 		pin_map = inb_p(IO_DATA_PORT);
 		pin_map |= 0x10;
 		pin_map &= ~(0x20);
-		outb_p(0x2C,IO_INDEX_PORT);
-		outb_p(pin_map,IO_DATA_PORT);
+		outb_p(0x2C, IO_INDEX_PORT);
+		outb_p(pin_map, IO_DATA_PORT);
 	}
-	outb_p(0xE3,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
+	outb_p(0xE3, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
 
 	/* Set device Aux1 active */
-	outb_p(0x30,IO_INDEX_PORT);
-	outb_p(0x01,IO_DATA_PORT);
+	outb_p(0x30, IO_INDEX_PORT);
+	outb_p(0x01, IO_DATA_PORT);
 
 	/* Lock the SuperIO chip */
-	outb_p(LOCK_DATA,IO_INDEX_PORT);
+	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
@@ -144,42 +147,41 @@ static int wdt_stop(void)
 	spin_lock_irqsave(&spinlock, flags);
 
 	/* Unlock the SuperIO chip */
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
 
-	/* 
+	/*
 	 * Select device Aux2 (device=8) to set watchdog regs F2, F3 and F4.
 	 * F2 is reset to its default value (watchdog timer disabled).
 	 * F3 is reset to its default state.
 	 * F4 clears the TIMEOUT'ed state (bit 0) - back to default.
 	 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
-	outb_p(0xF2,IO_INDEX_PORT);
-	outb_p(0xFF,IO_DATA_PORT);
-	outb_p(0xF3,IO_INDEX_PORT);
-	outb_p(0x00,IO_DATA_PORT);
-	outb_p(0xF4,IO_INDEX_PORT);
-	outb_p(0x00,IO_DATA_PORT);
-	outb_p(0xF2,IO_INDEX_PORT);
-	outb_p(0x00,IO_DATA_PORT);
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
+	outb_p(0xF2, IO_INDEX_PORT);
+	outb_p(0xFF, IO_DATA_PORT);
+	outb_p(0xF3, IO_INDEX_PORT);
+	outb_p(0x00, IO_DATA_PORT);
+	outb_p(0xF4, IO_INDEX_PORT);
+	outb_p(0x00, IO_DATA_PORT);
+	outb_p(0xF2, IO_INDEX_PORT);
+	outb_p(0x00, IO_DATA_PORT);
 
 	/*
-	 * Select device Aux1 (dev=7) to set GP16 (in reg E6) and 
+	 * Select device Aux1 (dev=7) to set GP16 (in reg E6) and
 	 * Gp13 (in reg E3) as inputs.
 	 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x07,IO_DATA_PORT);
-	if (!testmode)
-	{
-		outb_p(0xE6,IO_INDEX_PORT);
-		outb_p(0x01,IO_DATA_PORT);
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x07, IO_DATA_PORT);
+	if (!testmode) {
+		outb_p(0xE6, IO_INDEX_PORT);
+		outb_p(0x01, IO_DATA_PORT);
 	}
-	outb_p(0xE3,IO_INDEX_PORT);
-	outb_p(0x01,IO_DATA_PORT);
+	outb_p(0xE3, IO_INDEX_PORT);
+	outb_p(0x01, IO_DATA_PORT);
 
 	/* Lock the SuperIO chip */
-	outb_p(LOCK_DATA,IO_INDEX_PORT);
+	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
@@ -200,17 +202,17 @@ static int wdt_keepalive(void)
 	spin_lock_irqsave(&spinlock, flags);
 
 	/* Unlock the SuperIO chip */
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
 
 	/* Select device Aux2 (device=8) to kick watchdog reg F2 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
-	outb_p(0xF2,IO_INDEX_PORT);
-	outb_p(timeoutW,IO_DATA_PORT);
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
+	outb_p(0xF2, IO_INDEX_PORT);
+	outb_p(timeoutW, IO_DATA_PORT);
 
 	/* Lock the SuperIO chip */
-	outb_p(LOCK_DATA,IO_INDEX_PORT);
+	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
@@ -227,7 +229,7 @@ static int wdt_set_timeout(int t)
 
 	/*
 	 * Convert seconds to watchdog counter time units, rounding up.
-	 * On PCM-5335 watchdog units are 30 seconds/step with 15 sec startup 
+	 * On PCM-5335 watchdog units are 30 seconds/step with 15 sec startup
 	 * value. This information is supplied in the PCM-5335 manual and was
 	 * checked by me on a real board. This is a bit strange because W83977f
 	 * datasheet says counter unit is in minutes!
@@ -241,7 +243,7 @@ static int wdt_set_timeout(int t)
 		return -EINVAL;
 
 	/*
-	 * timeout is the timeout in seconds, 
+	 * timeout is the timeout in seconds,
 	 * timeoutW is the timeout in watchdog counter units.
 	 */
 	timeoutW = tmrval;
@@ -261,17 +263,17 @@ static int wdt_get_status(int *status)
 	spin_lock_irqsave(&spinlock, flags);
 
 	/* Unlock the SuperIO chip */
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
-	outb_p(UNLOCK_DATA,IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
+	outb_p(UNLOCK_DATA, IO_INDEX_PORT);
 
 	/* Select device Aux2 (device=8) to read watchdog reg F4 */
-	outb_p(DEVICE_REGISTER,IO_INDEX_PORT);
-	outb_p(0x08,IO_DATA_PORT);
-	outb_p(0xF4,IO_INDEX_PORT);
+	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
+	outb_p(0x08, IO_DATA_PORT);
+	outb_p(0xF4, IO_INDEX_PORT);
 	new_status = inb_p(IO_DATA_PORT);
 
 	/* Lock the SuperIO chip */
-	outb_p(LOCK_DATA,IO_INDEX_PORT);
+	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
@@ -290,7 +292,7 @@ static int wdt_get_status(int *status)
 static int wdt_open(struct inode *inode, struct file *file)
 {
 	/* If the watchdog is alive we don't need to start it again */
-	if( test_and_set_bit(0, &timer_alive) )
+	if (test_and_set_bit(0, &timer_alive))
 		return -EBUSY;
 
 	if (nowayout)
@@ -306,13 +308,13 @@ static int wdt_release(struct inode *inode, struct file *file)
 	 * Shut off the timer.
 	 * Lock it in if it's a module and we set nowayout
 	 */
-	if (expect_close == 42)
-	{
+	if (expect_close == 42) {
 		wdt_stop();
 		clear_bit(0, &timer_alive);
 	} else {
 		wdt_keepalive();
-		printk(KERN_CRIT PFX "unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
 	return 0;
@@ -333,24 +335,22 @@ static ssize_t wdt_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count)
-	{
-		if (!nowayout)
-		{
+	if (count) {
+		if (!nowayout) {
 			size_t ofs;
 
-			/* note: just in case someone wrote the magic character long ago */
+			/* note: just in case someone wrote the
+			   magic character long ago */
 			expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
-			for(ofs = 0; ofs != count; ofs++)
-			{
+			/* scan to see whether or not we got the
+			   magic character */
+			for (ofs = 0; ofs != count; ofs++) {
 				char c;
 				if (get_user(c, buf + ofs))
 					return -EFAULT;
-				if (c == 'V') {
+				if (c == 'V')
 					expect_close = 42;
-				}
 			}
 		}
 
@@ -377,8 +377,7 @@ static struct watchdog_info ident = {
 	.identity = WATCHDOG_NAME,
 };
 
-static int wdt_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int status;
 	int new_options, retval = -EINVAL;
@@ -390,13 +389,10 @@ static int wdt_ioctl(struct inode *inode, struct file *file,
 
 	uarg.i = (int __user *)arg;
 
-	switch(cmd)
-	{
-	default:
-		return -ENOTTY;
-
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		return copy_to_user(uarg.ident, &ident, sizeof(ident)) ? -EFAULT : 0;
+		return copy_to_user(uarg.ident, &ident,
+						sizeof(ident)) ? -EFAULT : 0;
 
 	case WDIOC_GETSTATUS:
 		wdt_get_status(&status);
@@ -405,12 +401,8 @@ static int wdt_ioctl(struct inode *inode, struct file *file,
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, uarg.i);
 
-	case WDIOC_KEEPALIVE:
-		wdt_keepalive();
-		return 0;
-
 	case WDIOC_SETOPTIONS:
-		if (get_user (new_options, uarg.i))
+		if (get_user(new_options, uarg.i))
 			return -EFAULT;
 
 		if (new_options & WDIOS_DISABLECARD) {
@@ -425,6 +417,10 @@ static int wdt_ioctl(struct inode *inode, struct file *file,
 
 		return retval;
 
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+
 	case WDIOC_SETTIMEOUT:
 		if (get_user(new_timeout, uarg.i))
 			return -EFAULT;
@@ -438,29 +434,30 @@ static int wdt_ioctl(struct inode *inode, struct file *file,
 	case WDIOC_GETTIMEOUT:
 		return put_user(timeout, uarg.i);
 
+	default:
+		return -ENOTTY;
+
 	}
 }
 
 static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if (code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_stop();
 	return NOTIFY_DONE;
 }
 
-static const struct file_operations wdt_fops=
-{
+static const struct file_operations wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt_write,
-	.ioctl		= wdt_ioctl,
+	.unlocked_ioctl	= wdt_ioctl,
 	.open		= wdt_open,
 	.release	= wdt_release,
 };
 
-static struct miscdevice wdt_miscdev=
-{
+static struct miscdevice wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &wdt_fops,
@@ -474,20 +471,20 @@ static int __init w83977f_wdt_init(void)
 {
 	int rc;
 
-        printk(KERN_INFO PFX DRIVER_VERSION);
+	printk(KERN_INFO PFX DRIVER_VERSION);
 
 	/*
-	 * Check that the timeout value is within it's range ; 
+	 * Check that the timeout value is within it's range;
 	 * if not reset to the default
 	 */
 	if (wdt_set_timeout(timeout)) {
 		wdt_set_timeout(DEFAULT_TIMEOUT);
-		printk(KERN_INFO PFX "timeout value must be 15<=timeout<=7635, using %d\n",
-			DEFAULT_TIMEOUT);
+		printk(KERN_INFO PFX
+		    "timeout value must be 15 <= timeout <= 7635, using %d\n",
+							DEFAULT_TIMEOUT);
 	}
 
-	if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME))
-	{
+	if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
 		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			IO_INDEX_PORT);
 		rc = -EIO;
@@ -495,30 +492,30 @@ static int __init w83977f_wdt_init(void)
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt_miscdev.minor, rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d testmode=%d)\n",
-		timeout, nowayout, testmode);
+	printk(KERN_INFO PFX
+		"initialized. timeout=%d sec (nowayout=%d testmode=%d)\n",
+					timeout, nowayout, testmode);
 
 	return 0;
 
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out_region:
-	release_region(IO_INDEX_PORT,2);
+	release_region(IO_INDEX_PORT, 2);
 err_out:
 	return rc;
 }
@@ -528,7 +525,7 @@ static void __exit w83977f_wdt_exit(void)
 	wdt_stop();
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
-	release_region(IO_INDEX_PORT,2);
+	release_region(IO_INDEX_PORT, 2);
 }
 
 module_init(w83977f_wdt_init);
diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 9e36809..68377ae 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -1,11 +1,11 @@
 /*
  *	ICP Wafer 5823 Single Board Computer WDT driver
- *      http://www.icpamerica.com/wafer_5823.php
- *      May also work on other similar models
+ *	http://www.icpamerica.com/wafer_5823.php
+ *	May also work on other similar models
  *
  *	(c) Copyright 2002 Justin Cormack <justin@street-vision.com>
  *
- *      Release 0.02
+ *	Release 0.02
  *
  *	Based on advantechwdt.c which is based on wdt.c.
  *	Original copyright messages:
@@ -36,8 +36,8 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
 #define WATCHDOG_NAME "Wafer 5823 WDT"
 #define PFX WATCHDOG_NAME ": "
@@ -50,10 +50,10 @@ static DEFINE_SPINLOCK(wafwdt_lock);
 /*
  *	You must set these - there is no sane way to probe for this board.
  *
- *      To enable, write the timeout value in seconds (1 to 255) to I/O
- *      port WDT_START, then read the port to start the watchdog. To pat
- *      the dog, read port WDT_STOP to stop the timer, then read WDT_START
- *      to restart it again.
+ *	To enable, write the timeout value in seconds (1 to 255) to I/O
+ *	port WDT_START, then read the port to start the watchdog. To pat
+ *	the dog, read port WDT_STOP to stop the timer, then read WDT_START
+ *	to restart it again.
  */
 
 static int wdt_stop = 0x843;
@@ -61,11 +61,15 @@ static int wdt_start = 0x443;
 
 static int timeout = WD_TIMO;  /* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255, default=" __MODULE_STRING(WD_TIMO) ".");
+MODULE_PARM_DESC(timeout,
+		"Watchdog timeout in seconds. 1 <= timeout <= 255, default="
+				__MODULE_STRING(WD_TIMO) ".");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 static void wafwdt_ping(void)
 {
@@ -83,14 +87,14 @@ static void wafwdt_start(void)
 	inb_p(wdt_start);
 }
 
-static void
-wafwdt_stop(void)
+static void wafwdt_stop(void)
 {
 	/* stop watchdog */
 	inb_p(wdt_stop);
 }
 
-static ssize_t wafwdt_write(struct file *file, const char __user *buf, size_t count, loff_t * ppos)
+static ssize_t wafwdt_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
 	if (count) {
@@ -100,7 +104,8 @@ static ssize_t wafwdt_write(struct file *file, const char __user *buf, size_t co
 			/* In case it was set long ago */
 			expect_close = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the magic
+			   character */
 			for (i = 0; i != count; i++) {
 				char c;
 				if (get_user(c, buf + i))
@@ -109,27 +114,29 @@ static ssize_t wafwdt_write(struct file *file, const char __user *buf, size_t co
 					expect_close = 42;
 			}
 		}
-		/* Well, anyhow someone wrote to us, we should return that favour */
+		/* Well, anyhow someone wrote to us, we should
+		   return that favour */
 		wafwdt_ping();
 	}
 	return count;
 }
 
-static int wafwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	     unsigned long arg)
+static long wafwdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int new_timeout;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident = {
-		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	static const struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT |
+							WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = "Wafer 5823 WDT",
 	};
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &ident, sizeof (ident)))
+		if (copy_to_user(argp, &ident, sizeof(ident)))
 			return -EFAULT;
 		break;
 
@@ -137,22 +144,6 @@ static int wafwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 
-	case WDIOC_KEEPALIVE:
-		wafwdt_ping();
-		break;
-
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_timeout, p))
-			return -EFAULT;
-		if ((new_timeout < 1) || (new_timeout > 255))
-			return -EINVAL;
-		timeout = new_timeout;
-		wafwdt_stop();
-		wafwdt_start();
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-		return put_user(timeout, p);
-
 	case WDIOC_SETOPTIONS:
 	{
 		int options, retval = -EINVAL;
@@ -173,6 +164,22 @@ static int wafwdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd
 		return retval;
 	}
 
+	case WDIOC_KEEPALIVE:
+		wafwdt_ping();
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, p))
+			return -EFAULT;
+		if ((new_timeout < 1) || (new_timeout > 255))
+			return -EINVAL;
+		timeout = new_timeout;
+		wafwdt_stop();
+		wafwdt_start();
+		/* Fall */
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+
 	default:
 		return -ENOTTY;
 	}
@@ -191,13 +198,13 @@ static int wafwdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static int
-wafwdt_close(struct inode *inode, struct file *file)
+static int wafwdt_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42) {
+	if (expect_close == 42)
 		wafwdt_stop();
-	} else {
-		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
+	else {
+		printk(KERN_CRIT PFX
+		    "WDT device closed unexpectedly.  WDT will not stop!\n");
 		wafwdt_ping();
 	}
 	clear_bit(0, &wafwdt_is_open);
@@ -209,12 +216,11 @@ wafwdt_close(struct inode *inode, struct file *file)
  *	Notifier for system down
  */
 
-static int wafwdt_notify_sys(struct notifier_block *this, unsigned long code, void *unused)
+static int wafwdt_notify_sys(struct notifier_block *this, unsigned long code,
+								void *unused)
 {
-	if (code == SYS_DOWN || code == SYS_HALT) {
-		/* Turn the WDT off */
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wafwdt_stop();
-	}
 	return NOTIFY_DONE;
 }
 
@@ -226,7 +232,7 @@ static const struct file_operations wafwdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wafwdt_write,
-	.ioctl		= wafwdt_ioctl,
+	.unlocked_ioctl	= wafwdt_ioctl,
 	.open		= wafwdt_open,
 	.release	= wafwdt_close,
 };
@@ -250,25 +256,28 @@ static int __init wafwdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "WDT driver for Wafer 5823 single board computer initialising.\n");
+	printk(KERN_INFO
+	  "WDT driver for Wafer 5823 single board computer initialising.\n");
 
 	if (timeout < 1 || timeout > 255) {
 		timeout = WD_TIMO;
-		printk (KERN_INFO PFX "timeout value must be 1<=x<=255, using %d\n",
-			timeout);
+		printk(KERN_INFO PFX
+			"timeout value must be 1 <= x <= 255, using %d\n",
+								timeout);
 	}
 
 	if (wdt_stop != wdt_start) {
-		if(!request_region(wdt_stop, 1, "Wafer 5823 WDT")) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-			wdt_stop);
+		if (!request_region(wdt_stop, 1, "Wafer 5823 WDT")) {
+			printk(KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								wdt_stop);
 			ret = -EIO;
 			goto error;
 		}
 	}
 
-	if(!request_region(wdt_start, 1, "Wafer 5823 WDT")) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
+	if (!request_region(wdt_start, 1, "Wafer 5823 WDT")) {
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		ret = -EIO;
 		goto error2;
@@ -276,19 +285,20 @@ static int __init wafwdt_init(void)
 
 	ret = register_reboot_notifier(&wafwdt_notifier);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			ret);
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
 		goto error3;
 	}
 
 	ret = misc_register(&wafwdt_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						WATCHDOG_MINOR, ret);
 		goto error4;
 	}
 
-	printk (KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return ret;
@@ -307,7 +317,7 @@ static void __exit wafwdt_exit(void)
 {
 	misc_deregister(&wafwdt_miscdev);
 	unregister_reboot_notifier(&wafwdt_notifier);
-	if(wdt_stop != wdt_start)
+	if (wdt_stop != wdt_start)
 		release_region(wdt_stop, 1);
 	release_region(wdt_start, 1);
 }
diff --git a/drivers/watchdog/wd501p.h b/drivers/watchdog/wd501p.h
index a4504f4..db34853 100644
--- a/drivers/watchdog/wd501p.h
+++ b/drivers/watchdog/wd501p.h
@@ -12,7 +12,7 @@
  *	http://www.cymru.net
  *
  *	This driver is provided under the GNU General Public License, incorporated
- *	herein by reference. The driver is provided without warranty or 
+ *	herein by reference. The driver is provided without warranty or
  *	support.
  *
  *	Release 0.04.
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 1d64e27..5d3b1a8 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -35,9 +35,9 @@
 #include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
+#include <linux/uaccess.h>
 
 #include <asm/rtas.h>
-#include <asm/uaccess.h>
 
 #define WDRTAS_MAGIC_CHAR		42
 #define WDRTAS_SUPPORTED_MASK		(WDIOF_SETTIMEOUT | \
@@ -56,7 +56,7 @@ static int wdrtas_nowayout = 0;
 #endif
 
 static atomic_t wdrtas_miscdev_open = ATOMIC_INIT(0);
-static char wdrtas_expect_close = 0;
+static char wdrtas_expect_close;
 
 static int wdrtas_interval;
 
@@ -86,8 +86,8 @@ static char wdrtas_logbuffer[WDRTAS_LOGBUFFER_LEN];
  * RTAS function set-indicator (surveillance). The unit of interval is
  * seconds.
  */
-static int
-wdrtas_set_interval(int interval)
+
+static int wdrtas_set_interval(int interval)
 {
 	long result;
 	static int print_msg = 10;
@@ -97,7 +97,7 @@ wdrtas_set_interval(int interval)
 
 	result = rtas_call(wdrtas_token_set_indicator, 3, 1, NULL,
 			   WDRTAS_SURVEILLANCE_IND, 0, interval);
-	if ( (result < 0) && (print_msg) ) {
+	if (result < 0 && print_msg) {
 		printk(KERN_ERR "wdrtas: setting the watchdog to %i "
 		       "timeout failed: %li\n", interval, result);
 		print_msg--;
@@ -116,16 +116,14 @@ wdrtas_set_interval(int interval)
  * as reported by the RTAS function ibm,get-system-parameter. The unit
  * of the return value is seconds.
  */
-static int
-wdrtas_get_interval(int fallback_value)
+static int wdrtas_get_interval(int fallback_value)
 {
 	long result;
 	char value[4];
 
 	result = rtas_call(wdrtas_token_get_sp, 3, 1, NULL,
 			   WDRTAS_SP_SPI, (void *)__pa(&value), 4);
-	if ( (value[0] != 0) || (value[1] != 2) || (value[3] != 0) ||
-	     (result < 0) ) {
+	if (value[0] != 0 || value[1] != 2 || value[3] != 0 || result < 0) {
 		printk(KERN_WARNING "wdrtas: could not get sp_spi watchdog "
 		       "timeout (%li). Continuing\n", result);
 		return fallback_value;
@@ -141,8 +139,7 @@ wdrtas_get_interval(int fallback_value)
  * wdrtas_timer_start starts the watchdog by calling the RTAS function
  * set-interval (surveillance)
  */
-static void
-wdrtas_timer_start(void)
+static void wdrtas_timer_start(void)
 {
 	wdrtas_set_interval(wdrtas_interval);
 }
@@ -153,8 +150,7 @@ wdrtas_timer_start(void)
  * wdrtas_timer_stop stops the watchdog timer by calling the RTAS function
  * set-interval (surveillance)
  */
-static void
-wdrtas_timer_stop(void)
+static void wdrtas_timer_stop(void)
 {
 	wdrtas_set_interval(0);
 }
@@ -165,8 +161,7 @@ wdrtas_timer_stop(void)
  * wdrtas_log_scanned_event prints a message to the log buffer dumping
  * the results of the last event-scan call
  */
-static void
-wdrtas_log_scanned_event(void)
+static void wdrtas_log_scanned_event(void)
 {
 	int i;
 
@@ -175,13 +170,13 @@ wdrtas_log_scanned_event(void)
 		       "%02x %02x %02x %02x  %02x %02x %02x %02x   "
 		       "%02x %02x %02x %02x  %02x %02x %02x %02x\n",
 		       (i / 16) + 1, (WDRTAS_LOGBUFFER_LEN / 16),
-		       wdrtas_logbuffer[i + 0], wdrtas_logbuffer[i + 1], 
-		       wdrtas_logbuffer[i + 2], wdrtas_logbuffer[i + 3], 
-		       wdrtas_logbuffer[i + 4], wdrtas_logbuffer[i + 5], 
-		       wdrtas_logbuffer[i + 6], wdrtas_logbuffer[i + 7], 
-		       wdrtas_logbuffer[i + 8], wdrtas_logbuffer[i + 9], 
-		       wdrtas_logbuffer[i + 10], wdrtas_logbuffer[i + 11], 
-		       wdrtas_logbuffer[i + 12], wdrtas_logbuffer[i + 13], 
+		       wdrtas_logbuffer[i + 0], wdrtas_logbuffer[i + 1],
+		       wdrtas_logbuffer[i + 2], wdrtas_logbuffer[i + 3],
+		       wdrtas_logbuffer[i + 4], wdrtas_logbuffer[i + 5],
+		       wdrtas_logbuffer[i + 6], wdrtas_logbuffer[i + 7],
+		       wdrtas_logbuffer[i + 8], wdrtas_logbuffer[i + 9],
+		       wdrtas_logbuffer[i + 10], wdrtas_logbuffer[i + 11],
+		       wdrtas_logbuffer[i + 12], wdrtas_logbuffer[i + 13],
 		       wdrtas_logbuffer[i + 14], wdrtas_logbuffer[i + 15]);
 }
 
@@ -192,8 +187,7 @@ wdrtas_log_scanned_event(void)
  * RTAS function event-scan and repeats these calls as long as there are
  * events available. All events will be dumped.
  */
-static void
-wdrtas_timer_keepalive(void)
+static void wdrtas_timer_keepalive(void)
 {
 	long result;
 
@@ -218,8 +212,7 @@ wdrtas_timer_keepalive(void)
  * wdrtas_get_temperature returns the current temperature in Fahrenheit. It
  * uses the RTAS call get-sensor-state, token 3 to do so
  */
-static int
-wdrtas_get_temperature(void)
+static int wdrtas_get_temperature(void)
 {
 	long result;
 	int temperature = 0;
@@ -243,8 +236,7 @@ wdrtas_get_temperature(void)
  * returns a bitmask of defines WDIOF_... as defined in
  * include/linux/watchdog.h
  */
-static int
-wdrtas_get_status(void)
+static int wdrtas_get_status(void)
 {
 	return 0; /* TODO */
 }
@@ -255,8 +247,7 @@ wdrtas_get_status(void)
  * returns a bitmask of defines WDIOF_... as defined in
  * include/linux/watchdog.h, indicating why the watchdog rebooted the system
  */
-static int
-wdrtas_get_boot_status(void)
+static int wdrtas_get_boot_status(void)
 {
 	return 0; /* TODO */
 }
@@ -276,8 +267,7 @@ wdrtas_get_boot_status(void)
  * character 'V'. This character allows the watchdog device to be closed
  * properly.
  */
-static ssize_t
-wdrtas_write(struct file *file, const char __user *buf,
+static ssize_t wdrtas_write(struct file *file, const char __user *buf,
 	     size_t len, loff_t *ppos)
 {
 	int i;
@@ -306,7 +296,6 @@ out:
 
 /**
  * wdrtas_ioctl - ioctl function for the watchdog device
- * @inode: inode structure
  * @file: file structure
  * @cmd: command for ioctl
  * @arg: argument pointer
@@ -315,16 +304,16 @@ out:
  *
  * wdrtas_ioctl implements the watchdog API ioctls
  */
-static int
-wdrtas_ioctl(struct inode *inode, struct file *file,
-	     unsigned int cmd, unsigned long arg)
+
+static long wdrtas_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int __user *argp = (void __user *)arg;
 	int i;
 	static struct watchdog_info wdinfo = {
 		.options = WDRTAS_SUPPORTED_MASK,
 		.firmware_version = 0,
-		.identity = "wdrtas"
+		.identity = "wdrtas",
 	};
 
 	switch (cmd) {
@@ -357,9 +346,9 @@ wdrtas_ioctl(struct inode *inode, struct file *file,
 			wdrtas_timer_keepalive();
 			wdrtas_timer_start();
 		}
+		/* not implemented. Done by H8
 		if (i & WDIOS_TEMPPANIC) {
-			/* not implemented. Done by H8 */
-		}
+		} */
 		return 0;
 
 	case WDIOC_KEEPALIVE:
@@ -399,8 +388,7 @@ wdrtas_ioctl(struct inode *inode, struct file *file,
  *
  * function called when watchdog device is opened
  */
-static int
-wdrtas_open(struct inode *inode, struct file *file)
+static int wdrtas_open(struct inode *inode, struct file *file)
 {
 	/* only open once */
 	if (atomic_inc_return(&wdrtas_miscdev_open) > 1) {
@@ -423,8 +411,7 @@ wdrtas_open(struct inode *inode, struct file *file)
  *
  * close function. Always succeeds
  */
-static int
-wdrtas_close(struct inode *inode, struct file *file)
+static int wdrtas_close(struct inode *inode, struct file *file)
 {
 	/* only stop watchdog, if this was announced using 'V' before */
 	if (wdrtas_expect_close == WDRTAS_MAGIC_CHAR)
@@ -453,8 +440,7 @@ wdrtas_close(struct inode *inode, struct file *file)
  * wdrtas_temp_read gives the temperature to the users by copying this
  * value as one byte into the user space buffer. The unit is Fahrenheit...
  */
-static ssize_t
-wdrtas_temp_read(struct file *file, char __user *buf,
+static ssize_t wdrtas_temp_read(struct file *file, char __user *buf,
 		 size_t count, loff_t *ppos)
 {
 	int temperature = 0;
@@ -478,8 +464,7 @@ wdrtas_temp_read(struct file *file, char __user *buf,
  *
  * function called when temperature device is opened
  */
-static int
-wdrtas_temp_open(struct inode *inode, struct file *file)
+static int wdrtas_temp_open(struct inode *inode, struct file *file)
 {
 	return nonseekable_open(inode, file);
 }
@@ -493,8 +478,7 @@ wdrtas_temp_open(struct inode *inode, struct file *file)
  *
  * close function. Always succeeds
  */
-static int
-wdrtas_temp_close(struct inode *inode, struct file *file)
+static int wdrtas_temp_close(struct inode *inode, struct file *file)
 {
 	return 0;
 }
@@ -509,10 +493,10 @@ wdrtas_temp_close(struct inode *inode, struct file *file)
  *
  * wdrtas_reboot stops the watchdog in case of a reboot
  */
-static int
-wdrtas_reboot(struct notifier_block *this, unsigned long code, void *ptr)
+static int wdrtas_reboot(struct notifier_block *this,
+					unsigned long code, void *ptr)
 {
-	if ( (code==SYS_DOWN) || (code==SYS_HALT) )
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdrtas_timer_stop();
 
 	return NOTIFY_DONE;
@@ -524,7 +508,7 @@ static const struct file_operations wdrtas_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdrtas_write,
-	.ioctl		= wdrtas_ioctl,
+	.unlocked_ioctl	= wdrtas_ioctl,
 	.open		= wdrtas_open,
 	.release	= wdrtas_close,
 };
@@ -562,8 +546,7 @@ static struct notifier_block wdrtas_notifier = {
  * this watchdog driver. It tolerates, if "get-sensor-state" and
  * "ibm,get-system-parameter" are not available.
  */
-static int
-wdrtas_get_tokens(void)
+static int wdrtas_get_tokens(void)
 {
 	wdrtas_token_get_sensor_state = rtas_token("get-sensor-state");
 	if (wdrtas_token_get_sensor_state == RTAS_UNKNOWN_SERVICE) {
@@ -603,8 +586,7 @@ wdrtas_get_tokens(void)
  * wdrtas_register_devs unregisters the watchdog and temperature watchdog
  * misc devs
  */
-static void
-wdrtas_unregister_devs(void)
+static void wdrtas_unregister_devs(void)
 {
 	misc_deregister(&wdrtas_miscdev);
 	if (wdrtas_token_get_sensor_state != RTAS_UNKNOWN_SERVICE)
@@ -619,8 +601,7 @@ wdrtas_unregister_devs(void)
  * wdrtas_register_devs registers the watchdog and temperature watchdog
  * misc devs
  */
-static int
-wdrtas_register_devs(void)
+static int wdrtas_register_devs(void)
 {
 	int result;
 
@@ -651,8 +632,7 @@ wdrtas_register_devs(void)
  *
  * registers the file handlers and the reboot notifier
  */
-static int __init
-wdrtas_init(void)
+static int __init wdrtas_init(void)
 {
 	if (wdrtas_get_tokens())
 		return -ENODEV;
@@ -680,8 +660,7 @@ wdrtas_init(void)
  *
  * unregisters the file handlers and the reboot notifier
  */
-static void __exit
-wdrtas_exit(void)
+static void __exit wdrtas_exit(void)
 {
 	if (!wdrtas_nowayout)
 		wdrtas_timer_stop();
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index 53a6b18..deeebb2 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -373,8 +373,6 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 #endif /* CONFIG_WDT_501 */
 
 	switch (cmd) {
-	default:
-		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
 	case WDIOC_GETSTATUS:
@@ -394,6 +392,8 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		return put_user(heartbeat, p);
+	default:
+		return -ENOTTY;
 	}
 }
 
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index e4cf661..fea398a 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -26,9 +26,9 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/uaccess.h>
+#include <linux/irq.h>
 
-#include <asm/irq.h>
-#include <asm/uaccess.h>
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/hardware/dec21285.h>
@@ -115,8 +115,8 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t
-watchdog_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+static ssize_t watchdog_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
 {
 	/*
 	 *	Refresh the timer.
@@ -127,19 +127,18 @@ watchdog_write(struct file *file, const char *data, size_t len, loff_t *ppos)
 	return len;
 }
 
-static struct watchdog_info ident = {
+static const struct watchdog_info ident = {
 	.options	= WDIOF_SETTIMEOUT,
 	.identity	= "Footbridge Watchdog",
 };
 
-static int
-watchdog_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	       unsigned long arg)
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	unsigned int new_margin;
 	int ret = -ENOTTY;
 
-	switch(cmd) {
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		ret = 0;
 		if (copy_to_user((void *)arg, &ident, sizeof(ident)))
@@ -148,7 +147,7 @@ watchdog_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		ret = put_user(0,(int *)arg);
+		ret = put_user(0, (int *)arg);
 		break;
 
 	case WDIOC_KEEPALIVE:
@@ -182,7 +181,7 @@ static const struct file_operations watchdog_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= watchdog_write,
-	.ioctl		= watchdog_ioctl,
+	.unlocked_ioctl	= watchdog_ioctl,
 	.open		= watchdog_open,
 	.release	= watchdog_release,
 };
@@ -204,11 +203,13 @@ static int __init footbridge_watchdog_init(void)
 	if (retval < 0)
 		return retval;
 
-	printk("Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
-	       soft_margin);
+	printk(KERN_INFO
+		"Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
+								soft_margin);
 
 	if (machine_is_cats())
-		printk("Warning: Watchdog reset may not work on this machine.\n");
+		printk(KERN_WARN
+		  "Warning: Watchdog reset may not work on this machine.\n");
 	return 0;
 }
 
@@ -223,7 +224,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
 module_param(soft_margin, int, 0);
-MODULE_PARM_DESC(soft_margin,"Watchdog timeout in seconds");
+MODULE_PARM_DESC(soft_margin, "Watchdog timeout in seconds");
 
 module_init(footbridge_watchdog_init);
 module_exit(footbridge_watchdog_exit);
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index fb4b876..60e28d4 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -19,7 +19,8 @@
  *      07-Jul-2003 Daniele Bellucci: Audit return code of misc_register in
  *                                    nwwatchdog_init.
  *      25-Oct-2005 Woody Suwalski: Convert addresses to #defs, add spinlocks
- *				    remove limitiation to be used on Netwinders only
+ *				    remove limitiation to be used on
+ *				    Netwinders only
  */
 
 #include <linux/module.h>
@@ -33,11 +34,11 @@
 #include <linux/watchdog.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
 #include <asm/system.h>
 #include <asm/mach-types.h>
-#include <asm/uaccess.h>
 
 #define WATCHDOG_VERSION  "0.04"
 #define WATCHDOG_NAME     "Wdt977"
@@ -45,7 +46,7 @@
 #define DRIVER_VERSION    WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
 
 #define IO_INDEX_PORT	0x370		/* on some systems it can be 0x3F0 */
-#define IO_DATA_PORT	(IO_INDEX_PORT+1)
+#define IO_DATA_PORT	(IO_INDEX_PORT + 1)
 
 #define UNLOCK_DATA	0x87
 #define LOCK_DATA	0xAA
@@ -62,13 +63,16 @@ static	char expect_close;
 static	DEFINE_SPINLOCK(spinlock);
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout,"Watchdog timeout in seconds (60..15300), default=" __MODULE_STRING(DEFAULT_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds (60..15300), default="
+				__MODULE_STRING(DEFAULT_TIMEOUT) ")");
 module_param(testmode, int, 0);
-MODULE_PARM_DESC(testmode,"Watchdog testmode (1 = no reboot), default=0");
+MODULE_PARM_DESC(testmode, "Watchdog testmode (1 = no reboot), default=0");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Start the watchdog
@@ -95,14 +99,16 @@ static int wdt977_start(void)
 	outb_p(0xF2, IO_INDEX_PORT);
 	outb_p(timeoutM, IO_DATA_PORT);
 	outb_p(0xF3, IO_INDEX_PORT);
-	outb_p(0x00, IO_DATA_PORT);	/* another setting is 0E for kbd/mouse/LED */
+	outb_p(0x00, IO_DATA_PORT);	/* another setting is 0E for
+					   kbd/mouse/LED */
 	outb_p(0xF4, IO_INDEX_PORT);
 	outb_p(0x00, IO_DATA_PORT);
 
-	/* at last select device Aux1 (dev=7) and set GP16 as a watchdog output */
-	/* in test mode watch the bit 1 on F4 to indicate "triggered" */
-	if (!testmode)
-	{
+	/* At last select device Aux1 (dev=7) and set GP16 as a
+	 * watchdog output. In test mode watch the bit 1 on F4 to
+	 * indicate "triggered"
+	 */
+	if (!testmode) {
 		outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
 		outb_p(0x07, IO_DATA_PORT);
 		outb_p(0xE6, IO_INDEX_PORT);
@@ -147,7 +153,8 @@ static int wdt977_stop(void)
 	outb_p(0xF2, IO_INDEX_PORT);
 	outb_p(0x00, IO_DATA_PORT);
 
-	/* at last select device Aux1 (dev=7) and set GP16 as a watchdog output */
+	/* at last select device Aux1 (dev=7) and set
+	   GP16 as a watchdog output */
 	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
 	outb_p(0x07, IO_DATA_PORT);
 	outb_p(0xE6, IO_INDEX_PORT);
@@ -202,16 +209,18 @@ static int wdt977_set_timeout(int t)
 	tmrval = (t + 59) / 60;
 
 	if (machine_is_netwinder()) {
-		/* we have a hw bug somewhere, so each 977 minute is actually only 30sec
-		 *  this limits the max timeout to half of device max of 255 minutes...
+		/* we have a hw bug somewhere, so each 977 minute is actually
+		 * only 30sec. This limits the max timeout to half of device
+		 * max of 255 minutes...
 		 */
 		tmrval += tmrval;
 	}
 
-	if ((tmrval < 1) || (tmrval > 255))
+	if (tmrval < 1 || tmrval > 255)
 		return -EINVAL;
 
-	/* timeout is the timeout in seconds, timeoutM is the timeout in minutes) */
+	/* timeout is the timeout in seconds, timeoutM is
+	   the timeout in minutes) */
 	timeout = t;
 	timeoutM = tmrval;
 	return 0;
@@ -243,7 +252,7 @@ static int wdt977_get_status(int *status)
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
-	*status=0;
+	*status = 0;
 	if (new_status & 1)
 		*status |= WDIOF_CARDRESET;
 
@@ -258,7 +267,7 @@ static int wdt977_get_status(int *status)
 static int wdt977_open(struct inode *inode, struct file *file)
 {
 	/* If the watchdog is alive we don't need to start it again */
-	if( test_and_set_bit(0,&timer_alive) )
+	if (test_and_set_bit(0, &timer_alive))
 		return -EBUSY;
 
 	if (nowayout)
@@ -274,13 +283,13 @@ static int wdt977_release(struct inode *inode, struct file *file)
 	 *	Shut off the timer.
 	 * 	Lock it in if it's a module and we set nowayout
 	 */
-	if (expect_close == 42)
-	{
+	if (expect_close == 42) {
 		wdt977_stop();
-		clear_bit(0,&timer_alive);
+		clear_bit(0, &timer_alive);
 	} else {
 		wdt977_keepalive();
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
 	return 0;
@@ -301,17 +310,14 @@ static int wdt977_release(struct inode *inode, struct file *file)
 static ssize_t wdt977_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-	if (count)
-	{
-		if (!nowayout)
-		{
+	if (count) {
+		if (!nowayout) {
 			size_t i;
 
 			/* In case it was set long ago */
 			expect_close = 0;
 
-			for (i = 0; i != count; i++)
-			{
+			for (i = 0; i != count; i++) {
 				char c;
 				if (get_user(c, buf + i))
 					return -EFAULT;
@@ -326,6 +332,14 @@ static ssize_t wdt977_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_MAGICCLOSE |
+				WDIOF_KEEPALIVEPING,
+	.firmware_version =	1,
+	.identity =		WATCHDOG_NAME,
+};
+
 /*
  *      wdt977_ioctl:
  *      @inode: inode of the device
@@ -337,16 +351,8 @@ static ssize_t wdt977_write(struct file *file, const char __user *buf,
  *      according to their available features.
  */
 
-static struct watchdog_info ident = {
-	.options =		WDIOF_SETTIMEOUT |
-				WDIOF_MAGICCLOSE |
-				WDIOF_KEEPALIVEPING,
-	.firmware_version =	1,
-	.identity =		WATCHDOG_NAME,
-};
-
-static int wdt977_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long wdt977_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int status;
 	int new_options, retval = -EINVAL;
@@ -358,11 +364,7 @@ static int wdt977_ioctl(struct inode *inode, struct file *file,
 
 	uarg.i = (int __user *)arg;
 
-	switch(cmd)
-	{
-	default:
-		return -ENOTTY;
-
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(uarg.ident, &ident,
 			sizeof(ident)) ? -EFAULT : 0;
@@ -374,12 +376,8 @@ static int wdt977_ioctl(struct inode *inode, struct file *file,
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, uarg.i);
 
-	case WDIOC_KEEPALIVE:
-		wdt977_keepalive();
-		return 0;
-
 	case WDIOC_SETOPTIONS:
-		if (get_user (new_options, uarg.i))
+		if (get_user(new_options, uarg.i))
 			return -EFAULT;
 
 		if (new_options & WDIOS_DISABLECARD) {
@@ -394,6 +392,10 @@ static int wdt977_ioctl(struct inode *inode, struct file *file,
 
 		return retval;
 
+	case WDIOC_KEEPALIVE:
+		wdt977_keepalive();
+		return 0;
+
 	case WDIOC_SETTIMEOUT:
 		if (get_user(new_timeout, uarg.i))
 			return -EFAULT;
@@ -407,29 +409,30 @@ static int wdt977_ioctl(struct inode *inode, struct file *file,
 	case WDIOC_GETTIMEOUT:
 		return put_user(timeout, uarg.i);
 
+	default:
+		return -ENOTTY;
+
 	}
 }
 
 static int wdt977_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt977_stop();
 	return NOTIFY_DONE;
 }
 
-static const struct file_operations wdt977_fops=
-{
+static const struct file_operations wdt977_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt977_write,
-	.ioctl		= wdt977_ioctl,
+	.unlocked_ioctl	= wdt977_ioctl,
 	.open		= wdt977_open,
 	.release	= wdt977_release,
 };
 
-static struct miscdevice wdt977_miscdev=
-{
+static struct miscdevice wdt977_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &wdt977_fops,
@@ -443,51 +446,48 @@ static int __init wd977_init(void)
 {
 	int rc;
 
-	//if (!machine_is_netwinder())
-	//	return -ENODEV;
-
 	printk(KERN_INFO PFX DRIVER_VERSION);
 
-	/* Check that the timeout value is within it's range ; if not reset to the default */
-	if (wdt977_set_timeout(timeout))
-	{
+	/* Check that the timeout value is within its range;
+	   if not reset to the default */
+	if (wdt977_set_timeout(timeout)) {
 		wdt977_set_timeout(DEFAULT_TIMEOUT);
-		printk(KERN_INFO PFX "timeout value must be 60<timeout<15300, using %d\n",
-			DEFAULT_TIMEOUT);
+		printk(KERN_INFO PFX
+		      "timeout value must be 60 < timeout < 15300, using %d\n",
+							DEFAULT_TIMEOUT);
 	}
 
 	/* on Netwinder the IOports are already reserved by
 	 * arch/arm/mach-footbridge/netwinder-hw.c
 	 */
-	if (!machine_is_netwinder())
-	{
-		if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME))
-		{
-			printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				IO_INDEX_PORT);
+	if (!machine_is_netwinder()) {
+		if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
+			printk(KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								IO_INDEX_PORT);
 			rc = -EIO;
 			goto err_out;
 		}
 	}
 
 	rc = register_reboot_notifier(&wdt977_notifier);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt977_miscdev);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt977_miscdev.minor, rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						wdt977_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
-		timeout, nowayout, testmode);
+	printk(KERN_INFO PFX
+		"initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
+						timeout, nowayout, testmode);
 
 	return 0;
 
@@ -495,7 +495,7 @@ err_out_reboot:
 	unregister_reboot_notifier(&wdt977_notifier);
 err_out_region:
 	if (!machine_is_netwinder())
-	        release_region(IO_INDEX_PORT,2);
+		release_region(IO_INDEX_PORT, 2);
 err_out:
 	return rc;
 }
@@ -505,7 +505,7 @@ static void __exit wd977_exit(void)
 	wdt977_stop();
 	misc_deregister(&wdt977_miscdev);
 	unregister_reboot_notifier(&wdt977_notifier);
-	release_region(IO_INDEX_PORT,2);
+	release_region(IO_INDEX_PORT, 2);
 }
 
 module_init(wd977_init);
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 5d922fd..ed02bdb 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -381,7 +381,7 @@ static ssize_t wdtpci_write(struct file *file, const char __user *buf,
 
 			for (i = 0; i != count; i++) {
 				char c;
-				if (get_user(c, buf+i))
+				if (get_user(c, buf + i))
 					return -EFAULT;
 				if (c == 'V')
 					expect_close = 42;
@@ -428,8 +428,6 @@ static long wdtpci_ioctl(struct file *file, unsigned int cmd,
 #endif /* CONFIG_WDT_501_PCI */
 
 	switch (cmd) {
-	default:
-		return -ENOTTY;
 	case WDIOC_GETSUPPORT:
 		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
 	case WDIOC_GETSTATUS:
@@ -449,7 +447,9 @@ static long wdtpci_ioctl(struct file *file, unsigned int cmd,
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
 		return put_user(heartbeat, p);
-		}
+	default:
+		return -ENOTTY;
+	}
 }
 
 /**
