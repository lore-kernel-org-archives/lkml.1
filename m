Return-Path: <linux-kernel-owner+w=401wt.eu-S936851AbXGZWns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936851AbXGZWns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765911AbXGZWnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:43:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:58115 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765660AbXGZWni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:43:38 -0400
Date: Thu, 26 Jul 2007 22:43:33 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.35 released
Message-ID: <20070726224333.GA30152@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after 6 months of careful integration and testing, I'm happy to announce
availability of Linux 2.4.35.

This one contains the same fixes as 2.4.34.6, plus a small set of add-ons,
among which some new PCI IDs, more usb-storage unusual devs, support for
high-speed USB HID, updated e1000 driver, a few watchdog updates, support
for systems with no keyboard controller (mainly blades), backport of the
skge and sky2 drivers from 2.6, support for the "notsc" boot option for
some broken dual-core x86_64 systems with no HPET, and a the latest fixes
from the LVM package.

Note that I'm very conscious that 2.4 has mostly left desktop PCs and
notebooks, but it's still commonly found on servers, route reflectors or
firewalls. For this reason, I'm open to merge the small updates required to
maintain such systems running (eg: PCI IDs and such), but I will generally
refuse all patches which add support for new desktop or notebook-specific
hardware, unless the people present very convincing arguments. Those people
generally would better upgrade their systems to 2.6.

The 2.4.34.X stable branch is now closed and a new 2.4.35.X branch will open
with the first next fixes. This model has proven very efficient to provide
riskless fixes, especially in a situation where several weeks may pass before
a patch gets tested on a production environment.

This version has been tested on x86 SMP, sparc64 SMP and alpha. Please report
any unexpected problem. As usual, all feedback is welcome.

  The patch and changelog will appear soon at the following locations:
    ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
    ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.35.bz2
    ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.35
 
Enjoy,
Willy

--

Summary of changes from v2.4.35-rc1 to v2.4.35
============================================

final:
 - v2.4.34 was released as 2.4.35 with no changes.

Summary of changes from v2.4.35-pre5 to v2.4.35-rc1
============================================

Filippo Carletti (2):
      2.4.34 - VIA VT8237A support
      Add some AHCI PCI IDs

Krzysztof Strasburger (1):
      notsc support for x86_64

Lior Dotan (1):
      Fix divide by 0 in vegas_cong_avoid()

PaX Team (1):
      random device reseed bugfix, possibly security problem

Vincent Bernat (1):
      SATA update: add ICH8 PCI IDs

Willy Tarreau (2):
      Documentations/SubmittingPatches was outdated
      Change VERSION to 2.4.35-rc1

Summary of changes from v2.4.35-pre4 to v2.4.35-pre5
============================================

Brian Maly (1):
      fix 'pc_keyb: controller jammed (0xA7)' error on systems with KVM

Willy Tarreau (7):
      do not mark init_idle() __init
      Bluetooth: correct fix for CVE-2007-1353
      [BACKPORT] Bluetooth: Fix NULL pointer dereference in HCI line discipline
      [BACKPORT] Bluetooth: Fix unintentional fall-through in HCI line discipline
      lvm: update to latest fixes from the LVM package
      lvm: do not update extent count if snapshot allocation fails
      Change VERSION to 2.4.35-pre5

Summary of changes from v2.4.35-pre3 to v2.4.35-pre4
============================================

Urs Thermann (1):
      recent patch to fib_semantics broke build

Willy Tarreau (1):
      Change VERSION to 2.4.35-pre4

Summary of changes from v2.4.35-pre2 to v2.4.35-pre3
============================================

Adrian Bunk (1):
      init/main.c: remove comment that gcc 4 was not supported

Alexey Korolev (1):
      Linux 2.4.x MTD CFI P30/P33 support

Tal Kelrich (2):
      2.6 backport of Watchdog wdt83627 (Winbond W83627HF/F/HG/G) driver
      Watchdog w83977ef (Winbond W83977EF) driver

Willy Tarreau (6):
      [DECNet] fib: Fix out of bound access of dn_fib_props[]
      [IPv4] fib: Fix out of bound access of fib_props[]
      [PPP]: Don't leak an sk_buff on interface destruction.
      Fix TCP receiver side SWS handling
      [Bluetooth] Fix L2CAP and HCI setsockopt() information leaks (CVE-2007-1353)
      Change VERSION to v2.4.35-pre3

Summary of changes from v2.4.35-pre1 to v2.4.35-pre2
============================================

Andrzej Stypula (2):
      fix channel balance on TV cards with LG head
      fix build of serial with DEBUG enabled

Gilles Espinasse (2):
      usb-storage: backport unusual_devs from 2.6.20
      usb-storage: HP-FDC-GOLD need US_FL_SINGLE_LUN

Krzysztof Strasburger (3):
      make it possible to compile x86_64 without VT support
      add nforce-MCP55 chipset ID
      restore ability to set disk geometry on command line

Mariusz Kozlowski (24):
      arm: dma-arc add missing parenthesis
      add missing parenthesis in pci-v320usc
      amijoy joystick parenthesis fix
      rio parenthesis fix
      serial_amba parenthesis fix
      ide legacy hd parenthesis fix
      ide serverworks parenthesis fix
      message fusion parenthesis fix
      net wavelan parenthesis fix
      scsi 53c7,8xx parenthesis fix
      scsi 53c7xx parenthesis fix
      scsi aic7xxx parenthesis fix
      video pm3fb parenthesis fix
      video sis parenthesis fix
      fs ufs macro parenthesis fix
      arm sa1100 parenthesis fix
      mips/mips64 mv64340 parenthesis fixes
      mips64 klconfig parenthesis fix
      parisc pdc parenthesis fix
      ppc m48t35 parenthesis fix
      ppc ppc4xx_dma parenthesis fix
      sparc64 dma parenthesis fixes
      byteorder swab parenthesis fix
      reiserfs parenthesis fix

Pete Zaitcev (1):
      usb 2.4: Support high-speed HID

Willy Tarreau (6):
      ia64 kernel entry fix
      add missing parenthesis in video/cyberfb
      fix missing parenthesis in unused macro in ip_nat_standalone
      remove excess parenthesis in video/cyberfb
      IPV6: ipv6_fl_socklist is inadvertently shared.
      Change VERSION to v2.4.35-pre2

Summary of changes from v2.4.34 to v2.4.35-pre1
============================================

Christian Praehauser (1):
      [NET] ethernet: Fix first packet goes out with MAC 00:00:00:00:00:00

dann frazier (1):
      smbfs: fix problems introduced by last security backport

Jesse Brandeburg (3):
      e1000: integrate latest 2.4 linux driver
      [MAINTAINERS]: update e1000 maintainers
      e1000: update README

Oliver Neukum (1):
      proper locking on disconnect for mdc800

Willy Tarreau (2):
      merge 2.6 backport of skge/sky2 network drivers
      Change VERSION to 2.4.35-pre1

