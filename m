Return-Path: <linux-kernel-owner+w=401wt.eu-S1763887AbXJOW0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763887AbXJOW0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbXJOW0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:26:08 -0400
Received: from waste.org ([66.93.16.53]:1289 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755530AbXJOW0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:26:06 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Message-Id: <1.290135367@selenic.com>
Subject: [PATCH 0/11] maps3: pagemap monitoring v3
Date: Mon, 15 Oct 2007 17:25:57 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is version 3 of my /proc/pid/pagemaps code.

Rather than submit about 30 incremental patches atop an existing 20 or
so where many of the intermediate states are broken and get undone
anyway, I've respun this as a much smaller set of 11 patches.

Changes in this series:

- headers gone again (as recommended by Dave Hansen and Alan Cox)
- 64-bit entries (as per discussion with Andi Kleen)
- swap pte information exported (from Dave Hansen)
- page walker callback for holes (from Dave Hansen)
- direct put_user I/O (as suggested by Rusty Russell)
- split kpagemap into kpagecount and kpageflags

I've dropped one cleanup patch from Rusty from the current series,
mmaps2-vma-out-of-mem_size_stats.patch, which I didn't find to be an
improvement.

Andrew, please replace the current maps2* patches with this set at
your convenience. I've included the above change list in the relevant
patches.
