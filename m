Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbYBSONd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbYBSONd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYBSONZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:13:25 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:46239 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752889AbYBSONY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:13:24 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 01:06:09 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Improve init/Kconfig help descriptions [PATCH 0/9]
Message-ID: <20080219140609.GA26619@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is a series of 9 patches to init/Kconfig intended to improve the
usefulness and consistency of the help descriptions. The patches are
against linux-2.6.24.2.

Rationale:

Even though I've been using Unix for 20+ years, I find it sometimes
daunting to configure a linux kernel. The help descriptions supplied
sometimes help, and sometimes they do not.


The problems I can see with the supplied help descriptions fall into
these areas:

  - Uses arcane terminology which only kernel developers can understand

  - Inconsistently describes safe response (if unsure, ...)

  - References out-of-date external resources (404 error)

  - Description has not kept pace with recent kernel changes or standards

  - Poor grammar or layout.


My approach to improving the descriptions is to go through each option
checking the correctness of the description, validating any references
it makes, finding inconsistency with the rest of the kernel config,
and trying to improve the usefulness of the explanation. I want to
end up with:

  1 - Single sentence summary of what the option does

  2 - Explain terminology or situation if necessary and possible, linking
  to validated information sources (Documentation directory, manpages,
  scripts, URLs, Wikipedia)

  3 - Suggest safe answer for people who just don't know what to do.

The patches are in 9 parts because I wouldn't want to overwhelm any
reviewers, and also because I might have got some of them wrong. I
learned some cool things while researching these kernel options, like
what POSIX message queues are, and about the SLAB allocator, but my
grasp of cgroups and cpusets is tenuous at best. Here's a list of
the patches and the affected config options:

Patch 1
	EXPERIMENTAL
	LOCALVERSION
	LOCALVERSION_AUTO
	SWAP
	SYSVIPC
	POSIX_MQUEUE
	BSD_PROCESS_ACCT
	BSD_PROCESS_ACCT_V3

Patch 2
	TASKSTATS
	TASK_DELAY_ACCT
	TASK_XACCT
	TASK_IO_ACCOUNTING

Patch 3
	USER_NS
	PID_NS

Patch 4
	AUDIT
	AUDITSYSCALL

Patch 5
	IKCONFIG
	IKCONFIG_PROC
	LOG_BUF_SHIFT
	SYSFS_DEPRECATED
	RELAY
	BLK_DEV_INITRD

Patch 6
	CGROUPS
	CGROUP_DEBUG
	CPUSETS
	FAIR_GROUP_SCHED
	FAIR_CGROUP_SCHED
	CGROUP_CPUACCT
	PROC_PID_CPUSET

Patch 7
	EMBEDDED
	SYSCTL_SYSCALL
	KALLSYMS
	KALLSYMS_ALL
	KALLSYMS_EXTRA_PASS
	HOTPLUG
	PRINTK
	BUG
	ELF_CORE
	BASE_FULL
	FUTEX
	EPOLL
	SIGNALFD
	TIMERFD
	EVENTFD

Patch 8
	SLUB_DEBUG
	SLAB
	SLUB
	SLOB

Patch 9
	MODULES
	MODULE_UNLOAD
	MODULE_FORCE_UNLOAD
	MODVERSIONS
	MODULE_SRCVERSION_ALL
	KMOD

Changelog:

Improve usefulness and consistency of kernel configuration help messages.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
