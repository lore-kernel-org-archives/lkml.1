Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbYGPWWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbYGPWWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757430AbYGPWWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:22:15 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40490 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbYGPWWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:22:15 -0400
Date: Thu, 17 Jul 2008 01:22:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.61
Message-ID: <20080716222202.GJ17329@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.60:
- CVE-2008-1669: fix SMP ordering hole in fcntl_setlk()
- CVE-2008-1673: asn1: additional sanity checking during BER decoding
- CVE-2008-2136: sit: Add missing kfree_skb() on pskb_may_pull() failure.


Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.60:

3ware Inc (1):
      3w-xxxx: Prevent data corruption

Adrian Bunk (3):
      gcc >= 4.3 is not supported
      Linux 2.6.16.61-rc1
      Linux 2.6.16.61

Al Viro (1):
      fix SMP ordering hole in fcntl_setlk() (CVE-2008-1669)

Chris Wright (1):
      asn1: additional sanity checking during BER decoding (CVE-2008-1673)

David S. Miller (2):
      [NETFILTER]: Fix warnings in ip_nat_snmp_basic.c
      sit: Add missing kfree_skb() on pskb_may_pull() failure. (CVE-2008-2136)

Heiko Carstens (1):
      Disable DETECT_SOFTLOCKUP for s390

Juergen Beisert (1):
      x86: Replace NSC/Cyrix specific chipset access macros by inlined functions.

Oliver Neukum (1):
      USB: race on disconnect in mdc800

Patrick McHardy (1):
      TCP: Fix shrinking windows with window scaling

Thomas Graf (1):
      [DECNet] fib: Fix out of bound access of dn_fib_props[]


 Makefile                                  |    2 -
 arch/i386/kernel/cpu/cpufreq/gx-suspmod.c |    1 
 arch/i386/kernel/cpu/cyrix.c              |    2 -
 arch/i386/kernel/cpu/mtrr/cyrix.c         |    1 
 arch/i386/kernel/cpu/mtrr/state.c         |    1 
 drivers/scsi/3w-xxxx.c                    |    8 ++---
 drivers/usb/image/mdc800.c                |    4 ++
 fs/cifs/asn1.c                            |   14 ++++++++++
 fs/locks.c                                |   17 +++++++++++-
 include/asm-i386/processor-cyrix.h        |   30 ++++++++++++++++++++++
 include/asm-i386/processor.h              |   11 --------
 include/asm-x86_64/processor-cyrix.h      |    2 +
 include/asm-x86_64/processor.h            |   11 --------
 include/linux/compiler.h                  |    4 ++
 lib/Kconfig.debug                         |    2 -
 net/decnet/dn_fib.c                       |    5 ++-
 net/ipv4/netfilter/ip_nat_snmp_basic.c    |   19 +++++++++++++
 net/ipv4/tcp_output.c                     |    2 -
 net/ipv6/sit.c                            |    2 -
 19 files changed, 103 insertions(+), 35 deletions(-)


