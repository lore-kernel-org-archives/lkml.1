Return-Path: <linux-kernel-owner+w=401wt.eu-S934430AbXHWAIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbXHWAIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932535AbXHWAIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:08:15 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53559 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362AbXHWAIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:08:14 -0400
Date: Wed, 22 Aug 2007 17:06:27 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.5
Message-ID: <20070823000627.GA4845@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.5 kernel.
It contains a number of bugfixes and all users of the 2.6.22 series are
encouraged to upgrade to it.

I'll also be replying to this message with a copy of the patch between
2.6.22.4 and 2.6.22.5

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Documentation/kernel-parameters.txt     |    5 --
 Makefile                                |    2 
 arch/i386/Makefile                      |    4 -
 arch/i386/kernel/Makefile               |    1 
 arch/i386/kernel/cpu/perfctr-watchdog.c |    4 +
 arch/i386/kernel/doublefault.c          |   13 +++---
 arch/i386/kernel/legacy_serial.c        |   67 --------------------------------
 arch/i386/kernel/sysenter.c             |    4 +
 arch/x86_64/Makefile                    |    4 -
 arch/x86_64/kernel/Makefile             |    2 
 arch/x86_64/kernel/head.S               |    3 -
 drivers/acpi/events/evgpeblk.c          |    4 +
 drivers/acpi/tables/tbfadt.c            |   44 ++++++++++++---------
 drivers/ata/ahci.c                      |    5 +-
 drivers/hwmon/smsc47m1.c                |    2 
 drivers/hwmon/w83781d.c                 |    4 -
 drivers/net/forcedeth.c                 |   10 ++--
 drivers/net/r8169.c                     |   18 ++++----
 drivers/net/sky2.c                      |   49 ++++++++++++++---------
 drivers/serial/Kconfig                  |   14 ++----
 fs/jffs2/write.c                        |    3 +
 include/asm-avr32/atomic.h              |    4 -
 include/asm-i386/serial.h               |   16 +++++++
 include/asm-x86_64/serial.h             |   16 +++++++
 kernel/power/snapshot.c                 |    3 -
 25 files changed, 146 insertions(+), 155 deletions(-)

Summary of changes from v2.6.22.4 to v2.6.22.5
==============================================

Andi Kleen (3):
      x86_64: Check for .cfi_rel_offset in CFI probe
      x86_64: Change PMDS invocation to single macro
      i386: Handle P6s without performance counters in nmi watchdog

Andrew Morton (1):
      revert "x86, serial: convert legacy COM ports to platform devices"

Bob Moore (2):
      ACPICA: Fixed possible corruption of global GPE list
      ACPICA: Clear reserved fields for incoming ACPI 1.0 FADTs

Chuck Ebbert (1):
      i386: Fix double fault handler

David Woodhouse (1):
      JFFS2 locking regression fix.

Francois Romieu (1):
      r8169: avoid needless NAPI poll scheduling

Greg Kroah-Hartman (1):
      Linux 2.6.22.5

Haavard Skinnemoen (1):
      AVR32: Fix atomic_add_unless() and atomic_sub_unless()

Jan Beulich (1):
      i386: allow debuggers to access the vsyscall page with compat vDSO

Jean Delvare (1):
      hwmon: (smsc47m1) restore missing name attribute

Mark M. Hoffman (1):
      hwmon: fix w83781d temp sensor type setting

Rafael J. Wysocki (1):
      Hibernation: do not try to mark invalid PFNs as nosave

Stephen Hemminger (4):
      sky2: restore workarounds for lost interrupts
      sky2: carrier management
      sky2: check for more work before leaving NAPI
      sky2: check drop truncated packets

Timo Jantunen (1):
      forcedeth: fix random hang in forcedeth driver when using netconsole

su henry (1):
      libata: add ATI SB700 device IDs to AHCI driver

