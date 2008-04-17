Return-Path: <linux-kernel-owner+w=401wt.eu-S1764779AbYDQOxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764779AbYDQOxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbYDQOxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:53:37 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:14976 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523AbYDQOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:53:35 -0400
X-IronPort-AV: E=Sophos;i="4.25,671,1199692800"; 
   d="scan'208";a="11290660"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Thu, 17 Apr 2008 07:53:33 -0700
Message-ID: <adaskxkh6s2.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Apr 2008 14:53:33.0657 (UTC) FILETIME=[CEE4D490:01C8A09A]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the first batch of things queued for 2.6.26: sparse
cleanups, new HW support for the ipath driver, IPoIB updates, and
miscellaneous fixes all over.

Arthur Jones (7):
      IB/ipath: Fix sparse warning about pointer signedness
      IB/ipath: Misc sparse warning cleanup
      IB/ipath: Provide I/O bus speeds for diagnostic purposes
      IB/ipath: Fix link up LED display
      IB/ipath: User mode send DMA header file
      IB/ipath: User mode send DMA
      IB/ipath: Misc changes to prepare for IB7220 introduction

Dave Olson (10):
      IB/ipath: Make some constants chip-specific, related cleanup
      IB/ipath: Shared context code needs to be sure device is usable
      IB/ipath: Enable 4KB MTU
      IB/ipath: HW workaround for case where chip can send but not receive
      IB/ipath: Make link state transition code ignore (transient) link recovery
      IB/ipath: Add support for IBTA 1.2 Heartbeat
      IB/ipath: Set LID filtering for HCAs that support it.
      IB/ipath: Enable reduced PIO update for HCAs that support it.
      IB/ipath: Fix check for no interrupts to reliably fallback to INTx
      IB/ipath: add calls to new 7220 code and enable in build

David Dillow (1):
      IB/srp: Enforce protocol limit on srp_sg_tablesize

Dotan Barak (3):
      IB/core: Check optional verbs before using them
      IB/mthca: Update QP state if query QP succeeds
      IB/mlx4: Update QP state if query QP succeeds

Eli Cohen (13):
      IPoIB: Use checksum offload support if available
      IB/mlx4: Add IPoIB checksum offload support
      IB/mthca: Add IPoIB checksum offload support
      IB/core: Add creation flags to struct ib_qp_init_attr
      IB/core: Add IPoIB UD LSO support
      IPoIB: Add LSO support
      IB/mlx4: Add IPoIB LSO support
      IPoIB: Add basic ethtool support
      IB/core: Add support for modify CQ
      IPoIB: Support modifying IPoIB CQ event moderation
      IB/mlx4: Add support for modifying CQ moderation parameters
      IB/mlx4: Fix race when detaching a QP from a multicast group
      IB/mlx4: Fix incorrect comment

Erez Zilber (2):
      IB/iser: Release connection resources on RDMA_CM_EVENT_DEVICE_REMOVAL event
      IB/iser: Don't change itt endianness

Harvey Harrison (1):
      IB: Replace remaining __FUNCTION__ occurrences with __func__

Hoang-Nam Nguyen (1):
      IB/ehca: Remove tgid checking

Jack Morgenstein (3):
      mlx4_core: Increase max number of QPs to 128K
      IB/mthca: Update module version and release date
      IB/mlx4: Update module version and release date

John Gregor (2):
      IB/ipath: Head of Line blocking vs forward progress of user apps
      IB/ipath: Add code for IBA7220 send DMA

Julia Lawall (1):
      RDMA/iwcm: Test rdma_create_id() for IS_ERR rather than 0

Michael Albaugh (5):
      IB/ipath: Prevent link-recovery code from negating admin disable
      IB/ipath: EEPROM support for 7220 devices, robustness improvements, cleanup
      IB/ipath: Allow old and new diagnostic packet formats
      IB/ipath: Isolate 7220-specific content
      IB/ipath: Support for SerDes portion of IBA7220

Ralph Campbell (18):
      IB/ipath: Fix byte order of pioavail in handle_errors()
      IB/ipath: Fix error recovery for send buffer status after chip freeze mode
      IB/ipath: Don't try to handle freeze mode HW errors if diagnostic mode
      IB/ipath: Make debug error message match the constraint that is checked for
      IB/ipath: Add code to support multiple link speeds and widths
      IB/ipath: Remove useless comments
      IB/ipath: Fix sanity checks on QP number of WRs and SGEs
      IB/ipath: Change the module author
      IB/ipath: Remove some useless (void) casts
      IB/ipath: Make send buffers available for kernel if not allocated to user
      IB/ipath: Use PIO buffer for RC ACKs
      IB/ipath: Fix some white space and code style issues
      IB/ipath: Add support for 7220 receive queue changes
      IB/ipath: Fix up error handling
      IB/ipath: Header file changes to support IBA7220
      IB/ipath: HCA-specific code to support IBA7220
      IB/ipath: Add IBA7220-specific SERDES initialization data
      IB/ipath: Update copyright dates for files changed in 2008

Robert P. J. Day (3):
      IB: Use shorter list_splice_init() for brevity
      RDMA/nes: Use more concise list_for_each_entry()
      IB/ipath: Fix time comparison to use time_after_eq()

Roland Dreier (31):
      IB/mthca: Formatting cleanups
      IB/mlx4: Convert "if(foo)" to "if (foo)"
      mlx4_core: Move opening brace of function onto a new line
      RDMA/amso1100: Don't use 0UL as a NULL pointer
      RDMA/cxgb3: IDR IDs are signed
      IB: Make struct ib_uobject.id a signed int
      IB/ipath: Fix sparse warning about shadowed symbol
      IB/mlx4: Endianness annotations
      IB/cm: Endianness annotations
      RDMA/ucma: Endian annotation
      RDMA/nes: Trivial endianness annotations
      RDMA/nes: Delete unused variables
      RDMA/amso1100: Start of endianness annotation
      RDMA/amso1100: Endian annotate mqsq allocator
      mlx4_core: Fix confusion between mlx4_event and mlx4_dev_event enums
      IB/uverbs: Don't store struct file * for event files
      IB/uverbs: Use alloc_file() instead of get_empty_filp()
      RDMA/nes: Remove redundant NULL check in nes_unregister_ofa_device()
      RDMA/nes: Remove unused nes_netdev_exit() function
      RDMA/nes: Use proper format and cast to print dma_addr_t
      RDMA/nes: Make symbols used only in a single source file static
      IB/ehca: Make symbols used only in a single source file static
      IB/mthca: Avoid integer overflow when dealing with profile size
      IB/mthca: Avoid integer overflow when allocating huge ICM table
      IB/ipath: Fix PCI config write size used to clear linkctrl error bits
      RDMA/nes: Remove session_id from nes_cm stuff
      IB/mlx4: Micro-optimize mlx4_ib_post_send()
      IB/core: Add support for "send with invalidate" work requests
      RDMA/amso1100: Add support for "send with invalidate" work requests
      RDMA/nes: Free IRQ before killing tasklet
      IPoIB: Handle case when P_Key is deleted and re-added at same index

Stefan Roscher (1):
      IB/ehca: Support all ibv_devinfo values in query_device() and query_port()

Tom Tucker (1):
      RDMA/amso1100: Add check for NULL reply_msg in c2_intr()

Vladimir Sokolovsky (1):
      IB/mlx4: Add support for resizing CQs

 drivers/infiniband/core/cm.c                   |   63 +-
 drivers/infiniband/core/cma.c                  |    2 +-
 drivers/infiniband/core/fmr_pool.c             |    3 +-
 drivers/infiniband/core/ucma.c                 |    2 +-
 drivers/infiniband/core/uverbs.h               |    4 +-
 drivers/infiniband/core/uverbs_cmd.c           |   14 +-
 drivers/infiniband/core/uverbs_main.c          |   28 +-
 drivers/infiniband/core/verbs.c                |   14 +-
 drivers/infiniband/hw/amso1100/c2.c            |   80 +-
 drivers/infiniband/hw/amso1100/c2.h            |   16 +-
 drivers/infiniband/hw/amso1100/c2_ae.c         |   10 +-
 drivers/infiniband/hw/amso1100/c2_alloc.c      |   12 +-
 drivers/infiniband/hw/amso1100/c2_cq.c         |    4 +-
 drivers/infiniband/hw/amso1100/c2_intr.c       |    6 +-
 drivers/infiniband/hw/amso1100/c2_mm.c         |    2 +-
 drivers/infiniband/hw/amso1100/c2_mq.c         |    4 +-
 drivers/infiniband/hw/amso1100/c2_mq.h         |    2 +-
 drivers/infiniband/hw/amso1100/c2_provider.c   |   85 +-
 drivers/infiniband/hw/amso1100/c2_qp.c         |   30 +-
 drivers/infiniband/hw/amso1100/c2_rnic.c       |   31 +-
 drivers/infiniband/hw/amso1100/c2_vq.c         |    2 +-
 drivers/infiniband/hw/amso1100/c2_wr.h         |  212 +-
 drivers/infiniband/hw/cxgb3/cxio_dbg.c         |   24 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c         |   84 +-
 drivers/infiniband/hw/cxgb3/cxio_resource.c    |   12 +-
 drivers/infiniband/hw/cxgb3/iwch.c             |    6 +-
 drivers/infiniband/hw/cxgb3/iwch.h             |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c          |  166 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.h          |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_cq.c          |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_ev.c          |   12 +-
 drivers/infiniband/hw/cxgb3/iwch_mem.c         |    6 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |   79 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.h    |    4 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c          |   42 +-
 drivers/infiniband/hw/ehca/ehca_av.c           |   31 -
 drivers/infiniband/hw/ehca/ehca_classes.h      |    2 -
 drivers/infiniband/hw/ehca/ehca_cq.c           |   19 -
 drivers/infiniband/hw/ehca/ehca_hca.c          |  129 +-
 drivers/infiniband/hw/ehca/ehca_main.c         |   19 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c         |   42 +-
 drivers/infiniband/hw/ehca/ehca_pd.c           |   11 -
 drivers/infiniband/hw/ehca/ehca_qp.c           |   51 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c         |    2 +-
 drivers/infiniband/hw/ehca/ehca_tools.h        |   16 +-
 drivers/infiniband/hw/ehca/ehca_uverbs.c       |   19 -
 drivers/infiniband/hw/ipath/Makefile           |    3 +
 drivers/infiniband/hw/ipath/ipath_7220.h       |   57 +
 drivers/infiniband/hw/ipath/ipath_common.h     |   54 +-
 drivers/infiniband/hw/ipath/ipath_debug.h      |    2 +
 drivers/infiniband/hw/ipath/ipath_diag.c       |   35 +-
 drivers/infiniband/hw/ipath/ipath_driver.c     | 1041 +++++++---
 drivers/infiniband/hw/ipath/ipath_eeprom.c     |  428 ++++-
 drivers/infiniband/hw/ipath/ipath_file_ops.c   |  176 ++-
 drivers/infiniband/hw/ipath/ipath_iba6110.c    |   51 +-
 drivers/infiniband/hw/ipath/ipath_iba6120.c    |  203 ++-
 drivers/infiniband/hw/ipath/ipath_iba7220.c    | 2571 ++++++++++++++++++++++++
 drivers/infiniband/hw/ipath/ipath_init_chip.c  |  312 ++--
 drivers/infiniband/hw/ipath/ipath_intr.c       |  656 ++++---
 drivers/infiniband/hw/ipath/ipath_kernel.h     |  304 +++-
 drivers/infiniband/hw/ipath/ipath_mad.c        |  110 +-
 drivers/infiniband/hw/ipath/ipath_qp.c         |   59 +-
 drivers/infiniband/hw/ipath/ipath_rc.c         |   67 +-
 drivers/infiniband/hw/ipath/ipath_registers.h  |  168 +-
 drivers/infiniband/hw/ipath/ipath_ruc.c        |   22 +-
 drivers/infiniband/hw/ipath/ipath_sd7220.c     | 1462 ++++++++++++++
 drivers/infiniband/hw/ipath/ipath_sd7220_img.c | 1082 ++++++++++
 drivers/infiniband/hw/ipath/ipath_sdma.c       |  790 ++++++++
 drivers/infiniband/hw/ipath/ipath_srq.c        |    5 +-
 drivers/infiniband/hw/ipath/ipath_stats.c      |   33 +-
 drivers/infiniband/hw/ipath/ipath_sysfs.c      |  104 +-
 drivers/infiniband/hw/ipath/ipath_uc.c         |    8 +-
 drivers/infiniband/hw/ipath/ipath_ud.c         |    7 +-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c  |  879 ++++++++
 drivers/infiniband/hw/ipath/ipath_user_sdma.h  |   54 +
 drivers/infiniband/hw/ipath/ipath_verbs.c      |  413 ++++-
 drivers/infiniband/hw/ipath/ipath_verbs.h      |   32 +-
 drivers/infiniband/hw/mlx4/cq.c                |  319 +++-
 drivers/infiniband/hw/mlx4/mad.c               |    2 +-
 drivers/infiniband/hw/mlx4/main.c              |   25 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |   15 +
 drivers/infiniband/hw/mlx4/qp.c                |  117 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c        |    6 +-
 drivers/infiniband/hw/mthca/mthca_cmd.h        |    1 +
 drivers/infiniband/hw/mthca/mthca_cq.c         |   14 +-
 drivers/infiniband/hw/mthca/mthca_dev.h        |   14 +-
 drivers/infiniband/hw/mthca/mthca_eq.c         |    4 +-
 drivers/infiniband/hw/mthca/mthca_mad.c        |    2 +-
 drivers/infiniband/hw/mthca/mthca_main.c       |   15 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c    |    6 +-
 drivers/infiniband/hw/mthca/mthca_profile.c    |    4 +-
 drivers/infiniband/hw/mthca/mthca_profile.h    |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c   |    5 +-
 drivers/infiniband/hw/mthca/mthca_qp.c         |   28 +-
 drivers/infiniband/hw/mthca/mthca_wqe.h        |   16 +-
 drivers/infiniband/hw/nes/nes.c                |   15 +-
 drivers/infiniband/hw/nes/nes.h                |   32 +-
 drivers/infiniband/hw/nes/nes_cm.c             |  131 +-
 drivers/infiniband/hw/nes/nes_cm.h             |   35 -
 drivers/infiniband/hw/nes/nes_hw.c             |   49 +-
 drivers/infiniband/hw/nes/nes_nic.c            |   26 +-
 drivers/infiniband/hw/nes/nes_utils.c          |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c          |   29 +-
 drivers/infiniband/ulp/ipoib/Makefile          |    3 +-
 drivers/infiniband/ulp/ipoib/ipoib.h           |   10 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   15 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   99 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  126 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   33 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |    3 +
 drivers/infiniband/ulp/iser/iser_initiator.c   |    4 +-
 drivers/infiniband/ulp/iser/iser_verbs.c       |    5 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |    7 +-
 drivers/net/mlx4/catas.c                       |    2 +-
 drivers/net/mlx4/cmd.c                         |    3 +-
 drivers/net/mlx4/cq.c                          |   72 +-
 drivers/net/mlx4/eq.c                          |    5 +-
 drivers/net/mlx4/fw.c                          |   13 +
 drivers/net/mlx4/fw.h                          |    1 +
 drivers/net/mlx4/intf.c                        |    8 +-
 drivers/net/mlx4/main.c                        |    6 +-
 drivers/net/mlx4/mcg.c                         |   12 +-
 drivers/net/mlx4/mlx4.h                        |    4 +-
 include/linux/mlx4/cmd.h                       |    2 +-
 include/linux/mlx4/cq.h                        |   19 +-
 include/linux/mlx4/device.h                    |    1 +
 include/linux/mlx4/driver.h                    |    3 +-
 include/linux/mlx4/qp.h                        |   15 +-
 include/rdma/ib_user_verbs.h                   |    5 +-
 include/rdma/ib_verbs.h                        |   35 +-
 net/sunrpc/xprtrdma/verbs.c                    |    1 -
 131 files changed, 11739 insertions(+), 2287 deletions(-)
 create mode 100644 drivers/infiniband/hw/ipath/ipath_7220.h
 create mode 100644 drivers/infiniband/hw/ipath/ipath_iba7220.c
 create mode 100644 drivers/infiniband/hw/ipath/ipath_sd7220.c
 create mode 100644 drivers/infiniband/hw/ipath/ipath_sd7220_img.c
 create mode 100644 drivers/infiniband/hw/ipath/ipath_sdma.c
 create mode 100644 drivers/infiniband/hw/ipath/ipath_user_sdma.c
 create mode 100644 drivers/infiniband/hw/ipath/ipath_user_sdma.h
 create mode 100644 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
