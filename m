Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbZI1Gq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbZI1Gq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 02:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZI1Gq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 02:46:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41557 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbZI1Gqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 02:46:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC05BBF.3010102@jp.fujitsu.com>
Date: Mon, 28 Sep 2009 15:46:23 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] x86, mce-inject: misc fix
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch set inspired by Huang's patch.
Based on 2.6.32-rc1.

Thanks,
H.Seto

Hidetoshi Seto (5):
      mce-inject: replace MCJ_ to MCE_INJ_
      x86, mce: rename finished to valid in struct mce
      mce-inject: make injected mce valid only during faked handler call
      mce-inject: no wait on write with MCE_INJ_CTX_RANDOM
      mce-inject: allow injecting status=0 to poll handler

 arch/x86/include/asm/mce.h              |   21 +++++----
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   69 ++++++++++++++++++-------------
 arch/x86/kernel/cpu/mcheck/mce.c        |   16 ++++----
 3 files changed, 59 insertions(+), 47 deletions(-)

