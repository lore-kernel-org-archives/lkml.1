Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZKMQKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZKMQKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 11:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZKMQKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 11:10:19 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34938 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754604AbZKMQKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 11:10:18 -0500
Message-ID: <4AFD84E9.1010908@sgi.com>
Date: Fri, 13 Nov 2009 08:10:17 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <87tyxmy6x6.fsf@basil.nowhere.org> <4AE5E48F.6020408@sgi.com> <20091026215544.GA3355@basil.fritz.box> <4AEB3D95.50300@sgi.com> <4AEEBE65.3070202@linux.intel.com> <4AEF3143.2030701@sgi.com> <20091112222200.GA19109@redhat.com> <4AFC92DD.3020105@zytor.com>
In-Reply-To: <4AFC92DD.3020105@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:
> On 11/12/2009 02:22 PM, Dave Jones wrote:
>> But I don't disagree with Andi either, that it's not particularly useful,
>> and we can get all this from userspace in /proc/cpuinfo, or x86info.
>>
> 
> I personally don't think it's useful at all.  It gives information about
> the processor which can be obtained from other sources.  What we want is
> enough information that the CPU can be unambiguously identified, so that
> when someone posts dmesg we can tell what machine they came from.
> 
> 	-hpa

Can we say the same thing about the sched debug messages?  It's even more
painful because the number of lines output is exponential to the number
of cpus.

Thanks,
Mike
