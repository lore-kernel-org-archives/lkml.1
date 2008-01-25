Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYAYW12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYAYW12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYAYW1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:27:07 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:11822 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbYAYW1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:27:04 -0500
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] First InfiniBand/RDMA merge
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 25 Jan 2008 14:22:42 -0800
Message-ID: <ada3asllf4d.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Jan 2008 22:22:43.0543 (UTC) FILETIME=[CDFDD670:01C85FA0]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, if you haven't headed off to the airport, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

To get the first batch of InfiniBand/RDMA merges:

Adrian Bunk (1):
      IB/mthca: Remove MSI support as scheduled

Anton Blanchard (1):
      IB/ehca: Use round_jiffies() for EQ polling timer

Arthur Jones (2):
      IB/ipath: Better comment for rmb() in ipath_intr()
      IB/ipath: Add ipath_read_ireg() abstraction

Dave Olson (9):
      IB/ipath: Improve interrupt handler cache footprint
      IB/ipath: Generalize some xxx_SHIFT macros
      IB/ipath: Changes for fields moving from devdata to portdata
      IB/ipath: Clean up some comments
      IB/ipath: Drop support for the original QHT7040 board
      IB/ipath: Remove unused MDIO interface code
      IB/ipath: Add new chip-specific functions to older chips, consistent init
      IB/ipath: Minor cleanup of unused fields and chip-specific errors
      IB/ipath: Changes to support PIO bandwidth check on IBA7220

David Dillow (3):
      IB/srp: Respect target credit limit
      IB/srp: Enable SG list chaining
      IB/srp: Add identifying information to log messages

Erez Zilber (3):
      IB/iser: update URLs of iSER docs
      IB/iser: Print information about unhandled RDMA CM events
      IB/iser: Add change_queue_depth method

Hoang-Nam Nguyen (4):
      IB/ehca: Forward event client-reregister-required to registered clients
      IB/ehca: Remove CQ-QP-link before destroying QP in error path of create_qp()
      IB/ehca: Define array to store SMI/GSI QPs
      IB/ehca: Add "port connection autodetect mode"

Jack Morgenstein (1):
      mlx4_core: Fix max_eqs masking in QUERY_DEV_CAP

Jan Engelhardt (2):
      IPoIB: Constify seq_operations function pointer tables
      IB/ipath: Remove unnecessary cast

Joachim Fenkes (1):
      IB/ehca: Prevent RDMA-related connection failures on some eHCA2 hardware

Joe Perches (2):
      drivers/infiniband: Add missing "space"
      IB: Spelling fixes in comments

John Gregor (1):
      IB/ipath: Fix sendctrl locking

Krishna Kumar (1):
      IPoIB: Remove redundant check of netif_queue_stopped() in xmit handler

Matthias Kaehlcke (1):
      IB/ipath: Convert ipath_eep_sem semaphore to a mutex

Michael Albaugh (1):
      IB/ipath: New sysfs entries to control 7220 features

Nick Piggin (1):
      IB/ipath: Convert from .nopage to .fault

Olaf Kirch (2):
      IB/fmr_pool: Flush serial numbers can get out of sync
      IB/fmr_pool: ib_fmr_pool_flush() should flush all dirty FMRs

Oliver Pinter (1):
      IB/iser: Typo fix (s/destory/destroy/)

Pradeep Satyanarayana (2):
      IPoIB/cm: Add connected mode support for devices without SRQs
      IPoIB/CM: Enable SRQ support on HCAs that support fewer than 16 SG entries

Ralph Campbell (16):
      IB/mad: Remove redundant NULL pointer check in ib_mad_recv_done_handler()
      IB/ipath: Enable loopback of DR SMP responses from userspace
      IB/ipath: Remove dead code for user process waiting for send buffer
      IB/ipath: Fix error returned from ib_resize_cq if new size smaller than # entries
      IB/ipath: Fix comments for ipath_create_srq()
      IB/ipath: Add the work completion error code to the QP error debug output
      IB/ipath: Fix RNR NAK handling
      IB/ipath: Cleanup ipath_get_egrbuf()
      IB/ipath: kreceive uses portdata rather than devdata
      IB/ipath: MAD performance sampling registers support
      IB/ipath: Export hardware counters more consistently
      IB/ipath: Allow more flexible user register alignments
      IB/ipath: Port config has on-chip effects for 7220
      IB/ipath: Add flag and handling for chips with swapped register bug
      IB/ipath: Add mappings from HW register to PortInfo port physical state
      IB/ipath: Trivial simplification of ipath_make_ud_req()

Roland Dreier (10):
      IB/ipath: Fix crash on unload introduced by sysfs changes
      IPoIB: Trivial formatting cleanups
      IPoIB/cm: Factor out ipoib_cm_free_rx_ring()
      IPoIB/cm: Factor out ipoib_cm_create_srq()
      IPoIB/cm: Factor out ipoib_cm_free_rx_reap_list()
      IB/mlx4: Micro-optimize mlx4_ib_poll_one()
      RDMA/cxgb3: Endianness annotation for irs field
      IB/ipath: Fix some sparse warnings about shadowed symbols
      IB/umad: Simplify and fix locking
      IB/mthca: Update latest "native Arbel" firmware revision

Rolf Manderscheid (1):
      IPoIB: improve IPv4/IPv6 to IB mcast mapping functions

Sean Hefty (6):
      IB/multicast: Report errors on multicast groups if P_key changes
      IB/mad: Report number of times a mad was retried
      IB/cm: Add basic performance counters
      IB/mad: Fix incorrect access to items on local_list
      RDMA/cma: add support for rdma_migrate_id()
      RDMA/cma: Override default responder_resources with user value

Steve Welch (1):
      IB/mad: Enable loopback of DR SMP responses from userspace

Steve Wise (7):
      RDMA/iwcm: Set initiator depth and responder resources to device max values
      RDMA/cxgb3: Hold rtnl_lock() around ethtool get_drvinfo call
      RDMA/cxgb3: Support version 5.0 firmware
      RDMA/cxgb3: Flush the receive queue when closing
      RDMA/cxgb3: Fix page shift calculation in build_phys_page_list()
      RDMA/cxgb3: Mark QP as privileged based on user capabilities
      RDMA/cxgb3: Fix the T3A workaround checks

Vladimir Sokolovsky (1):
      RDMA/cma: Reenable device removal on passive side

 Documentation/feature-removal-schedule.txt     |   10 -
 drivers/infiniband/core/cm.c                   |  306 ++++++++++++++++-
 drivers/infiniband/core/cma.c                  |   60 ++--
 drivers/infiniband/core/fmr_pool.c             |   33 ++-
 drivers/infiniband/core/mad.c                  |   26 +-
 drivers/infiniband/core/mad_priv.h             |    3 +-
 drivers/infiniband/core/mad_rmpp.c             |    2 +-
 drivers/infiniband/core/multicast.c            |   55 +++-
 drivers/infiniband/core/smi.h                  |   18 +-
 drivers/infiniband/core/ucm.c                  |   37 +--
 drivers/infiniband/core/ucma.c                 |   92 +++++
 drivers/infiniband/core/user_mad.c             |  115 +++----
 drivers/infiniband/hw/cxgb3/cxio_hal.c         |    4 +-
 drivers/infiniband/hw/cxgb3/cxio_wr.h          |    5 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_mem.c         |    7 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |    7 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c          |   29 +--
 drivers/infiniband/hw/ehca/ehca_av.c           |    2 +-
 drivers/infiniband/hw/ehca/ehca_classes.h      |   23 ++-
 drivers/infiniband/hw/ehca/ehca_cq.c           |    2 +-
 drivers/infiniband/hw/ehca/ehca_irq.c          |   38 ++-
 drivers/infiniband/hw/ehca/ehca_iverbs.h       |    2 +
 drivers/infiniband/hw/ehca/ehca_main.c         |   15 +-
 drivers/infiniband/hw/ehca/ehca_qp.c           |  180 +++++++++-
 drivers/infiniband/hw/ehca/ehca_reqs.c         |  112 +++++--
 drivers/infiniband/hw/ehca/ehca_sqp.c          |    6 +-
 drivers/infiniband/hw/ipath/ipath_common.h     |   35 ++-
 drivers/infiniband/hw/ipath/ipath_cq.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_debug.h      |    4 +-
 drivers/infiniband/hw/ipath/ipath_driver.c     |  180 ++++------
 drivers/infiniband/hw/ipath/ipath_eeprom.c     |   23 +-
 drivers/infiniband/hw/ipath/ipath_file_ops.c   |   94 +++---
 drivers/infiniband/hw/ipath/ipath_fs.c         |   14 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c    |  395 +++++++++++++++++++---
 drivers/infiniband/hw/ipath/ipath_iba6120.c    |  439 +++++++++++++++++++-----
 drivers/infiniband/hw/ipath/ipath_init_chip.c  |   67 ++---
 drivers/infiniband/hw/ipath/ipath_intr.c       |   81 ++---
 drivers/infiniband/hw/ipath/ipath_kernel.h     |  201 ++++++++---
 drivers/infiniband/hw/ipath/ipath_keys.c       |    5 +-
 drivers/infiniband/hw/ipath/ipath_mad.c        |  123 ++++---
 drivers/infiniband/hw/ipath/ipath_qp.c         |    6 +-
 drivers/infiniband/hw/ipath/ipath_rc.c         |   18 +-
 drivers/infiniband/hw/ipath/ipath_registers.h  |   33 +-
 drivers/infiniband/hw/ipath/ipath_ruc.c        |   13 +-
 drivers/infiniband/hw/ipath/ipath_srq.c        |    4 +-
 drivers/infiniband/hw/ipath/ipath_stats.c      |   24 +-
 drivers/infiniband/hw/ipath/ipath_sysfs.c      |  364 ++++++++++++++++++++
 drivers/infiniband/hw/ipath/ipath_ud.c         |    3 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c      |   55 ++-
 drivers/infiniband/hw/ipath/ipath_verbs.h      |   12 +
 drivers/infiniband/hw/mlx4/cq.c                |    9 +-
 drivers/infiniband/hw/mthca/mthca_dev.h        |   13 +-
 drivers/infiniband/hw/mthca/mthca_eq.c         |    6 +-
 drivers/infiniband/hw/mthca/mthca_main.c       |   40 +--
 drivers/infiniband/ulp/ipoib/ipoib.h           |  184 ++++++----
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  376 +++++++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_fs.c        |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   60 ++--
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |   18 +-
 drivers/infiniband/ulp/iser/Kconfig            |    4 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c       |    1 +
 drivers/infiniband/ulp/iser/iser_initiator.c   |    2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c       |    8 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |  131 +++++---
 drivers/infiniband/ulp/srp/ib_srp.h            |    5 +
 drivers/net/mlx4/fw.c                          |    2 +-
 include/net/if_inet6.h                         |   11 +-
 include/net/ip.h                               |   10 +-
 include/rdma/ib_mad.h                          |    4 +-
 include/rdma/rdma_user_cm.h                    |   13 +-
 net/ipv4/arp.c                                 |    2 +-
 net/ipv6/ndisc.c                               |    2 +-
 75 files changed, 3124 insertions(+), 1185 deletions(-)
