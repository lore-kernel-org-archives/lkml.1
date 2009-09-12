Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZILBUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZILBUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 21:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZILBUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 21:20:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbZILBUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 21:20:48 -0400
Message-ID: <4AAAF829.3070302@redhat.com>
Date: Fri, 11 Sep 2009 21:23:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mark Wielaard <mjw@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based	event
 tracer update and perf support
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090911013332.GB16396@nowhere> <y0mr5udjoc8.fsf@fche.csb> <20090911190651.GA22065@infradead.org> <1252698613.2470.6.camel@hermans.wildebeest.org> <20090911200317.GA3827@infradead.org>
In-Reply-To: <20090911200317.GA3827@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Fri, Sep 11, 2009 at 09:50:13PM +0200, Mark Wielaard wrote:
>> On Fri, 2009-09-11 at 15:06 -0400, Christoph Hellwig wrote:
>>> On Fri, Sep 11, 2009 at 03:03:35PM -0400, Frank Ch. Eigler wrote:
>>>> Frederic Weisbecker<fweisbec@gmail.com>  writes:
>>>>
>>>>> [...]  I'm really looking forward seeing this C expression-like
>>>>> kprobe creation tool.  It seems powerful enough to replace printk +
>>>>> kernel rebuild.  No need anymore to write some printk to debug,
>>>>> worrying, [...]
>>>>
>>>> To a large extent, systemtap had delivered this already some years
>>>> ago, including the cushy ponies dancing in the sunlight.  While such
>>>> low-level machinery is fine, some of our experience indicates that it
>>>> is dramatically easier to use if high-level, symbolic, debugging data
>>>> is used to compute probe locations and variable names/types/locations.
>>>
>>> No, systemtap has been for years failing to delivers this in a way that
>>> it could be usefully integrated into the kernel.
>>
>> You are saying "No" to a claim Frank didn't even make.
>
> He said systemtap had delivered it, which is not the case.  It has
> implemented it, but not actually delivered it in a useful way.

I assume that he has meant that systemtap had delivered to end-users,
and that is certainly true. Systemtap has been released and distributed
with many distributions. I know there are many systemtap users nowadays.

However, indeed, that was not so useful way especially for kernel developers.
Systemtap developers have also recognized this problem, and we are trying
to fix it for good relationship with upstream kernel.

I'd like to make my work useful not only for upstream kernel and ftrace,
but also for systemtap. Through this enhancement, knowledge and
experiences of systemtap will be transferred to upstream. I think
systemtap can also use it by re-implementing on in-kernel tracing
functions. I believe we can collaborate on this work, at least
on stabilizing tracing functions.


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

