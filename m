Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbYFMQdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbYFMQdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 12:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757335AbYFMQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 12:33:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:51557 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395AbYFMQc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 12:32:59 -0400
Date: Fri, 13 Jun 2008 16:32:25 +0000
From: Kyle McMartin <kyle@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git patches] parisc bug fixes for 2.6.26
Message-ID: <20080613163225.GA11701@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Fri, 13 Jun 2008 16:32:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Purely bugfixes (and a reversion of the section name patch since it broke
on a pile of machines.)

cheers, Kyle

The following changes since commit 5dd34572ad9a3be430632dd42e4af2ea370b397b:
  Linus Torvalds (1):
        Linux 2.6.26-rc6

are available in the git repository at:

  /pub/scm/linux/kernel/git/kyle/parisc-2.6.git master

Kyle McMartin (7):
      Revert "parisc: fix trivial section name warnings"
      parisc: move head.S to head.text section
      parisc: export copy_user_page_asm
      parisc: export empty_zero_page
      parisc: fix off by one in setup_sigcontext32
      parisc: fix miscompilation of ip_fast_csum with gcc >= 4.3
      parisc: update my email address

 MAINTAINERS                       |    8 ++++----
 arch/parisc/hpux/gate.S           |    3 +--
 arch/parisc/hpux/wrappers.S       |    3 +--
 arch/parisc/kernel/entry.S        |    3 +--
 arch/parisc/kernel/head.S         |    1 +
 arch/parisc/kernel/hpmc.S         |    3 +--
 arch/parisc/kernel/pacache.S      |    3 +--
 arch/parisc/kernel/parisc_ksyms.c |    3 +++
 arch/parisc/kernel/perf_asm.S     |    2 +-
 arch/parisc/kernel/real2.S        |   13 ++++++-------
 arch/parisc/kernel/signal32.c     |    4 ++--
 arch/parisc/kernel/syscall.S      |    5 ++---
 arch/parisc/kernel/vmlinux.lds.S  |    1 +
 arch/parisc/lib/fixup.S           |    3 +--
 arch/parisc/lib/lusercopy.S       |    5 ++---
 arch/parisc/mm/init.c             |    1 +
 include/asm-parisc/checksum.h     |    2 +-
 17 files changed, 30 insertions(+), 33 deletions(-)
