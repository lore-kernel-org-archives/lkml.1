Return-Path: <linux-kernel-owner+w=401wt.eu-S1757241AbYKIXsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbYKIXsB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 18:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbYKIXrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 18:47:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:59910 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbYKIXrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 18:47:51 -0500
Date: Sun, 9 Nov 2008 23:47:47 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37-rc2
Message-ID: <20081109234747.GA15813@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 09 Nov 2008 23:47:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.37-rc2.

Most of the patches here are to get in sync with the fixes in 2.4.36.9.
A few more SATA controller PCI IDs have been brought from 2.6 after
some machines were found to have theirs undetected.

A few Geode-specific drivers have finally been backported because a
few users asked where to find the ones I was using in my own kernels,
so I figured that it made sense to merge them. Those drivers are for
the watchdog timer, the random number generator and the I2C controller.
Nothing outstanding, but still pretty useful in embedded systems. The
rest is mostly doc updates.

Everything builds fine and runs without trouble, and I have nothing
left in the pipe, so it is very likely that this version will become
-final in a few weeks if no new problem arises. I'm pretty confident
in fact, since I've been running 37-rc on some production systems for
some time now ;-)

Once 2.4.37 is out, I might issue 1 or maybe 2 more 2.4.36 releases if
major issues are discovered, but not more ; differences between 2.4.36
and 2.4.37 are pretty dim, so there's no likely reason for a regression,
and certainly no excuse for not giving it a try now.

Also, now that Adrian has announced long term support on 2.6.27, next
year's goal will be to help 2.4 users migrate to 2.6.27, and try to
identify remaining obstacles. Indeed, if 2.6.27 follows the same trend
as 2.6.16, it's possible that it reaches the same reliability as 2.4
one year from now.

For the time being, please test 2.4.37-rc2, especially if you're planning
to upgrade some machines to SATA, in case your controller does not work.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.37-rc2.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.37.log

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
  http://www.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git/

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git

Regards,
Willy
--

Summary of changes from v2.4.37-rc1 to v2.4.37-rc2
============================================

Andy Gospodarek (1):
      bonding: fix panic when taking bond interface down before removing module

Arjan van de Ven (1):
      security: avoid calling a NULL function pointer in drivers/video/tvaudio.c

Ayaz Abdulla (1):
      forcedeth: fix checksum flag

David Miller (1):
      net: Fix recursive descent in __scm_destroy().

Eric Sandeen (1):
      ext: Avoid printk floods in the face of directory

Eric Sesterhenn (1):
      hfsplus: fix Buffer overflow with a corrupted image

Erik Inge Bolsø (1):
      doc: mention chain-compiling for really old gccs

Eugene Teo (2):
      CVE-2008-3275 Linux kernel local filesystem DoS
      Remove suid/sgid bits on truncate() (CVE-2008-4210)

Gilles Espinasse (1):
      tcp: Clear probes_out more aggressively in tcp_ack().

Ilpo Järvinen (1):
      netfilter: snmp nat leaks memory in case of failure

Jean Delvare (2):
      i2c: The i2c mailing list is moving
      i2c: Update comment of I2C_FUNC_SMBUS_*_I2C_BLOCK

Jouke Witteveen (1):
      sanitise mii.h for userspace

Marcel Sebek (1):
      backport vlan device unregister fix

Willy Tarreau (8):
      doc: fix examples and add suggestions about depmod
      ata_piix: get more PCI IDs in sync with 2.6 (ICH9/ICH10)
      i386: add configuration option for AMD Geode GX/LX
      i2c: add support for Geode Companion CS5535/5536 to scx200_acb
      i386: add support for AMD Geode MFGPT timers
      wdt: add support for AMD Geode GX/LX watchdog
      char: add support for AMD Geode LX hardware RNG
      Change VERSION to 2.4.37-rc2

Yasuyuki KOZAKAI (1):
      netfilter: ip6t_{hbh,dst}: Rejects not-strict mode on rule insertion

