Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab0CGSQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 13:16:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab0CGSQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 13:16:55 -0500
Message-ID: <4B93ED7A.6070204@redhat.com>
Date: Sun, 07 Mar 2010 20:16:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca.barbieri@gmail.com>
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
References: <4B87A6BF.3090301@redhat.com> <20100227105643.GA17425@elte.hu>	 <4B893B2B.40301@redhat.com> <20100227172546.GA31472@elte.hu>	 <4B8BEFC7.2040000@redhat.com>	 <20100301174106.GB2362@ghostprotocols.net>	 <4B8C0778.8050908@redhat.com> <20100301205620.GA26151@elte.hu>	 <20100302103045.GA28310@elte.hu> <4B937363.4070406@redhat.com> <ff13bc9a1003070714q3963a302ne37a57537423da57@mail.gmail.com>
In-Reply-To: <ff13bc9a1003070714q3963a302ne37a57537423da57@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 05:14 PM, Luca Barbieri wrote:
>> perf really is wonderful, but to be really competitive, and usable to more
>> developers, it needs to be in a graphical environment.  I want 'perf report'
>> output to start out collapsed and drill down by clicking on a tree widget.
>>   Clicking on a function name opens its definition.  'perf annotate' should
>> display annotations on my editor window, not in a pager.  I should be able
>> to check events on a list, not using 'perf list'.
>>
>> Is something like that suitable for tools/perf/?  I think you'll find the
>> intersection of kernel developers and GUI developers to be fairly small.
>>      
> The latest versions of Gnome Sysprof use perf and provide a GTK+ tree
> interface for the profiling output.
>
> However, they are not configurable at all and don't support anything
> but call graph profiling, unless they added more features very
> recently.
> It would be nice to extend sysprof into a more capable tool, and one
> that can read perf output files and do so when launched from the
> command line.
>    

Looks like a step in the right direction.  I don't think this belong in 
tools/, though.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

