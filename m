Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbYCYXCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbYCYXCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbYCYXCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:02:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40947 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954AbYCYXCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:02:15 -0400
Message-ID: <47E9843A.1060702@zytor.com>
Date: Tue, 25 Mar 2008 16:01:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com
Subject: Re: [PATCH] x86: pat cpu feature bit setting for known cpus
References: <200803242324.35357.yhlu.kernel@gmail.com> <47E9003B.5010002@zytor.com> <86802c440803251103taf4c8f2mb674c3d17f3c2345@mail.gmail.com> <20080325190851.GC30998@linux-os.sc.intel.com> <20080325200830.GB15330@elte.hu> <47E962AE.9040307@zytor.com>
In-Reply-To: <47E962AE.9040307@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Ingo Molnar wrote:
>> * Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>>
>>>>>  OK, note previous question: what is the motivation for having 
>>>>>  this as a whitelist (as opposed to a blacklist)?
>>>> Venkatesh could tell?
>>> Main reason for white-list at this point is not to be side-tracked by 
>>> real or potential erratas on older CPUs. Focussing on getting the 
>>> support for this feature on current and future CPUs. If older CPUs 
>>> have survived all these days without this feature, they should be 
>>> doing OK.
>>
>> well, the upside would be that since most testing of Linux kernels is 
>> done on _old_ hardware (people tend to risk their old hw first ;-), 
>> we'd get faster convergence of the codebase, even though we have the 
>> risk of erratas (known and unknown ones alike). Code that artificially 
>> limits its utility is almost always slow to stabilize.
>>
> 
> Yes, using a whitelist of this type is wrong, IMO, and smells faintly of 
> vendor-lockin.
> 

By the way, I want to clarify: I didn't mean it was *intended* as 
vendor-lockin, just that it's an undesirable effect of this.

	-hpa
