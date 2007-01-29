Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbXA2Kbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbXA2Kbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 05:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXA2Kbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 05:31:42 -0500
Received: from ns1.suse.de ([195.135.220.2]:49378 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbXA2Kbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 05:31:41 -0500
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>
Message-Id: <20070129081905.23584.97878.sendpatchset@linux.site>
Subject: [patch 0/9] buffered write deadlock fix
Date: Mon, 29 Jan 2007 11:31:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches attempt to fix the buffered write
locking problems (and there are a couple of peripheral patches
and cleanups there too).

Patches against 2.6.20-rc6. I was hoping that 2.6.20-rc6-mm2 would
be an easier diff with the fsaio patches gone, but the readahead
rewrite clashes badly :(

Please apply?

Thanks,
Nick

--
SuSE Labs

