Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYBPNmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYBPNmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 08:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbYBPNm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 08:42:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:41737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbYBPNmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 08:42:25 -0500
Date: Sat, 16 Feb 2008 13:42:20 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36.1
Message-ID: <20080216134220.GA7326@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released Linux 2.4.36.1.

It includes fixes for 6 minor security issues, most of them brought
by Dann Frazier of the Debian security team. It also restores the
ability to build user-space depending on kernel headers with GCC 4.2.

As usual when dealing with security, upgrading is recommended, but
there's nothing serious enough to justify a blind rush :

CVE-2008-0007 : insufficient range checks in certain fault handlers
CVE-2007-5093 : DoS in pwc USB video driver
CVE-2007-4308 : missing permission checks in aacraid ioctls
CVE-2006-5753 : memory corruption from misinterpreted bad_inode_ops ret values
CVE-2007-2525 : memory leak when a PPPoE socket is released
CVE-2006-6054 : ext2 denial of service in presence of malformed data structures

BTW, to make it clear to those who are wondering, since some are asking :
there is no vmsplice syscall in 2.4 so the exploit published last week has
no effect there, as it is only relevant to 2.6.18+.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.36.1.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.36.1

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-v2.4.36.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-v2.4.36.y.git

Regards,
Willy

---

Summary of changes from v2.4.36 to v2.4.36.1
============================================

Willy Tarreau (4):
      Do not complain about gcc 4.2 for user-space
      i386: fix setCx86/getCx86 race in macros
      security: insufficient range checks in certain fault handlers
      Change VERSION to 2.4.36.1

dann frazier (7):
      ext2_readdir() filp->f_pos fix
      avoid semi-infinite loop when mounting bad ext2
      ext2: skip pages past number of blocks in ext2_find_entry
      memory leak when socket is release()d before PPPIOCGCHAN has been called on it
      2.4: fix memory corruption from misinterpreted bad_inode_ops return values
      2.4: [SCSI] aacraid: Fix security hole
      2.4: USB: fix DoS in pwc USB video driver

