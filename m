Return-Path: <linux-kernel-owner+w=401wt.eu-S964976AbXCXIQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976AbXCXIQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 04:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992477AbXCXIQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 04:16:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:46715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964976AbXCXIQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 04:16:14 -0400
Date: Sat, 24 Mar 2007 08:15:57 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.35-pre2
Message-ID: <20070324081557.GA5854@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.35-pre2.

It contains a fix for bug in IPv6 which can be locally triggered.

Also contained in this release are the parenthesis fixes from Mariusz
Kozlowski. Those are fixes for unbalanced parenthesis in rarely used
macros, and I preferred to get them all definitely fixed at once.
The rest are other minor updates and fixes.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/testing/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.35-pre2.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.35.log

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
  http://www.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git/

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git


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

