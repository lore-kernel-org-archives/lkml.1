Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZKTS6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZKTS6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZKTS6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:58:42 -0500
Received: from relay1.sgi.com ([192.48.179.29]:48537 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752284AbZKTS6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:58:41 -0500
Message-ID: <4B06E6DD.6080909@sgi.com>
Date: Fri, 20 Nov 2009 10:58:37 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
References: <20091112171934.584037000@alcatraz.americas.sgi.com> <alpine.DEB.2.00.0911121247420.9544@chino.kir.corp.google.com> <20091113095350.GC1364@elte.hu> <alpine.DEB.2.00.0911130158390.13911@chino.kir.corp.google.com> <20091113101326.GA17451@elte.hu> <20091120183708.GA1434@ucw.cz>
In-Reply-To: <20091120183708.GA1434@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Pavel Machek wrote:
> Hi!
> 
>> There's two problems outlined in this discussion:
>>
>>  A) too verbose bootup that is annoying with 64 CPUs and a show-stopper
>>     with 4096 CPUs.
>>
>>  B) the ad-hoc nature of our topology enumeration. Some of it is in
>>     /sys, some of it is in printk logs. None really works well and 
>>     there's no structure in it.
>>
>> The simplest solution for (A) is what i suggested a few mails ago: dont 
>> print the information by default, but allow (for trouble-shooting) 
>> purposes for it to be printed when a boot option is passed.
> 
> Well, yes, it is *simplest*, but is it best? Example printing 'cpus
> 0-31 stepping 3, cpus 32-63 stepping 4' seem rather convincing --such
> info should be there by default and not after speciial option...
> 									Pavel

I think that Ingo had a point.  If it's printing a summary after the
all the cpu's boot, then it should also be available online, which in
this case it's in /proc/cpuinfo.

Ingo - was there anything left open on my last submission that I have
to deal with, to gain acceptance?

Thanks,
Mike
