Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbXJLBJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbXJLBJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 21:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXJLBIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 21:08:55 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:39385 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbXJLBIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 21:08:54 -0400
X-IronPort-AV: E=Sophos;i="4.21,262,1188802800"; 
   d="scan'208";a="405813458"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git for-linus
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 11 Oct 2007 18:08:52 -0700
Message-ID: <aday7e9b0m3.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Oct 2007 01:08:53.0280 (UTC) FILETIME=[74A17A00:01C80C6C]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the batch of changes queued up for the 2.6.24 merge
window (although I still have a few more things to merge later, once
Dave Miller's networking tree has landed too):

Ali Ayoub (1):
      IB/sa: Error handling thinko fix

Anton Blanchard (3):
      IB/fmr_pool: Clean up some error messages in fmr_pool.c
      IB/ehca: Make output clearer by removing some debug messages
      IB/ehca: Export module parameters in sysfs

Arthur Jones (4):
      IB/ipath: iba6110 rev4 GPIO counters support
      IB/ipath: Use counters in ipath_poll and cleanup interrupts in ipath_close
      IB/ipath: iba6110 rev4 no longer needs recv header overrun workaround
      IB/ipath: Indicate a couple of chip bugs to userspace

Dave Olson (5):
      IB/ipath: Verify host bus bandwidth to chip will not limit performance
      IB/ipath: Correctly describe workaround for TID write chip bug
      IB/ipath: Future proof eeprom checksum code (contents reading)
      IB/ipath: Fix QHT7040 serial number check
      IB/ipath: Minor fix to ordering of freeing and zeroing of tid pages.

Dotan Barak (2):
      mlx4_core: Use enum value GO_BIT_TIMEOUT_MSECS
      IPoIB/cm: Clean up initialization of QP attr in ipoib_cm_create_tx_qp()

Eli Cohen (3):
      IPoIB: Fix typo to end statement with ';' instead of ','
      IPoIB: Fix error path memory leak
      IB/mthca: Mark error paths as unlikely() in post_srq_recv functions

Hoang-Nam Nguyen (4):
      IB/ehca: Use remap_4k_pfn() to map firmware contexts to user space
      IB/ehca: Fix large page HW cap defines
      IB/ehca: Fix mem leak of firmware ctrlblock in ehca_create_srq()
      IB/ehca: Adjust 64-bit alignment of create QP response for userspace

Jack Morgenstein (5):
      IB/mlx4:  Display misc device information under /sys/class/infiniband/
      mlx4_core: Support ICM tables in coherent memory
      mlx4_core: Write MTTs from CPU instead with of WRITE_MTT FW command
      IB/mlx4: Implement FMRs
      mlx4_core: Increase max number of QPs per multicast group to 56

Joachim Fenkes (11):
      IB/ehca: Refactor hvcall tracing
      IB/ehca: Print return codes as signed decimal integers
      IB/ehca: ehca_gen_warn() should always print
      IB/ehca: Add check for max #SGE to create_qp()
      IB/ehca: Path migration support
      IB/ehca: Serialize MR alloc and MR free hvCalls
      IB/ehca: Replace get_paca()->paca_index by the more portable raw_smp_processor_id()
      IB/ehca: Bump version number and change its format
      IB/umem: Add hugetlb flag to struct ib_umem
      IB/ehca: Only use MR large pages for hugetlb regions
      IB/ehca: Return srq_attr->max_sge in ehca_query_srq()

Michael Albaugh (2):
      IB/ipath: Maintain active time on all chips
      IB/ipath: Better handling of unexpected GPIO interrupts

Michael S. Tsirkin (2):
      mlx4_core: Enable MSI-X by default
      IB/mthca: Enable MSI-X by default

Or Gerlitz (1):
      IPoIB: Allow setting policy to ignore multicast groups

Peter Oruba (1):
      IB/mthca: Use PCI-X/PCI-Express read control interfaces

Ralph Campbell (13):
      IB/core: Fix handling of multicast response failures
      IB/ipath: Performance optimization for CPU differences
      IB/ipath: Change UD to queue work requests like RC & UC
      IB/ipath: Remove unneeded code for ipathfs
      IB/ipath: UC RDMA WRITE with IMMEDIATE doesn't send the immediate
      IB/ipath: Remove redundant code
      IB/ipath: Generate flush CQE when QP is in error state
      IB/ipath: Implement IB_EVENT_QP_LAST_WQE_REACHED
      IB/ipath: Optimize completion queue entry insertion and polling
      IB/ipath: Add ability to set the LMC via the sysfs debugging interface
      IB/ipath: Remove duplicate copy of LMC
      IB/ipath: Fix IB_EVENT_PORT_ERR event
      IB/ipath: Remove redundant link state checks

Roland Dreier (18):
      IPoIB: Make sure no receives are handled when stopping device
      IB: find_first_zero_bit() takes unsigned pointer
      mlx4_core: Don't free special QPs in QP number bitmap
      IB/mlx4: Use __set_data_seg() in mlx4_ib_post_recv()
      IB/ehca: Include <linux/mutex.h> from ehca_classes.h
      IB/mlx4: Fix up SRQ limit_watermark endianness
      IB/iser: Remove unnecessary includes
      mlx4_core: Change capability decoding: SRC->XRC
      IB/umad: Add P_Key index support
      IB/umad: Fix bit ordering and 32-on-64 problems on big endian systems
      IB/uverbs: Make ib_uverbs_release_event_file() static
      mlx4_core: Reserve the correct number of MTT segments
      mlx4_core: Fix meaning of dev->caps.reserved_mtts
      IB/mthca: Increase max number of QPs per multicast group to 56
      IB/mthca: Use mmiowb() to avoid firmware commands getting jumbled up
      mlx4_core: Use mmiowb() to avoid firmware commands getting jumbled up
      IB/ehca: Fix clipping of device limits to INT_MAX
      mlx4_core: Fix section mismatches

Satyam Sharma (1):
      IB/ehca: Misc cpuinit section annotations and #ifdef cleanups

Sean Hefty (7):
      IPoIB: Specify Traffic Class with path record queries for QoS support
      IB/sa: Add new QoS fields to path record
      RDMA/cma: Add ability to specify type of service
      RDMA/ucma: Allow user space to set service type
      IB/srp: Add QoS support through service ID
      IB/cm: Modify interface to send MRAs in response to duplicate messages
      RDMA/cma: Queue IB CM MRAs to avoid unnecessary remote retries

Stefan Roscher (2):
      IB/ehca: Small QP userspace support
      IB/ehca: Support more than 4k QPs for userspace and kernelspace

Steve Wise (2):
      RDMA/cxgb3: Make the iw_cxgb3 module parameters writable
      RDMA/cma: Use neigh_event_send() to start neighbour discovery

 Documentation/infiniband/user_mad.txt          |   14 +
 drivers/infiniband/core/addr.c                 |    3 +-
 drivers/infiniband/core/cm.c                   |   51 ++--
 drivers/infiniband/core/cma.c                  |   46 +++-
 drivers/infiniband/core/device.c               |    4 +-
 drivers/infiniband/core/fmr_pool.c             |   22 +-
 drivers/infiniband/core/multicast.c            |    2 +-
 drivers/infiniband/core/sa_query.c             |   12 +-
 drivers/infiniband/core/ucma.c                 |   74 +++++-
 drivers/infiniband/core/umem.c                 |   20 ++-
 drivers/infiniband/core/user_mad.c             |  151 +++++++---
 drivers/infiniband/core/uverbs.h               |    1 -
 drivers/infiniband/core/uverbs_main.c          |   16 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |   16 +-
 drivers/infiniband/hw/ehca/ehca_classes.h      |   14 +-
 drivers/infiniband/hw/ehca/ehca_cq.c           |   23 +-
 drivers/infiniband/hw/ehca/ehca_hca.c          |   34 +-
 drivers/infiniband/hw/ehca/ehca_irq.c          |   33 +--
 drivers/infiniband/hw/ehca/ehca_main.c         |   52 ++--
 drivers/infiniband/hw/ehca/ehca_mcast.c        |    4 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c         |  102 ++++----
 drivers/infiniband/hw/ehca/ehca_qp.c           |  169 +++++++----
 drivers/infiniband/hw/ehca/ehca_reqs.c         |    2 +-
 drivers/infiniband/hw/ehca/ehca_sqp.c          |    2 +-
 drivers/infiniband/hw/ehca/ehca_tools.h        |   19 +-
 drivers/infiniband/hw/ehca/ehca_uverbs.c       |   46 ++--
 drivers/infiniband/hw/ehca/hcp_if.c            |  105 ++++---
 drivers/infiniband/hw/ehca/ipz_pt_fn.c         |    1 +
 drivers/infiniband/hw/ipath/ipath_common.h     |    4 +-
 drivers/infiniband/hw/ipath/ipath_cq.c         |   94 +++---
 drivers/infiniband/hw/ipath/ipath_diag.c       |   22 +-
 drivers/infiniband/hw/ipath/ipath_driver.c     |   93 ++++++-
 drivers/infiniband/hw/ipath/ipath_eeprom.c     |   10 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c   |   74 +++--
 drivers/infiniband/hw/ipath/ipath_fs.c         |  187 ------------
 drivers/infiniband/hw/ipath/ipath_iba6110.c    |   57 ++--
 drivers/infiniband/hw/ipath/ipath_iba6120.c    |   18 +-
 drivers/infiniband/hw/ipath/ipath_intr.c       |   64 +++--
 drivers/infiniband/hw/ipath/ipath_kernel.h     |   12 +-
 drivers/infiniband/hw/ipath/ipath_mad.c        |   53 ++--
 drivers/infiniband/hw/ipath/ipath_qp.c         |   31 ++-
 drivers/infiniband/hw/ipath/ipath_rc.c         |   73 ++++--
 drivers/infiniband/hw/ipath/ipath_ruc.c        |  308 +++++++-------------
 drivers/infiniband/hw/ipath/ipath_stats.c      |   17 +-
 drivers/infiniband/hw/ipath/ipath_sysfs.c      |   40 +++-
 drivers/infiniband/hw/ipath/ipath_uc.c         |   98 +++----
 drivers/infiniband/hw/ipath/ipath_ud.c         |  382 ++++++++----------------
 drivers/infiniband/hw/ipath/ipath_verbs.c      |  329 ++++++++++++++-------
 drivers/infiniband/hw/ipath/ipath_verbs.h      |   45 ++-
 drivers/infiniband/hw/mlx4/main.c              |   50 +++
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |   16 +
 drivers/infiniband/hw/mlx4/mr.c                |  100 ++++++-
 drivers/infiniband/hw/mlx4/qp.c                |   14 +-
 drivers/infiniband/hw/mlx4/srq.c               |    2 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c        |    6 +
 drivers/infiniband/hw/mthca/mthca_dev.h        |    2 +-
 drivers/infiniband/hw/mthca/mthca_main.c       |  110 ++++----
 drivers/infiniband/hw/mthca/mthca_srq.c        |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |   24 ++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   18 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |    8 +
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   45 +++-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   31 +--
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |    2 +
 drivers/infiniband/ulp/iser/iser_initiator.c   |    2 -
 drivers/infiniband/ulp/iser/iser_memory.c      |    2 -
 drivers/infiniband/ulp/iser/iser_verbs.c       |    1 -
 drivers/infiniband/ulp/srp/ib_srp.c            |    2 +
 drivers/net/mlx4/cmd.c                         |   11 +-
 drivers/net/mlx4/cq.c                          |    2 +-
 drivers/net/mlx4/eq.c                          |   13 +-
 drivers/net/mlx4/fw.c                          |    2 +-
 drivers/net/mlx4/icm.c                         |  134 +++++++--
 drivers/net/mlx4/icm.h                         |    9 +-
 drivers/net/mlx4/main.c                        |  130 +++++----
 drivers/net/mlx4/mcg.c                         |    2 +-
 drivers/net/mlx4/mlx4.h                        |   10 +-
 drivers/net/mlx4/mr.c                          |  242 +++++++++++++---
 drivers/net/mlx4/pd.c                          |    2 +-
 drivers/net/mlx4/qp.c                          |    5 +-
 drivers/net/mlx4/srq.c                         |    4 +-
 include/linux/mlx4/device.h                    |   27 ++
 include/rdma/ib_cm.h                           |    7 +-
 include/rdma/ib_sa.h                           |   11 +-
 include/rdma/ib_umem.h                         |    1 +
 include/rdma/ib_user_mad.h                     |   70 +++++-
 include/rdma/rdma_cm.h                         |   14 +
 include/rdma/rdma_user_cm.h                    |   18 ++
 89 files changed, 2498 insertions(+), 1710 deletions(-)
