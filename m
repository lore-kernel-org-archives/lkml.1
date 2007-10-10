Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbXJJR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbXJJR6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 13:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbXJJR6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 13:58:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36780 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270AbXJJR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 13:58:45 -0400
Date: Wed, 10 Oct 2007 10:58:10 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.10
Message-ID: <20071010175810.GA13387@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.10 kernel.
It fixes a number of reported bugs, and any user of the 2.6.22 series is
encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.22.9 and 2.6.22.10

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                          |    2 -
 arch/i386/kernel/apic.c           |   10 ++---
 arch/i386/kernel/cpu/amd.c        |    7 +++
 drivers/ata/libata-core.c         |   13 +++++-
 drivers/i2c/algos/i2c-algo-bit.c  |   52 +++++++++++++++++----------
 drivers/net/ppp_mppe.c            |   14 +++----
 drivers/net/sky2.c                |   71 ++++++++++++++++++++++----------------
 drivers/net/sky2.h                |    2 -
 drivers/scsi/scsi_transport_spi.c |   28 +++++++++++---
 fs/lockd/svclock.c                |   31 ++++++++++------
 include/asm-i386/apic.h           |    2 +
 include/asm-i386/cpufeature.h     |    2 -
 kernel/sys.c                      |    2 +
 kernel/time/timer_stats.c         |    5 +-
 security/selinux/hooks.c          |    3 +
 15 files changed, 156 insertions(+), 88 deletions(-)


Summary of changes from v2.6.22.9 to v2.6.22.10
===============================================

Andi Kleen (1):
      i386: Use global flag to disable broken local apic timer on AMD CPUs.

Anton Blanchard (1):
      Fix timer_stats printout of events/sec

Chuck Ebbert (1):
      libata: update drive blacklists

David Brownell (1):
      i2c-algo-bit: Read block data bugfix

Greg Kroah-Hartman (1):
      Linux 2.6.22.10

James Bottomley (1):
      scsi_transport_spi: fix domain validation failure from incorrect width setting

Mark Lord (1):
      Fix SMP poweroff hangs

Michal Schmidt (1):
      Fix ppp_mppe kernel stack usage.

Stephen Hemminger (3):
      sky2: reduce impact of watchdog timer
      sky2: fix VLAN receive processing
      sky2: fix transmit state on resume

Stephen Smalley (1):
      SELinux: clear parent death signal on SID transitions

Trond Myklebust (2):
      NLM: Fix a circular lock dependency in lockd
      NLM: Fix a memory leak in nlmsvc_testlock

