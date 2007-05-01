Return-Path: <linux-kernel-owner+w=401wt.eu-S1945997AbXEAVwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945997AbXEAVwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946004AbXEAVwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:52:14 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34962 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1945997AbXEAVwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:52:13 -0400
Date: Tue, 1 May 2007 23:52:12 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.50-rc1
Message-ID: <20070501215212.GD3531@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.49:
- CVE-2007-1861: [NETLINK]: Infinite recursion in netlink
- CVE-2007-2242: [IPV6]: Disallow RH0 by default


Location:
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.49:

Adrian Bunk (1):
      Linux 2.6.16.50-rc1

Al Viro (1):
      mca_nmi_hook() can be called at any point

Alexey Kuznetsov (1):
      [NETLINK]: Infinite recursion in netlink (CVE-2007-1861)

Guennadi Liakhovetski (1):
      IrDA: irttp_dup spin_lock initialisation

Jeet Chaudhuri (1):
      IrDA: Incorrect TTP header reservation

Jiri Slaby (1):
      Char: icom, mark __init as __devinit

Shaohua Li (1):
      x86 microcode: don't check the size

YOSHIFUJI Hideaki (1):
      [IPV6]: Disallow RH0 by default (CVE-2007-2242)

Zach Brown (1):
      aio: remove bare user-triggerable error printk


 Documentation/networking/ip-sysctl.txt |    9 ++++++
 Makefile                               |    2 -
 arch/i386/kernel/microcode.c           |    9 +-----
 arch/i386/mach-default/setup.c         |    2 -
 drivers/serial/icom.c                  |    4 +-
 fs/aio.c                               |    1 
 include/linux/ipv6.h                   |    9 ++++++
 include/linux/sysctl.h                 |    1 
 net/ipv4/fib_frontend.c                |   12 +++++++-
 net/ipv6/addrconf.c                    |   11 +++++++
 net/ipv6/exthdrs.c                     |   37 ++++++++++++++++++++-----
 net/irda/irttp.c                       |    5 ++-
 12 files changed, 80 insertions(+), 22 deletions(-)

