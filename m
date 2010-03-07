Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0CGTGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 14:06:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab0CGTGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 14:06:32 -0500
Message-ID: <4B93F903.4030602@redhat.com>
Date: Sun, 07 Mar 2010 21:05:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Zachary Amsden <zamsden@redhat.com>,
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
References: <4B893B2B.40301@redhat.com> <20100227172546.GA31472@elte.hu> <4B8BEFC7.2040000@redhat.com> <20100301174106.GB2362@ghostprotocols.net> <4B8C0778.8050908@redhat.com> <20100301205620.GA26151@elte.hu> <20100302103045.GA28310@elte.hu> <4B937363.4070406@redhat.com> <20100307180142.GE20213@ghostprotocols.net> <4B93ED4C.10703@redhat.com> <20100307185358.GF16539@ghostprotocols.net>
In-Reply-To: <20100307185358.GF16539@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 08:53 PM, Arnaldo Carvalho de Melo wrote:
>>> Do you really think that more kernel developers would use perf more
>>> frequently if it had some GUI?
>>>        
>> Not much.  Is perf's target kernel developers exclusively?  Who are
>> we writing this kernel for?
>>      
> No, we aren't writing this tool only for kernel developers exclusively,
> but that wasn't my question, it was badly formulated, sorry, I shouldn't
> have included "kernel" in it :-\
>    

In this case, I will reformulate my answer.  Very much.

>> Even for kernel developers there are advantages in a GUI, namely
>> that features are easily discovered, the amount of information is
>> easily controlled, and in that you can interact (not redo everything
>> from scratch every time you want to change something).  The
>> difference between a curses based tool and a true GUI are minimal
>> for this audience.
>>      
> Ok, I agree with you about easier discoverability of features, path
> shortened from report to annotate to starting the editor right at the
> line where some event of interest happened,

Another path is browse some function, start profiling, see perf data 
fill up in the margin.  Or, jump to callers.  etc.  You need an 
integrated browser for that (or an emacs perf mode).

> will try to keep the
> routines not much coupled with ncurses, but definetely ncurses will be
> the first step.
>    

Great.  ncurses is certainly much easier to experiment with and will 
likely provide useful experience.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

