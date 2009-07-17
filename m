Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZGQUg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZGQUg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZGQUgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:36:55 -0400
Received: from kroah.org ([198.145.64.141]:58240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbZGQUgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:36:55 -0400
Date: Fri, 17 Jul 2009 13:36:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/24] 2.6.30.2-stable review
Message-ID: <20090717203616.GA5013@kroah.com>
References: <20090717201639.GA14209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717201639.GA14209@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 01:16:39PM -0700, Greg KH wrote:
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.30.2-rc1.gz
> and the diffstat can be found below.

Oops, here's the diffstat.

thanks,

greg k-h


 Makefile                         |    7 +++--
 arch/alpha/include/asm/percpu.h  |    6 ++--
 arch/blackfin/kernel/irqchip.c   |   50 ++++++++-----------------------------
 arch/blackfin/kernel/setup.c     |    3 +-
 arch/blackfin/mach-common/head.S |   16 ++++++------
 arch/blackfin/mach-common/smp.c  |   13 +++++----
 arch/x86/include/asm/pci.h       |    2 +-
 block/blk-core.c                 |   10 ++++----
 drivers/block/floppy.c           |    5 +++-
 drivers/md/md.c                  |    8 ++++-
 drivers/md/raid5.c               |    3 +-
 drivers/net/tun.c                |    4 ++-
 drivers/pci/iova.c               |   26 ++++++++++++++++---
 fs/fuse/dev.c                    |    2 +-
 fs/fuse/file.c                   |    2 +-
 include/asm-generic/percpu.h     |    4 +++
 include/linux/mm.h               |    2 -
 include/linux/percpu-defs.h      |    3 +-
 include/linux/personality.h      |    5 +++-
 include/linux/security.h         |    2 +
 kernel/futex.c                   |   43 ++++++++++++++++++--------------
 kernel/resource.c                |    2 +-
 kernel/sysctl.c                  |    2 -
 lib/dma-debug.c                  |    2 +-
 mm/Kconfig                       |   19 ++++++++++++++
 mm/mmap.c                        |    3 ++
 net/ipv4/arp.c                   |    7 +----
 security/Kconfig                 |   22 +----------------
 security/security.c              |    3 --
 29 files changed, 143 insertions(+), 133 deletions(-)
