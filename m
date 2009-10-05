Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbZJEHvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbZJEHvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 03:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758525AbZJEHvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 03:51:09 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59912 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZJEHvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 03:51:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC9A534.6080704@jp.fujitsu.com>
Date: Mon, 05 Oct 2009 16:50:12 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] x86, mce: make mce_log buffer to per-CPU
References: <1253269241.15717.525.camel@yhuang-dev.sh.intel.com> <4AC990E1.7030708@jp.fujitsu.com> <4AC99483.7020100@jp.fujitsu.com> <4AC99AEC.3000504@linux.intel.com>
In-Reply-To: <4AC99AEC.3000504@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> (This piece originates from Huang's patch, titled:
>>  "x86, MCE: Fix bugs and issues of MCE log ring buffer")
> 
> You should use proper From: headers then for correct attribution.
> 
> -Andi

I just referred following commit we already have: 

> commit 77e26cca20013e9352a8df86a54640543304a23a
> Author: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Date:   Thu Jun 11 16:04:35 2009 +0900
> 
>     x86, mce: Fix mce printing
> 
>     This patch:
> 
>      - Adds print_mce_head() instead of first flag
>      - Makes the header to be printed always
>      - Stops double printing of corrected errors
> 
>     [ This portion originates from Huang Ying's patch ]
> 
>     Originally-From: Huang Ying <ying.huang@intel.com>
>     Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>     LKML-Reference: <4A30AC83.5010708@jp.fujitsu.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

You mean s/Originally-From/From/, right?

I'll update attributes if this set need to be revised or if maintainer
(who expected to be able to set proper attributes) request me to do so.

Thanks,
H.Seto

