Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0AOBti (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666Ab0AOBte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:49:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:36228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab0AOBtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:49:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,279,1262592000"; 
   d="scan'208";a="587305631"
Message-Id: <20100115013954.311049665@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Jan 2010 09:39:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
CC: Eric Paris <eparis@redhat.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: David Howells <dhowells@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>
cc: <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/6] FMODE_NONOTIFY, FMODE_RANDOM and FMODE_NEG_OFFSET bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This collects my recent patches related to FMODE_* and O_*
discussed in LKML. They are mainly bug fixes.

O_* and FMODE_NONOTIFY collision fix/check
	[PATCH 1/6] fanotify: fix FMODE_NONOTIFY bit number
	[PATCH 2/6] bitops: compile time optimization for hweight_long(CONSTANT)
	[PATCH 3/6] vfs: O_* bit numbers uniqueness check

POSIX_FADV_RANDOM misbehavior fix
	[PATCH 4/6] vfs: take f_lock on modifying f_mode after open time
	[PATCH 5/6] readahead: introduce FMODE_RANDOM for POSIX_FADV_RANDOM

allow negative f_pos for /dev/kmem
	[PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing negative f_pos

Thanks,
Fengguang

