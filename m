Return-Path: <linux-kernel-owner+w=401wt.eu-S932739AbXGLXIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739AbXGLXIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 19:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757546AbXGLXIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 19:08:04 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:47309 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328AbXGLXIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 19:08:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CADBRlkarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,534,1175497200"; 
   d="scan'208"; a="181239643:sNHT34120800"
To: torvalds@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 12 Jul 2007 16:07:59 -0700
Message-ID: <adalkdl43w0.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jul 2007 23:07:59.0463 (UTC) FILETIME=[7D6D9770:01C7C4D9]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get the first batch of changes for the 2.6.23 merge window:

Andrew Morton (1):
      IB: Fix ib_umem_get() when npages == 0

Arthur Jones (3):
      IB/ipath: Update MAINTAINERS entry
      IB/ipath: Test interrupts at driver startup
      IB/ipath: Remove bogus RD_ATOMIC checks from modify_qp

Bryan O'Sullivan (1):
      IB/ipath: Include <linux/vmalloc.h> to fix ppc64 build

Dave Olson (5):
      IB/ipath: Support the IBA6110 revision 4
      IB/ipath: Fix the mtrr_add args for chips with 2 buffer sizes
      IB/ipath: Use S_ABORT not cancel and abort on exit freeze mode after recovery
      IB/ipath: Be more cautious about coming out of freeze mode
      IB/ipath: Change version wording to be less confusing with release number

Dotan Barak (2):
      mlx4_core: Get the maximum message size from reported device capabilities
      IB/core: Take sizeof the correct pointer when calling kmalloc()

Hal Rosenstock (1):
      IB/mad: Enhance SMI for switch support

Hoang-Nam Nguyen (3):
      IB/ehca: Change scaling_code parameter description to match default value
      IB/ehca: Report RDMA atomic attributes in query_qp()
      IB/ehca: Improve latency by unlocking after triggering the hardware

Jack Morgenstein (2):
      IB/mlx4: Implement query QP
      IB/mlx4: Implement query SRQ

Jan Engelhardt (1):
      IB: Use menuconfig for InfiniBand menu

Joachim Fenkes (9):
      IB/ehca: Refactor "maybe missed event" code
      IB/ehca: HW level, HW caps and MTU autodetection
      IB/ehca: QP code restructuring in preparation for SRQ
      IB/ehca: add Shared Receive Queue support
      IB/ehca: Lock renaming, static initializers
      IB/ehca: Refactor sync between completions and destroy_cq using atomic_t
      IB/ehca: Change idr spinlocks into rwlocks
      IB/ehca: Return QP pointer in poll_cq()
      IB/ehca: Notify consumers of LID/PKEY/SM changes after nondisruptive events

Joan Eslinger (1):
      IB/ipath: Change use of constants for TID type to defined values

John Gregor (2):
      IB/ipath: Remove incompletely implemented ipath_runtime flags and code
      IB/ipath: Update copyright dates

Mark Debbage (2):
      IB/ipath: Correct checking of swminor version field when using subports
      IB/ipath: Make handling of one subport consistent

Michael Albaugh (4):
      IB/ipath: Support blinking LEDs with an led_override file
      IB/ipath: Lock and always use shadow copies of GPIO register
      IB/ipath: Log "active" time and some errors to EEPROM
      IB/ipath: Add capability to modify PBC word

Michael S. Tsirkin (2):
      IB/mlx4: Include linux/mutex.h from mlx4_ib.h
      mlx4_core: Include linux/mutex.h from mlx4.h

Ralph Campbell (10):
      IB/ipath: Fix problem with next WQE after a UC completion
      IB/ipath: Fix local loopback bug when waiting for resources
      IB/ipath: Set M bit in BTH according to IB spec
      IB/ipath: Fix RDMA read retry code
      IB/ipath: Wait for PIO available interrupt
      IB/ipath: Fix possible data corruption if multiple SGEs used for receive
      IB/ipath: Duplicate RDMA reads can cause responder to NAK inappropriately
      IB/ipath: Add barrier before updating WC head in shared memory
      IB/ipath: Lower default number of kernel send buffers
      IB/ipath: Remove support for preproduction HTX InfiniPath cards

Robert Walsh (5):
      IB/ipath: Fix maximum MTU reporting
      IB/ipath: Fill in some missing FMR-related fields in query_device
      IB/ipath: Send ACK invalid where appropriate
      IB/ipath: ipath_poll fixups and enhancements
      IB/ipath: Clean send flags properly on QP reset

Roland Dreier (5):
      IB: Remove garbage non-ASCII characters from comments
      IB: Update mailing list address
      IPoIB/cm: Fix warning if IPV6 is not enabled
      IPoIB: Recycle loopback skbs instead of freeing and reallocating
      IB: Update MAINTAINERS with Hal's new email address

Sean Hefty (7):
      IB/ipath: return correct PortGUID in NodeInfo
      IB/sa: Make sure SA queries use default P_Key
      IB/cm: Use spin_lock_irq() instead of spin_lock_irqsave() when possible
      IB/cm: Include HCA ACK delay in local ACK timeout
      IB/cm: cm_msgs.h should include ib_cm.h
      IB/cm: Fix handling of duplicate SIDR REQs
      IB/cm: Send no match if a SIDR REQ does not match a listen

Shani Moideen (1):
      IB/mthca: Replace memset(<addr>, 0, PAGE_SIZE) with clear_page(<addr>)

Stefan Roscher (2):
      IB/ehca: Support UD low-latency QPs
      IB/ehca: Set SEND_GRH flag for all non-LL UD QPs on eHCA2

Steve Wise (6):
      RDMA/cxgb3: Streaming -> RDMA mode transition fixes
      RDMA/cxgb3: TERMINATE WRs can hang the tx ofld queue
      RDMA/cxgb3: Don't count neg_adv abort_req_rss messages as real aborts
      RDMA/cxgb3: ctrl-qp init/clear shouldn't set the gen bit
      RDMA/cxgb3: Don't post TID_RELEASE message
      RDMA/cxgb3: Don't abort after failures sending the mpa reply

WANG Cong (1):
      RDMA/cxgb3: Check return of kmalloc() in iwch_register_device()

 MAINTAINERS                                       |   15 +-
 drivers/infiniband/Kconfig                        |   15 +-
 drivers/infiniband/core/agent.c                   |   19 +-
 drivers/infiniband/core/cm.c                      |  247 ++++---
 drivers/infiniband/core/cm_msgs.h                 |    1 +
 drivers/infiniband/core/cma.c                     |    1 -
 drivers/infiniband/core/mad.c                     |   50 ++-
 drivers/infiniband/core/multicast.c               |    2 +-
 drivers/infiniband/core/sa.h                      |    2 +-
 drivers/infiniband/core/sa_query.c                |   87 ++-
 drivers/infiniband/core/smi.c                     |   16 +-
 drivers/infiniband/core/smi.h                     |    2 +
 drivers/infiniband/core/sysfs.c                   |    2 +-
 drivers/infiniband/core/ucm.c                     |    1 -
 drivers/infiniband/core/umem.c                    |    1 +
 drivers/infiniband/hw/amso1100/Kconfig            |    2 +-
 drivers/infiniband/hw/cxgb3/Kconfig               |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_hal.c            |    6 +-
 drivers/infiniband/hw/cxgb3/cxio_wr.h             |    3 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c             |  108 ++--
 drivers/infiniband/hw/cxgb3/iwch_cm.h             |    1 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c       |    7 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c             |    7 +-
 drivers/infiniband/hw/ehca/Kconfig                |    2 +-
 drivers/infiniband/hw/ehca/ehca_av.c              |    6 +-
 drivers/infiniband/hw/ehca/ehca_classes.h         |   75 ++-
 drivers/infiniband/hw/ehca/ehca_classes_pSeries.h |    4 +-
 drivers/infiniband/hw/ehca/ehca_cq.c              |   50 +-
 drivers/infiniband/hw/ehca/ehca_hca.c             |   61 ++-
 drivers/infiniband/hw/ehca/ehca_irq.c             |  140 +++--
 drivers/infiniband/hw/ehca/ehca_irq.h             |    1 -
 drivers/infiniband/hw/ehca/ehca_iverbs.h          |   18 +
 drivers/infiniband/hw/ehca/ehca_main.c            |   98 +++-
 drivers/infiniband/hw/ehca/ehca_qp.c              |  751 +++++++++++++++------
 drivers/infiniband/hw/ehca/ehca_reqs.c            |   85 ++-
 drivers/infiniband/hw/ehca/ehca_tools.h           |    1 +
 drivers/infiniband/hw/ehca/ehca_uverbs.c          |   13 +-
 drivers/infiniband/hw/ehca/hcp_if.c               |   58 +-
 drivers/infiniband/hw/ehca/hcp_if.h               |    1 -
 drivers/infiniband/hw/ehca/hipz_hw.h              |   19 +
 drivers/infiniband/hw/ehca/ipz_pt_fn.h            |   28 +-
 drivers/infiniband/hw/ipath/Kconfig               |    2 +-
 drivers/infiniband/hw/ipath/ipath_common.h        |   33 +-
 drivers/infiniband/hw/ipath/ipath_cq.c            |    7 +-
 drivers/infiniband/hw/ipath/ipath_debug.h         |    2 +-
 drivers/infiniband/hw/ipath/ipath_diag.c          |   41 +-
 drivers/infiniband/hw/ipath/ipath_driver.c        |  187 +++++-
 drivers/infiniband/hw/ipath/ipath_eeprom.c        |  303 ++++++++-
 drivers/infiniband/hw/ipath/ipath_file_ops.c      |  205 ++++--
 drivers/infiniband/hw/ipath/ipath_fs.c            |    9 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c       |  101 ++--
 drivers/infiniband/hw/ipath/ipath_iba6120.c       |   92 ++-
 drivers/infiniband/hw/ipath/ipath_init_chip.c     |   26 +-
 drivers/infiniband/hw/ipath/ipath_intr.c          |  141 ++++-
 drivers/infiniband/hw/ipath/ipath_kernel.h        |   85 +++-
 drivers/infiniband/hw/ipath/ipath_keys.c          |    2 +-
 drivers/infiniband/hw/ipath/ipath_layer.c         |    2 +-
 drivers/infiniband/hw/ipath/ipath_layer.h         |    2 +-
 drivers/infiniband/hw/ipath/ipath_mad.c           |   11 +-
 drivers/infiniband/hw/ipath/ipath_mmap.c          |    2 +-
 drivers/infiniband/hw/ipath/ipath_mr.c            |    2 +-
 drivers/infiniband/hw/ipath/ipath_qp.c            |   19 +-
 drivers/infiniband/hw/ipath/ipath_rc.c            |  116 +++-
 drivers/infiniband/hw/ipath/ipath_registers.h     |    2 +-
 drivers/infiniband/hw/ipath/ipath_ruc.c           |   36 +-
 drivers/infiniband/hw/ipath/ipath_srq.c           |    4 +-
 drivers/infiniband/hw/ipath/ipath_stats.c         |   25 +-
 drivers/infiniband/hw/ipath/ipath_sysfs.c         |   43 ++-
 drivers/infiniband/hw/ipath/ipath_uc.c            |    9 +-
 drivers/infiniband/hw/ipath/ipath_ud.c            |    6 +-
 drivers/infiniband/hw/ipath/ipath_user_pages.c    |    2 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c         |   29 +-
 drivers/infiniband/hw/ipath/ipath_verbs.h         |    3 +-
 drivers/infiniband/hw/ipath/ipath_verbs_mcast.c   |    2 +-
 drivers/infiniband/hw/ipath/ipath_wc_ppc64.c      |    2 +-
 drivers/infiniband/hw/ipath/ipath_wc_x86_64.c     |   29 +-
 drivers/infiniband/hw/mlx4/Kconfig                |    1 -
 drivers/infiniband/hw/mlx4/main.c                 |    6 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h              |    4 +
 drivers/infiniband/hw/mlx4/qp.c                   |  137 ++++
 drivers/infiniband/hw/mlx4/srq.c                  |   18 +
 drivers/infiniband/hw/mthca/Kconfig               |    2 +-
 drivers/infiniband/hw/mthca/mthca_allocator.c     |    2 +-
 drivers/infiniband/hw/mthca/mthca_eq.c            |    2 +-
 drivers/infiniband/ulp/ipoib/Kconfig              |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c           |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c           |   33 +-
 drivers/infiniband/ulp/iser/Kconfig               |    2 +-
 drivers/infiniband/ulp/srp/Kconfig                |    2 +-
 drivers/net/cxgb3/version.h                       |    2 +-
 drivers/net/mlx4/fw.c                             |    3 +
 drivers/net/mlx4/fw.h                             |    1 +
 drivers/net/mlx4/main.c                           |    1 +
 drivers/net/mlx4/mlx4.h                           |    1 +
 drivers/net/mlx4/qp.c                             |   21 +
 drivers/net/mlx4/srq.c                            |   30 +
 include/linux/mlx4/device.h                       |    2 +
 include/linux/mlx4/qp.h                           |    3 +
 include/rdma/ib_cm.h                              |    1 -
 include/rdma/ib_mad.h                             |    3 +
 100 files changed, 2812 insertions(+), 1061 deletions(-)
