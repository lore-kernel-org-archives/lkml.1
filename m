Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388Ab0A3Jxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0A3Jxb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 04:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225Ab0A3Jx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 04:53:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:46174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab0A3JxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 04:53:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,373,1262592000"; 
   d="scan'208";a="768609408"
Message-Id: <20100130094515.475881280@intel.com>
User-Agent: quilt/0.48-1
Date: Sat, 30 Jan 2010 17:45:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/5] [RESEND] FMODE_NONOTIFY and FMODE_NEG_OFFSET bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Resend the patches related to FMODE_* and O_*, rebased to the -mm tree.

O_* and FMODE_NONOTIFY collision fix/check
	[PATCH 1/5] fanotify: fix FMODE_NONOTIFY bit number
	[PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
	[PATCH 3/5] vfs: O_* bit numbers uniqueness check

allow negative f_pos for /dev/kmem
	[PATCH 4/5] vfs: introduce FMODE_NEG_OFFSET for allowing negative f_pos
	[PATCH 5/5] devmem: dont allow seek to last page

Thanks,
Fengguang

