Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZCDA0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZCDA0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZCDA0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:26:06 -0500
Received: from ozlabs.org ([203.10.76.45]:39427 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZCDA0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:26:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Subject: [PULL] cpumask updates for sparc
Date: Wed, 4 Mar 2009 10:55:58 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903041055.58464.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2450cf51a1bdba7037e91b1bcc494b01c58aaf66:
  Linus Torvalds (1):                                                       
        Revert "menu: fix embedded menu snafu"                              

are available in the git repository at:

  ssh://master.kernel.org/home/ftp/pub/scm/linux/kernel/git/rusty/linux-2.6-cpumask-for-sparc.git/ master                                                       

Rusty Russell (8):
      cpumask: Use smp_call_function_many(): sparc64
      cpumask: arch_send_call_function_ipi_mask: sparc
      cpumask: Use accessors code: sparc              
      cpumask: Use accessors code.: sparc64           
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.: sparc64
      cpumask: prepare for iterators to only go to nr_cpu_ids/nr_cpumask_bits.:sparc
      cpumask: remove cpu_coregroup_map: sparc
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): sparc

 arch/sparc/include/asm/smp_64.h      |    3 ++-
 arch/sparc/include/asm/topology_64.h |    5 -----
 arch/sparc/kernel/ds.c               |    2 +-
 arch/sparc/kernel/irq_64.c           |    4 ++--
 arch/sparc/kernel/mdesc.c            |    2 +-
 arch/sparc/kernel/prom_64.c          |    4 ++--
 arch/sparc/kernel/smp_32.c           |   19 +++++++++----------
 arch/sparc/kernel/smp_64.c           |    6 +++---
 arch/sparc/kernel/sun4d_smp.c        |   11 +++++------
 arch/sparc/kernel/sun4m_smp.c        |   10 ++++------
 arch/sparc/mm/init_64.c              |    2 +-
 arch/sparc/mm/srmmu.c                |    2 +-
 12 files changed, 31 insertions(+), 39 deletions(-)
