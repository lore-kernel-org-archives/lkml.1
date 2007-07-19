Return-Path: <linux-kernel-owner+w=401wt.eu-S936233AbXGSNsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936233AbXGSNsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbXGSNsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:30 -0400
Received: from ns.suse.de ([195.135.220.2]:54499 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbXGSNs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:29 -0400
From: Andi Kleen <ak@suse.de>
Message-Id: <20070719348.540885000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH for review] [0/48] Second batch of x86 patches for .23
Date: Thu, 19 Jul 2007 15:48:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[repost to linux-kernel because I messed up the email address first time]

- Controversal change: extend the unhandled signals logging to i386
* all flames to  Masoud Asgharifard Sharbiani <masouds@google.com> please
- NUMA fallback handling for AMD Fam10h/11h (Joachim Deguara)
- Second try at registering HPET in resources
- Various AMD Geode fixes
- Better OOM handling -- kill all threads
- Better HPET sanity checking
- Fix PCI mmconfig on some systems
- kprobes/alternative handling now works with DEBUG_RODATA again
- Allow KVM on non PAE kernels again
- Mostly various small leanups and fixes

Please review. I plan to send them off relatively quickly
because I'm very late with this merge.

-Andi
