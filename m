Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZJMCg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZJMCg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 22:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbZJMCg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 22:36:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54005 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876AbZJMCgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 22:36:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AD3E731.7080900@jp.fujitsu.com>
Date: Tue, 13 Oct 2009 11:34:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked handler
 call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com>	 <1255072482.5228.157.camel@yhuang-dev.sh.intel.com>	 <4ACEE5E0.3050701@jp.fujitsu.com>	 <1255074286.5228.163.camel@yhuang-dev.sh.intel.com>	 <4ACEF4D9.9090600@jp.fujitsu.com> <1255079484.5228.201.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1255079484.5228.201.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Fri, 2009-10-09 at 16:31 +0800, Hidetoshi Seto wrote: 
>> In short, I believe that my idea is "use two flags" and your idea is
>> "share one flag" ... right?
> 
> No. There are many flags in .inject_flags (MCJ_EXCEPTION, MCJ_LOADED,
> etc), .finished is just another flag.

Maybe I should have said "to indicate 'loaded' and 'ready for consume'",
"use two variables" and "share one variable."

> It is OK to discuss the name and places of the two flags, but you should
> not send out a similar patch and declare it is your idea. 

I have experienced that some person received an alternative patch from
another person saying that "hey, how about this patch to do same thing in
an other way?" and that the original author replied "oh, it looks much
better, use it instead of mine" with his Acked-by:.

Now I have learned you are not one of such open-minded people, so I will
never try to make such patch for you again.  Please throw all of my patches
posted last week in the trash.

>> The only thing what I want to do here is merge your "fix" into upstream.
> 
> You should provide comment, instead of sending out a similar patch and
> declaring it is your idea.

I hope you could flexibly reflect comments from others, without saying like
"I don't think this is necessary because it works fine."

How long do I have to wait your next post, which will fix my urgent issue on
Nehalem?


Thanks,
H.Seto

