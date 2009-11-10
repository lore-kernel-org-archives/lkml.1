Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZKJBL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZKJBL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 20:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbZKJBLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 20:11:54 -0500
Received: from kroah.org ([198.145.64.141]:45803 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbZKJBLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 20:11:47 -0500
Date: Mon, 9 Nov 2009 17:08:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.27.39
Message-ID: <20091110010831.GC8144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.27.39 kernel.  All users of the
2.6.27 kernel series are very strongly encouraged to upgrade.

The updated 2.6.27.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 -
 arch/m68k/Kconfig                      |    6 ++--
 arch/x86/ia32/ia32entry.S              |    5 +--
 arch/x86/kernel/amd_iommu_init.c       |   25 ++++++++++++++++-
 arch/x86/kvm/x86.c                     |    2 +
 drivers/acpi/scan.c                    |   12 +-------
 drivers/ata/libata-core.c              |   12 ++++----
 drivers/base/driver.c                  |    2 -
 drivers/char/Kconfig                   |    6 ++--
 drivers/input/mouse/synaptics.c        |   10 +++++++
 drivers/net/appletalk/ipddp.c          |    3 --
 drivers/net/bonding/bond_main.c        |    2 -
 drivers/net/wireless/b43/rfkill.c      |    3 +-
 drivers/net/wireless/libertas/if_usb.c |    2 -
 drivers/net/wireless/ray_cs.c          |    2 -
 drivers/scsi/dpt_i2o.c                 |    4 ++
 drivers/serial/8250_pci.c              |   11 +++++++
 fs/hfsplus/wrapper.c                   |    4 ++
 fs/nfs/client.c                        |    2 -
 fs/nfs/dir.c                           |    4 ++
 fs/nfs/direct.c                        |    1 
 fs/nfs/nfs4proc.c                      |   27 ++++++++++++++----
 fs/nfs/nfs4renewd.c                    |    6 ----
 fs/nfs/nfs4xdr.c                       |    1 
 fs/nfs/super.c                         |    1 
 fs/pipe.c                              |   41 +++++++++++++++++++++-------
 include/linux/kernel.h                 |    4 ++
 include/linux/pci_ids.h                |    3 ++
 include/net/irda/irda_device.h         |    4 ++
 kernel/printk.c                        |   19 +++++++++++--
 kernel/time/tick-sched.c               |    2 -
 kernel/timer.c                         |    1 
 mm/mempolicy.c                         |    3 +-
 net/appletalk/aarp.c                   |   16 +++++++----
 net/appletalk/ddp.c                    |   47 ++++++++++++++++-----------------
 net/sched/cls_api.c                    |    2 -
 net/unix/af_unix.c                     |    2 +
 37 files changed, 204 insertions(+), 95 deletions(-)

Alan Cox (3):
      dpt_i2o: Fix up copy*user
      ray_cs: Fix copy_from_user handling
      tty: Mark generic_serial users as BROKEN

Arnaldo Carvalho de Melo (1):
      appletalk: Fix skb leak when ipddp interface is not loaded (CVE-2009-2903)

Avi Kivity (1):
      KVM: Prevent overflow in KVM_GET_SUPPORTED_CPUID (CVE-2009-3638)

Ben Hutchings (2):
      hfsplus: refuse to mount volumes larger than 2TB
      nfs: Avoid overrun when copying client IP address string

Benjamin Herrenschmidt (1):
      8250_pci: add IBM Saturn serial card

David Woodhouse (1):
      libertas if_usb: Fix crash on 64-bit machines

Dmitry Torokhov (1):
      Input: synaptics - add another Protege M300 to rate blacklist

Earl Chew (1):
      fs: pipe.c null pointer dereference

Greg Kroah-Hartman (1):
      Linux 2.6.27.39

Jan Beulich (1):
      x86-64: Fix register leak in 32-bit syscall audting

Jiri Bohac (1):
      bonding: fix a race condition in calls to slave MII ioctls

Jiri Pirko (1):
      netlink: fix typo in initialization (CVE-2009-3612)

Joerg Roedel (2):
      x86/amd-iommu: Un__init function required on shutdown
      x86/amd-iommu: Workaround for erratum 63

KOSAKI Motohiro (1):
      mbind(): fix leak of never putback pages

Larry Finger (1):
      b43: Fix Bugzilla #14181 and the bug from the previous 'fix'

Len Brown (1):
      Revert "ACPI: Attach the ACPI device to the ACPI handle as early as possible"

OGAWA Hirofumi (1):
      dpt_i2o: Fix typo of EINVAL

Peter Zijlstra (1):
      printk: robustify printk

Samuel Ortiz (1):
      irda: Add irda_skb_cb qdisc related padding

Stas Sergeev (1):
      Driver core: fix driver_register() return value

Tejun Heo (1):
      libata: fix internal command failure handling

Terry Loftin (1):
      nfs: Panic when commit fails

Tomoki Sekiyama (1):
      AF_UNIX: Fix deadlock on connecting to shutdown socket (CVE-2009-3621)

Trond Myklebust (4):
      NFSv4: Fix a bug when the server returns NFS4ERR_RESOURCE
      NFSv4: Kill nfs4_renewd_prepare_shutdown()
      NFSv4: Fix a problem whereby a buggy server can oops the kernel
      NFSv4: The link() operation should return any delegation on the file

