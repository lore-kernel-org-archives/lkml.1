Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab0CGSQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 13:16:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab0CGSQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 13:16:34 -0500
Message-ID: <4B93ED4C.10703@redhat.com>
Date: Sun, 07 Mar 2010 20:15:40 +0200
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
References: <4B8813F2.8090208@redhat.com> <20100227105643.GA17425@elte.hu> <4B893B2B.40301@redhat.com> <20100227172546.GA31472@elte.hu> <4B8BEFC7.2040000@redhat.com> <20100301174106.GB2362@ghostprotocols.net> <4B8C0778.8050908@redhat.com> <20100301205620.GA26151@elte.hu> <20100302103045.GA28310@elte.hu> <4B937363.4070406@redhat.com> <20100307180142.GE20213@ghostprotocols.net>
In-Reply-To: <20100307180142.GE20213@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 08:01 PM, Arnaldo Carvalho de Melo wrote:
> Em Sun, Mar 07, 2010 at 11:35:31AM +0200, Avi Kivity escreveu:
>    
>> perf really is wonderful, but to be really competitive, and usable to
>> more developers, it needs to be in a graphical environment.  I want
>> 'perf report' output to start out collapsed and drill down by clicking
>> on a tree widget.  Clicking on a function name opens its definition.
>> 'perf annotate' should display annotations on my editor window, not in a
>> pager.  I should be able to check events on a list, not using 'perf
>> list'.
>>      
> Do you really think that more kernel developers would use perf more
> frequently if it had some GUI?
>    

Not much.  Is perf's target kernel developers exclusively?  Who are we 
writing this kernel for?

No wonder everything is benchmarked using kbuild.

> I plan to work on a ncurses tool combining aspects of the existing perf
> tools, integrating them more, like you suggest above, but even having
> worked on a pygtk tool that is close to the kernel [1], I'm unsure if
> doing it using gtk or QT would be something that would entice more
> developers to use it.
>    

Even for kernel developers there are advantages in a GUI, namely that 
features are easily discovered, the amount of information is easily 
controlled, and in that you can interact (not redo everything from 
scratch every time you want to change something).  The difference 
between a curses based tool and a true GUI are minimal for this audience.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

