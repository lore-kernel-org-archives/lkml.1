Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0CGKMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 05:12:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab0CGKMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 05:12:22 -0500
Message-ID: <4B937BE1.1060703@redhat.com>
Date: Sun, 07 Mar 2010 12:11:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>, ming.m.lin@intel.com,
       sheng.yang@intel.com, Jes Sorensen <Jes.Sorensen@redhat.com>,
       KVM General <kvm@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: KVM usability
References: <4B87A6BF.3090301@redhat.com> <20100227105643.GA17425@elte.hu>	 <4B893B2B.40301@redhat.com> <20100227172546.GA31472@elte.hu>	 <4B8BEFC7.2040000@redhat.com>	 <20100301174106.GB2362@ghostprotocols.net>	 <4B8C0778.8050908@redhat.com> <20100301205620.GA26151@elte.hu>	 <20100302103045.GA28310@elte.hu> <4B937363.4070406@redhat.com> <84144f021003070156p2e0e86fche27c2b8d7d3e760@mail.gmail.com>
In-Reply-To: <84144f021003070156p2e0e86fche27c2b8d7d3e760@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 11:56 AM, Pekka Enberg wrote:
> Hi Avi,
>
> (slightly off-topic)
>
> On Sun, Mar 7, 2010 at 11:35 AM, Avi Kivity<avi@redhat.com>  wrote:
>    
>> perf really is wonderful, but to be really competitive, and usable to more
>> developers, it needs to be in a graphical environment.  I want 'perf report'
>> output to start out collapsed and drill down by clicking on a tree widget.
>>   Clicking on a function name opens its definition.  'perf annotate' should
>> display annotations on my editor window, not in a pager.  I should be able
>> to check events on a list, not using 'perf list'.
>>      
> People keep bringing this up but I don't quite agree. Mac OS X has
> "shark" which is pretty much what you describe above. However, having
> used both, I prefer perf's simple UI for two reasons: it's much easier
> to automate perf commands and text-based reports are superior for
> sharing results (and keeping track of results when doing performance
> optimizations).
>    

Yes, you (and me as well).  But most people are quite unlike new and 
me.  There's a reason GUIs dominate today, and there are even a few 
kernel developers that don't use mutt for reading email.

Even for command-line-happy people, GUIs still have an advantage in that 
it is much easier to discover features by exploring the UI vs. reading 
manual pages.

> That said, AFAICT, it should be pretty simple to implement a
> shark-like UI with GTK as current perf code is pretty good fit for
> that. I've pondered about doing that myself but quite frankly, I don't
> see any big gains in that.
>    

Because you are only interested in your own itches (which is perfectly 
legitimate, but will keep perf's userbase down).

-- 
error compiling committee.c: too many arguments to function

