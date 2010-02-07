Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0BGDnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 22:43:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:16528 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab0BGDnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 22:43:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,420,1262592000"; 
   d="scan'208";a="538491607"
Message-Id: <20100207032805.769788305@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 07 Feb 2010 11:28:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>
CC: Roland Dreier <rdreier@cisco.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>
CC: Jamie Lokier <jamie@shareable.org>
CC: Eric Paris <eparis@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] [RESEND 2] FMODE_NONOTIFY and FMODE_NEG_OFFSET bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Changelog

	- PATCH 1/4 is retained: I'm not sure if it has been merged into Eric's tree
	- PATCH 2/4 is changed to use Peter's HWEIGHT32()

Patches

	O_* and FMODE_NONOTIFY collision fix/check
		[PATCH 1/4] fanotify: fix FMODE_NONOTIFY bit number
		[PATCH 2/4] vfs: O_* bit numbers uniqueness check

	allow negative f_pos for /dev/kmem
		[PATCH 3/4] vfs: introduce FMODE_NEG_OFFSET for allowing negative f_pos
		[PATCH 4/4] devmem: dont allow seek to last page

Thanks,
Fengguang

