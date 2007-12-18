Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXLRV6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXLRV6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbXLRV5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:57:45 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:53731 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbXLRV5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:57:44 -0500
Date: Tue, 18 Dec 2007 21:55:59 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Rohland <hans-christoph.rohland@sap.com>,
       Erez Zadok <ezk@cs.sunysb.edu>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] tmpfs: towards unionfs and memcgroups
Message-ID: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neither unionfs nor memcgroups are working correctly with tmpfs and shmem.
If either or both are to go forward to 2.6.25, we shall need these patches
(against 2.6.24-rc5-mm1, but not dependent on unionfs or memcgroups) to go
in ahead.  A small set for unionfs and a smaller set for memcgroups follow.

 include/linux/swap.h |   15 --
 mm/shmem.c           |  213 ++++++++++++++++++++++++++++-------------
 mm/swap_state.c      |  100 ++++---------------
 mm/swapfile.c        |   23 +---
 4 files changed, 184 insertions(+), 167 deletions(-)

In your -mm series file, please shift 
shmem-factor-out-sbi-free_inodes-manipulations.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
down after my
swapoff-scan-ptes-preemptibly.patch
and then append the nine tmpfs patchs which follow.

Thanks!
Hugh
