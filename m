Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbZIOTIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbZIOTIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbZIOTH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:07:57 -0400
Received: from kroah.org ([198.145.64.141]:35813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbZIOTHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:07:22 -0400
Date: Tue, 15 Sep 2009 11:07:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.30.7
Message-ID: <20090915180748.GC32060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.30.7 kernel.  All users of the
2.6.30 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.30.6 and 2.6.30.7

The updated 2.6.30.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.30.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                            |    2 
 arch/sparc/include/asm/pgtable_64.h |   12 +++-
 arch/sparc/kernel/irq_64.c          |    2 
 arch/sparc/kernel/ktlb.S            |   42 +++++++++++++++--
 arch/sparc/kernel/nmi.c             |    2 
 arch/sparc/kernel/sys32.S           |    2 
 arch/sparc/mm/init_64.c             |   43 +++++++++--------
 arch/sparc/mm/init_64.h             |    7 ++
 arch/sparc/prom/misc_64.c           |    2 
 arch/sparc/prom/printf.c            |    7 +-
 drivers/md/dm-exception-store.c     |   13 +++++
 drivers/md/dm-exception-store.h     |    4 +
 drivers/md/dm-raid1.c               |    8 ++-
 drivers/md/dm-snap-persistent.c     |   88 +++++++++++++++++++++---------------
 drivers/net/e100.c                  |    2 
 drivers/net/ppp_generic.c           |   34 +++++++------
 drivers/net/pppol2tp.c              |    1 
 drivers/pci/iov.c                   |   23 +++++++++
 drivers/pci/pci.h                   |   13 +++++
 drivers/pci/setup-bus.c             |    4 -
 drivers/pci/setup-res.c             |    6 +-
 drivers/scsi/sd.c                   |   45 ++++++++----------
 fs/jffs2/wbuf.c                     |   10 ++++
 fs/nilfs2/btnode.c                  |    2 
 mm/slub.c                           |    4 -
 net/core/net_namespace.c            |    2 
 net/dccp/proto.c                    |    1 
 net/ipv4/ip_gre.c                   |    2 
 sound/pci/oxygen/oxygen_lib.c       |    3 +
 sound/pci/oxygen/oxygen_pcm.c       |    2 
 30 files changed, 264 insertions(+), 124 deletions(-)

Ben McKeegan (1):
      ppp: fix lost fragments in ppp_mp_explode() (resubmit)

Chris Wright (1):
      PCI SR-IOV: correct broken resource alignment calculations

Clemens Ladisch (2):
      sound: oxygen: handle cards with missing EEPROM
      sound: oxygen: fix MCLK rate for 192 kHz playback

David S. Miller (3):
      sparc64: Kill spurious NMI watchdog triggers by increasing limit to 30 seconds.
      sparc64: Validate linear D-TLB misses.
      sparc64: Fix bootup with mcount in some configs.

Eric Dumazet (3):
      pppol2tp: calls unregister_pernet_gen_device() at unload time
      net: net_assign_generic() fix
      slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU

Greg Kroah-Hartman (1):
      Linux 2.6.30.7

James Bottomley (1):
      SCSI: sd: fix bug in SCSI async probing

Jonathan Brassow (1):
      dm raid1: do not allow log_failure variable to unset after being set

Krzysztof Hałasa (1):
      E100: fix interaction with swiotlb on X86.

Massimo Cirillo (1):
      JFFS2: add missing verify buffer allocation/deallocation

Mathieu Desnoyers (1):
      sparc: sys32.S incorrect compat-layer splice() system call

Mikulas Patocka (4):
      dm snapshot: refactor zero_disk_area to use chunk_io
      dm snapshot: fix header corruption race on invalidation
      dm exception store: split set_chunk_size
      dm snapshot: fix on disk chunk size validation

Ryusuke Konishi (1):
      nilfs2: fix preempt count underflow in nilfs_btnode_prepare_change_key

Tom Goff (1):
      gre: Fix MTU calculation for bound GRE tunnels

Wei Yongjun (1):
      dccp: missing destroy of percpu counter variable while unload module

