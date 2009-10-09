Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbZJIHS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbZJIHS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZJIHS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:18:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50064 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbZJIHS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:18:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACEE3AB.5040308@jp.fujitsu.com>
Date: Fri, 09 Oct 2009 16:18:03 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mce-inject: use individual members instead of struct
 mce
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com>	 <1255053299.5228.28.camel@yhuang-dev.sh.intel.com>	 <4ACECC49.7000602@jp.fujitsu.com>  <4ACECDDD.1040206@jp.fujitsu.com> <1255071040.5228.147.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1255071040.5228.147.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Fri, 2009-10-09 at 13:45 +0800, Hidetoshi Seto wrote: 
>> struct mce have many members and almost half of them are not used
>> for mce injection.  So make struct mce_fake_banks to have required
>> members instead of having struct mce in it.
> 
> I don't think this is necessary. struct mce works fine.

Why do you think so?
I think having unused space in precious per-CPU is not good idea.

And this change is required to reduces the size of allocation unit
in later patch to support multiple error injection.


Thanks,
H.Seto

