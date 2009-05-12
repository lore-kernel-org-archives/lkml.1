Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZELNKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZELNKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZELNKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:10:10 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:41115 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbZELNKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:10:09 -0400
Message-ID: <4A0974FA.9090501@linux.vnet.ibm.com>
Date: Tue, 12 May 2009 15:09:14 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <20090507124556.041286732@linux.vnet.ibm.com>  <20090507124558.618214093@linux.vnet.ibm.com>  <20090507134610.GN28398@elte.hu> <4A04133B.8080501@linux.vnet.ibm.com> <20090511131708.GB32693@elte.hu>
In-Reply-To: <20090511131708.GB32693@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> 
>>>> +/* __gcov_init is called by gcc-generated constructor code for each object
>>>> + * file compiled with -fprofile-arcs. */
[...]
> It isnt about the amount of comments, it is about the plain (and 
> simple to rectify) fact that the above two-lines comment is 
> inconsistent with other kernel code.

Ok, I misunderstood when I replied. The updated patch set should contain 
the correct changes though.

>>>>                   $(asflags-y) $(AFLAGS_$(basetarget).o)
>>>>  _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
>>>>  +# Enable gcov profiling flags for a file, directory or for all 
>>>> files depending
>>>> +# on variables GCOV_PROFILE_obj.o, GCOV_PROFILE and CONFIG_GCOV_PROFILE_ALL
>>>> +# (in this order)
>>>> +ifeq ($(CONFIG_GCOV_KERNEL),y)
>>> Please try to use winged comments in makefiles too.
>> What do you mean by winged comments?
> 
> This:
> 
>   /*
>    * Comment .....
>    * ...... goes here:
>    */
> 
> Is called a winged comment. Its makefile equivalent is:

Ok. Though google disagrees on that definition (see 
http://www.catb.org/~esr/jargon/html/W/winged-comments.html).

