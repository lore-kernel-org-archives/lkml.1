Return-Path: <linux-kernel-owner+w=401wt.eu-S1755412AbZHMW0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbZHMW0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbZHMW0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:26:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:54488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbZHMW0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:26:14 -0400
Date: Thu, 13 Aug 2009 22:26:15 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37.5
Message-ID: <20090813222615.GA5675@hera.kernel.org>
Reply-To: Willy Tarreau <w@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 13 Aug 2009 22:26:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've just released Linux 2.4.37.5.

I wanted to delay it a bit more to wait for other fixes to be ready
to be merged, but a very old vulnerability has recently been discovered,
and a local exploit is already circulating, though it does not work as-is
on 2.4, hehe ;-)

Thus I preferred to release 2.4.37.5 now so that users have the time
to patch before someone figures how to modify the exploit to get it
to work on 2.4. The issue only affects systems with untrusted local
users. For those who don't have time to revalidate and upgrade, just
set /proc/sys/vm/mmap_min_addr to 4096 or more, as it is enough to
stop the exploit, and is recommended anyway, unless you know that it
breaks one very old legacy application.

A few minor build issues have also been fixed BTW.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.5.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.5

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git


Willy
--
Summary of changes from v2.4.37.4 to v2.4.37.5
============================================

Willy Tarreau (5):
      build: fix for "make rpm" on RH9
      build: fix genksyms segfault in pcigame.c
      build: do not let genksyms silently fail anymore
      net: fix possible NULL dereference in sock_sendpage()
      Change VERSION to 2.4.37.5

