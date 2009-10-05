Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbZJECxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbZJECxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 22:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196AbZJECxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 22:53:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48127 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZJECxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 22:53:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC95F5A.4000708@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 11:52:10 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] x86, mce, mce-inject: misc fix v2
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is v2 patch set for small improvements, inspired by Huang's patch.

* Short summaries v1 -> v2:
  dropped:
      x86, mce: rename finished to valid in struct mce
  added:
      x86, mce: replace MCM_ to MCI_MISC_
      mce-inject: add a barrier to raise_mce()
  modified:
      mce-inject: use injected mce only during faked handler call

Based on 2.6.32-rc3.

Thanks,
H.Seto

Hidetoshi Seto (6):
      x86, mce: replace MCJ_ to MCE_INJ_
      x86, mce: replace MCM_ to MCI_MISC_
      mce-inject: no wait on write with MCE_INJ_CTX_RANDOM
      mce-inject: allow injecting status=0 to poll handler
      mce-inject: add a barrier to raise_mce()
      mce-inject: use injected mce only during faked handler call

 arch/x86/include/asm/mce.h              |   46 +++++++++++++------
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   72 +++++++++++++++++++------------
 arch/x86/kernel/cpu/mcheck/mce.c        |   20 +++++----
 3 files changed, 86 insertions(+), 52 deletions(-)


