Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZELNgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZELNgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZELNg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:36:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56803 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbZELNgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:36:25 -0400
Date: Tue, 12 May 2009 15:35:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-ID: <20090512133550.GA11746@elte.hu>
References: <20090507124556.041286732@linux.vnet.ibm.com> <20090507124558.618214093@linux.vnet.ibm.com> <20090507134610.GN28398@elte.hu> <4A04133B.8080501@linux.vnet.ibm.com> <20090511131708.GB32693@elte.hu> <4A0974FA.9090501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0974FA.9090501@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> Ingo Molnar wrote:
>> * Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>>
>>>>> +/* __gcov_init is called by gcc-generated constructor code for each object
>>>>> + * file compiled with -fprofile-arcs. */
> [...]
>> It isnt about the amount of comments, it is about the plain (and  
>> simple to rectify) fact that the above two-lines comment is  
>> inconsistent with other kernel code.
>
> Ok, I misunderstood when I replied. The updated patch set should contain  
> the correct changes though.
>
>>>>>                   $(asflags-y) $(AFLAGS_$(basetarget).o)
>>>>>  _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
>>>>>  +# Enable gcov profiling flags for a file, directory or for all  
>>>>> files depending
>>>>> +# on variables GCOV_PROFILE_obj.o, GCOV_PROFILE and CONFIG_GCOV_PROFILE_ALL
>>>>> +# (in this order)
>>>>> +ifeq ($(CONFIG_GCOV_KERNEL),y)
>>>> Please try to use winged comments in makefiles too.
>>> What do you mean by winged comments?
>>
>> This:
>>
>>   /*
>>    * Comment .....
>>    * ...... goes here:
>>    */
>>
>> Is called a winged comment. Its makefile equivalent is:
>
> Ok. Though google disagrees on that definition (see  
> http://www.catb.org/~esr/jargon/html/W/winged-comments.html).

yeah, i guess you are right, the correct term would be something 
like 'multi-line winged comments'.

	Ingo
