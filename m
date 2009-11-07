Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZKGRS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZKGRS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 12:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZKGRS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 12:18:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:55558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZKGRSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 12:18:55 -0500
Date: Sat, 7 Nov 2009 17:19:00 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37.7
Message-ID: <20091107171900.GA18286@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.37.7.

It contains various fixes, among which a few null pointer
dereferences which may become security issues on systems where
mmap_min_addr is not set.

Systems with untrusted local users should upgrade, other ones
may wait.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.7.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.7

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git


Willy
---

Summary of changes from v2.4.37.6 to v2.4.37.7
============================================

Alan Cox (1):
      tty: Mark generic_serial users as BROKEN

Arjan van de Ven (2):
      net ax25: Fix signed comparison in the sockopt handler
      net: Make the copy length in af_packet sockopt handler unsigned

Arnaldo Carvalho de Melo (1):
      appletalk: Fix skb leak when ipddp interface is not loaded

Ben Hutchings (1):
      drm/r128: Add test for initialisation to all ioctls that require it

Earl Chew (1):
      fs: pipe.c null pointer dereference

Jaswinder Singh Rajput (2):
      R8169: Fix compilation error when RTL8169_DEBUG is defined
      net: Fix 64 bit DMA addressing for 8139cp and r8169

Jiri Bohac (1):
      bonding: fix a race condition in calls to slave MII ioctls

Jiri Pirko (1):
      netlink: fix typo in initialization

Stefan Seyfried (1):
      Fix Kernel 2.4 build with bash 4

Tomoki Sekiyama (1):
      AF_UNIX: Fix deadlock on connecting to shutdown socket

Willy Tarreau (1):
      Change VERSION to 2.4.37.7


