Return-Path: <linux-kernel-owner+w=401wt.eu-S1764657AbYB0A1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764657AbYB0A1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbYB0A1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:27:47 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:37095 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbYB0A1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:27:46 -0500
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 26 Feb 2008 16:27:45 -0800
Message-ID: <adave4bw8e6.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Feb 2008 00:27:45.0483 (UTC) FILETIME=[92B709B0:01C878D7]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a couple of small post-2.6.25-rc3 fixes, mostly to the
new nes driver:

Adrian Bunk (3):
      RDMA/nes: Fix off-by-one
      RDMA/nes: Fix a memory leak in schedule_nes_timer()
      RDMA/nes: Fix a check-after-use in nes_probe()

Bryan Rosenburg (1):
      RDMA/cxgb3: Fix shift calc in build_phys_page_list() for 1-entry page lists

Chien Tung (1):
      RDMA/nes: Resurrect error path dead code

Faisal Latif (2):
      RDMA/nes: Fix use-after-free in mini_cm_dec_refcnt_listen()
      RDMA/nes: Fix CRC endianness for RDMA connection establishment on big-endian

Glenn Streiff (1):
      RDMA/nes: Fix use-after-free in nes_create_cq()

John Lacombe (1):
      RDMA/nes: Fix interrupt moderation low threshold

Roland Dreier (1):
      MAINTAINERS: neteffect update

 MAINTAINERS                            |    2 ++
 drivers/infiniband/hw/cxgb3/iwch_mem.c |   10 ++--------
 drivers/infiniband/hw/nes/nes.c        |    2 +-
 drivers/infiniband/hw/nes/nes.h        |   15 +++++++++++++++
 drivers/infiniband/hw/nes/nes_cm.c     |   15 +++++++++------
 drivers/infiniband/hw/nes/nes_hw.c     |   13 +++++--------
 drivers/infiniband/hw/nes/nes_hw.h     |    2 +-
 drivers/infiniband/hw/nes/nes_verbs.c  |   10 ++++------
 8 files changed, 39 insertions(+), 30 deletions(-)
