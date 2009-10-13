Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbZJMD2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbZJMD2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbZJMD2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:28:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:34754 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbZJMD2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:28:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,549,1249282800"; 
   d="scan'208";a="558990183"
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked
 handler call
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AD3E731.7080900@jp.fujitsu.com>
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>
	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com>
	 <1255072482.5228.157.camel@yhuang-dev.sh.intel.com>
	 <4ACEE5E0.3050701@jp.fujitsu.com>
	 <1255074286.5228.163.camel@yhuang-dev.sh.intel.com>
	 <4ACEF4D9.9090600@jp.fujitsu.com>
	 <1255079484.5228.201.camel@yhuang-dev.sh.intel.com>
	 <4AD3E731.7080900@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 11:28:15 +0800
Message-Id: <1255404495.6047.298.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 10:34 +0800, Hidetoshi Seto wrote: 
> Huang Ying wrote:
> > On Fri, 2009-10-09 at 16:31 +0800, Hidetoshi Seto wrote: 
> >> In short, I believe that my idea is "use two flags" and your idea is
> >> "share one flag" ... right?
> > 
> > No. There are many flags in .inject_flags (MCJ_EXCEPTION, MCJ_LOADED,
> > etc), .finished is just another flag.
> 
> Maybe I should have said "to indicate 'loaded' and 'ready for consume'",
> "use two variables" and "share one variable."

.inject_flags and .finished are two variables. I think you try to avoid
using .inject_flags. But I think it is OK to use .inject_flags.

> > It is OK to discuss the name and places of the two flags, but you should
> > not send out a similar patch and declare it is your idea. 
> 
> I have experienced that some person received an alternative patch from
> another person saying that "hey, how about this patch to do same thing in
> an other way?" and that the original author replied "oh, it looks much
> better, use it instead of mine" with his Acked-by:.

I don't do that because I don't think your patch is in another way and
much better.

> Now I have learned you are not one of such open-minded people, so I will
> never try to make such patch for you again.  Please throw all of my patches
> posted last week in the trash.
> 
> >> The only thing what I want to do here is merge your "fix" into upstream.
> > 
> > You should provide comment, instead of sending out a similar patch and
> > declaring it is your idea.
> 
> I hope you could flexibly reflect comments from others, without saying like
> "I don't think this is necessary because it works fine."

When I say: "I don't think it is necessary". I do think so really.

> How long do I have to wait your next post, which will fix my urgent issue on
> Nehalem?

I think my patch with title:

[BUGFIX -v2] x86, mce, inject: Make injected mce valid only during faked handler call

fixes this issue correctly.

Hi, Ingo and Peter,

what are your idea about the patch above? Maybe you don't like the
naming style of MCJ_XXX. But I think if they need to be changed, it
should be in another patch. And H.Seto has posted the patch for it.

Best Regards,
Huang Ying


