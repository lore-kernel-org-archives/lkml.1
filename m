Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbZKFWFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbZKFWFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbZKFWFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:05:38 -0500
Received: from kroah.org ([198.145.64.141]:39690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760AbZKFWFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:37 -0500
Date: Fri, 6 Nov 2009 14:01:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/30] 2.6.27.39-stable review
Message-ID: <20091106220156.GA13813@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.39 release.
There are 30 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by November 8, 2009, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.39-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

------------
 Makefile                               |    2 +-
 arch/m68k/Kconfig                      |    6 ++--
 arch/x86/ia32/ia32entry.S              |    5 +--
 arch/x86/kernel/amd_iommu_init.c       |   25 ++++++++++++++++-
 arch/x86/kvm/x86.c                     |    2 +
 drivers/acpi/scan.c                    |   12 +-------
 drivers/ata/libata-core.c              |   12 +++++---
 drivers/base/driver.c                  |    2 +-
 drivers/char/Kconfig                   |    6 ++--
 drivers/input/mouse/synaptics.c        |   10 +++++++
 drivers/net/appletalk/ipddp.c          |    3 +-
 drivers/net/bonding/bond_main.c        |    2 +-
 drivers/net/wireless/b43/rfkill.c      |    3 +-
 drivers/net/wireless/libertas/if_usb.c |    2 +-
 drivers/net/wireless/ray_cs.c          |    2 +-
 drivers/scsi/dpt_i2o.c                 |    4 +++
 drivers/serial/8250_pci.c              |   11 +++++++
 fs/hfsplus/wrapper.c                   |    4 +++
 fs/nfs/client.c                        |    2 +-
 fs/nfs/dir.c                           |    4 ++-
 fs/nfs/direct.c                        |    1 +
 fs/nfs/nfs4proc.c                      |   27 +++++++++++++-----
 fs/nfs/nfs4renewd.c                    |    6 ----
 fs/nfs/nfs4xdr.c                       |    1 -
 fs/nfs/super.c                         |    1 -
 fs/pipe.c                              |   41 ++++++++++++++++++++-------
 include/linux/kernel.h                 |    4 +++
 include/linux/pci_ids.h                |    3 ++
 include/net/irda/irda_device.h         |    4 ++-
 kernel/printk.c                        |   19 +++++++++++-
 kernel/time/tick-sched.c               |    2 +-
 kernel/timer.c                         |    1 +
 mm/mempolicy.c                         |    3 +-
 net/appletalk/aarp.c                   |   16 +++++++---
 net/appletalk/ddp.c                    |   47 ++++++++++++++++---------------
 net/sched/cls_api.c                    |    2 +-
 net/unix/af_unix.c                     |    2 +
 37 files changed, 204 insertions(+), 95 deletions(-)
