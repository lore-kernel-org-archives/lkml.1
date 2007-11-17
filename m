Return-Path: <linux-kernel-owner+w=401wt.eu-S1765583AbXKQThL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765583AbXKQThL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 14:37:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbXKQTg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 14:36:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:46471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbXKQTg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 14:36:58 -0500
Date: Sat, 17 Nov 2007 19:36:57 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36-pre2
Message-ID: <20071117193657.GA4233@hera.kernel.org>
Reply-To: w@1wt.eu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.4.36-pre2.

Basically, it gets in sync with 2.4.35.4, and adds DMA support for
2 PCI IDE chipsets (ICH7 and JMicron 20363).

There's just the adutux driver pending before 2.4.36. I plan to issue
2.4.36-rc1 in about 2-3 weeks (first week of december), and -final the
following week if nothing goes wrong till there.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.36-pre2.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.36.log

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
  http://www.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git/

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git


Regards,
Willy
---

Summary of changes from v2.4.36-pre1 to v2.4.36-pre2
============================================

Andi Kleen (1):
      x86_64: Make sure to validate all 64bits of ptrace information

Franck Bourdonnec (1):
      fix missing MODULE_LICENSE in some drivers

Gilles Espinasse (1):
      fix unresolved symbols on alpha

Moritz Muehlenhoff (1):
      corrupted cramfs filesystems cause kernel oops (CVE-2006-5823)

Stephen Hemminger (1):
      Bridge STP timer fixes

Tony Battersby (1):
      sym53c8xx_2 SMP deadlock on driver load

Willy Tarreau (3):
      ATM: avoid kernel panic upon access to /proc/net/atm/arp
      PPP: fix crash using usb-serial on high speed devices
      Change VERSION to 2.4.36-pre2

dann frazier (4):
      [OpenPROM]: Fix signedness bug in openprom char driver
      [OpenPROM]: Fix user-access checking bugs in openpromfs
      [OpenPROM] Prevent overflow of sprintf buffer
      [OpenPROM] Prevent unsigned roll-overs in

ivaylo@bglans.net (2):
      IDE: enable support for JMicron 20363
      IDE: enable PATA UDMA support for ICH7

