Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbYDOXgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbYDOXgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbYDOXfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:35:53 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48643 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753511AbYDOXfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:35:52 -0400
Message-Id: <20080415233551.964024000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Apr 2008 16:35:51 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] x86: cleanup early per cpu variables/accesses v2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  * Introduce a new PER_CPU macro called "EARLY_PER_CPU".  This is
    used by some per_cpu variables that are initialized and accessed
    before there are per_cpu areas allocated.

  * Small change in kernel/sched.c to remove another 512 bytes from the stack.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git


Signed-off-by: Mike Travis <travis@sgi.com>
---
v2: remerged PATCH 2/2 with latest x86.git/latest and sched-devel/latest,
    rebuilt and retested 4k-akpm2, 4k-defconfig, nonuma, & nosmp configs.

-- 
