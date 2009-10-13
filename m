Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbZJMGBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbZJMGBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZJMGBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:01:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42539 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbZJMGBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:01:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AD41793.9020400@jp.fujitsu.com>
Date: Tue, 13 Oct 2009 15:00:51 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked handler
 call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com>	 <1255072482.5228.157.camel@yhuang-dev.sh.intel.com>	 <4ACEE5E0.3050701@jp.fujitsu.com>	 <1255074286.5228.163.camel@yhuang-dev.sh.intel.com>	 <4ACEF4D9.9090600@jp.fujitsu.com>	 <1255079484.5228.201.camel@yhuang-dev.sh.intel.com>	 <4AD3E731.7080900@jp.fujitsu.com> <1255404495.6047.298.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1255404495.6047.298.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Tue, 2009-10-13 at 10:34 +0800, Hidetoshi Seto wrote: 
>> How long do I have to wait your next post, which will fix my urgent issue on
>> Nehalem?
> 
> I think my patch with title:
> 
> [BUGFIX -v2] x86, mce, inject: Make injected mce valid only during faked handler call
> 
> fixes this issue correctly.

I should note that there are 2 pending patches from you:

[BUGFIX -v2] x86, mce, inject: Make injected mce valid only during faked handler call
  for issue A) injected mce could be consumed by real poll handler  

[BUGFIX -v7] x86, MCE: Fix bugs and issues of MCE log ring buffer
  for issue B) log buffer is too small
  and for issue C) log buffer is not ring buffer
  (I'm not sure but there might be other targeting issues D), E) and so on.)

And the only one what I believe it is urgent is issue B).


Thanks,
H.Seto

