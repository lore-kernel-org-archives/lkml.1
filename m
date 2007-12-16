Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbXLPXsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbXLPXsR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760225AbXLPXsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:48:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:38410 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759179AbXLPXsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:48:05 -0500
Date: Sun, 16 Dec 2007 23:48:01 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.35.5
Message-ID: <20071216234801.GA23794@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.35.5.

It simply gets up to date with 2.4.36-rc1. One important thing to
keep in mind is that I explicitly disabled the possibility to build
with GCC 4.2 because several users (me included) encountered silent
mis-compilations.

So if you think that you have built your last version with 4.2, just
check if you can build this one. If you can, then you use a correct,
older GCC version. Otherwise, you'll have to install an old one for
the moment. Anyway, this update contains enough fixes for minor to
medium vulnerabilities to justify an upgrade.

Depending on the activity in the security area during the following
weeks, this version might be the last 2.4.35.X. So if you have not
yet tried 2.4.36-rc, it is time to do so.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.35.5.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.35.5

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.35.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.35.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.35.y.git

Regards,
Willy

---

Summary of changes from v2.4.35.4 to v2.4.35.5
============================================

Jonas Danielsson (1):
      net/ipv4/arp.c: Fix arp reply when sender ip 0

Krzysztof Strasburger (1):
      fix arch/i386/config.in to be able to boot on 386

Pete Zaitcev (1):
      usb: Move linux-usb-devel

Willy Tarreau (7):
      GCC >= 4.2 miscompiles the kernel
      fix build of ia32entry.S on x86_64
      vfs: coredumping fix
      isdn: avoid copying overly-long strings
      isdn: fix isdn_ioctl memory overrun vulnerability
      prevent SIGCONT from waking up a PTRACED process (CVE-2007-4774)
      Change VERSION to 2.4.35.5

