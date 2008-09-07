Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYIGKau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYIGKau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 06:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYIGKam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 06:30:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:60303 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbYIGKal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 06:30:41 -0400
Date: Sun, 7 Sep 2008 10:30:38 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.36.7
Message-ID: <20080907103038.GA11570@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Sep 2008 10:30:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've just released Linux 2.4.36.7.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/patch-2.4.36.7.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.36.7

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.36.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.36.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.36.y.git

This release fixes several minor security issues and a few not other issues.
There's normally no emergency to upgrade, but I wanted to flush the patch
queue. I've also fixed an uninitialized variable in the sky2 backport. It
might have caused random trouble to some users.

Given that most distros today ship with a version of GCC which is not
compatible with kernel 2.4, I have added a small documentation explaining
how to build an older GCC when you only have a newer one. Building a
stripped-down GCC only takes between 1 and 2 minutes on recent machines,
so it's really worth it. This doc does not cover cross-compilation.

For those interested, please check Documentation/using-newer-gcc.txt.

Willy
--
Summary of changes from v2.4.36.6 to v2.4.36.7
============================================

David S. Miller (1):
      sctp: Make sure N * sizeof(union sctp_addr) does not overflow (CVE-2008-2826)

Eugene Teo (1):
      wan: Missing capability checks in sbni_ioctl() (CVE-2008-3525)

Florin Malita (1):
      [PPPOE]: Missing result check in __pppoe_xmit().

Gilbert Ashley Gilbert (1):
      udf: fix uid/gid permissions

Herbert Xu (1):
      net pppoe: Check packet length on all receive paths

Stephen Hemminger (1):
      ipv6: use timer pending

Vlad Yasevich (2):
      sctp: Do not leak memory on multiple listen() calls
      sctp: Allow only 1 listening socket with SO_REUSEADDR

Willy Tarreau (4):
      doc: explain how to build a suitable gcc in Documentation/using-newer-gcc.txt
      sound: fix warning due to incorrect error code checking in ad1889
      sky2: fix uninitialized "mss" variable in sky2_xmit_frame()
      Change VERSION to 2.4.36.7

Xiong Wu (1):
      Correct the upto value during list conntrack information

