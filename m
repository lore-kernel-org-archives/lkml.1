Return-Path: <linux-kernel-owner+w=401wt.eu-S934119AbXEERgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119AbXEERgp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934107AbXEERgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:36:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38967 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934119AbXEERgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:36:44 -0400
Date: Sat, 5 May 2007 19:36:45 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.51-rc1
Message-ID: <20070505173645.GI8975@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Location:
ftp://ftp.kernel.org/pub/linux/kernel/people/bunk/linux-2.6.16.y/testing/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.50:

Adrian Bunk (2):
      x86_64: ACPI_CPU_FREQ must select CPU_FREQ_TABLE
      Linux 2.6.16.51-rc1

Andrew Hendry (1):
      [X.25]: Add missing sock_put in x25_receive_data

Hugh Dickins (4):
      holepunch: fix shmem_truncate_range punching too far
      holepunch: fix shmem_truncate_range punch locking
      holepunch: fix disconnected pages after second truncate
      holepunch: fix mmap_sem i_mutex deadlock

Jaroslav Kysela (1):
      [NETFILTER]: ipt_CLUSTERIP: fix oops in checkentry function

Jean Delvare (1):
      hwmon/w83627ehf: Don't redefine REGION_OFFSET

Jorge Boncompte (1):
      [NETFILTER]: ip_nat_proto_gre: do not modify/corrupt GREv0 packets through NAT


 Makefile                                              |    2 
 arch/x86_64/kernel/cpufreq/Kconfig                    |    1 
 drivers/hwmon/w83627ehf.c                             |   14 -
 include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h |   19 -
 mm/madvise.c                                          |   19 +
 mm/shmem.c                                            |  132 +++++++---
 net/ipv4/netfilter/ip_nat_proto_gre.c                 |   21 -
 net/ipv4/netfilter/ipt_CLUSTERIP.c                    |    2 
 net/x25/x25_dev.c                                     |    1 
 9 files changed, 132 insertions(+), 79 deletions(-)

