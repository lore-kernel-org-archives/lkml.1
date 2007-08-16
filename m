Return-Path: <linux-kernel-owner+w=401wt.eu-S1762534AbXHPWJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762534AbXHPWJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758375AbXHPWIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:08:54 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44018 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753174AbXHPWIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:08:53 -0400
Message-ID: <387302129.14235@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070816220516.782145952@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 17 Aug 2007 06:05:16 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: John Berthels <jjberthels@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] process memory footprints in proc/<pid>/[s|p]maps
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Inspired by Matt Mackall's pagemap patches and ideas, these textual interfaces
are worked up to achieve the same goals. The patchset runs OK on various read
sizes.

1) Add PSS to the existing /proc/<pid>/smaps:
        [PATCH 1/4] maps: PSS(proportional set size) accounting in smaps

2) Create /proc/<pid>/pmaps for page granularity mmap footprints:
        [PATCH 2/4] maps: address based vma walking
        [PATCH 3/4] maps: introduce generic_maps_open()
        [PATCH 4/4] maps: /proc/<pid>/pmaps interface - memory maps in granularity of pages


 fs/proc/base.c          |    7 
 fs/proc/internal.h      |    1 
 fs/proc/task_mmu.c      |  354 ++++++++++++++++++++++++++++----------
 fs/seq_file.c           |    1 
 include/linux/proc_fs.h |    6 
 mm/mempolicy.c          |    2 
 6 files changed, 281 insertions(+), 90 deletions(-)

Thank you,
Fengguang
