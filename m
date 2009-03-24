Return-Path: <linux-kernel-owner+w=401wt.eu-S1759671AbZCXRj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671AbZCXRj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZCXRjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:39:18 -0400
Received: from gw.goop.org ([64.81.55.164]:37588 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbZCXRjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:39:17 -0400
Message-ID: <49C91AC3.6080506@goop.org>
Date: Tue, 24 Mar 2009 10:39:15 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: [GIT PULL] xen.git 2.6.30: usermode control interfaces
References: <49C915A3.3020809@goop.org>
In-Reply-To: <49C915A3.3020809@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 627b11ca44b334e201c35bf1a1582dc10efaf4a8:
  Jeremy Fitzhardinge (1):
        xen/mmu: weaken flush_tlb_other test

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git push2/xen/control

Ian Campbell (6):
      xen: add irq_from_evtchn
      xen: add /dev/xen/evtchn driver
      xen: export ioctl headers to userspace
      xen: drop kexec bits from /sys/hypervisor since kexec isn't implemented yet
      xen: remove suspend_cancel hook
      xen: use device model for suspending xenbus devices

Jeremy Fitzhardinge (9):
      xen/dev-evtchn: clean up locking in evtchn
      xen: add "capabilities" file
      xen: add /sys/hypervisor support
      xen/sys/hypervisor: change writable_pt to features
      xen/xenbus: export xenbus_dev_changed
      Merge branch 'push2/xen/xenbus' into push2/xen/control
      Merge branch 'push2/xen/dev-evtchn' into push2/xen/control
      Merge branch 'push2/xen/sys-hypervisor' into push2/xen/control
      Merge branch 'push2/xen/xenfs' into push2/xen/control

 drivers/xen/Kconfig               |   20 ++
 drivers/xen/Makefile              |    4 +-
 drivers/xen/events.c              |    6 +
 drivers/xen/evtchn.c              |  507 +++++++++++++++++++++++++++++++++++++
 drivers/xen/manage.c              |    9 +-
 drivers/xen/sys-hypervisor.c      |  445 ++++++++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_probe.c |   61 +----
 drivers/xen/xenbus/xenbus_xs.c    |    2 +
 drivers/xen/xenfs/super.c         |   19 ++-
 include/Kbuild                    |    1 +
 include/xen/Kbuild                |    1 +
 include/xen/events.h              |    3 +
 include/xen/evtchn.h              |   88 +++++++
 include/xen/interface/version.h   |    3 +
 include/xen/xenbus.h              |    3 +-
 15 files changed, 1112 insertions(+), 60 deletions(-)
 create mode 100644 drivers/xen/evtchn.c
 create mode 100644 drivers/xen/sys-hypervisor.c
 create mode 100644 include/xen/Kbuild
 create mode 100644 include/xen/evtchn.h


