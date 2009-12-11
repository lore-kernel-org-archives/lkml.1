Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbZLKVQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbZLKVQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbZLKVQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:16:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbZLKVQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:16:03 -0500
Message-ID: <4B22B672.9060402@redhat.com>
Date: Fri, 11 Dec 2009 16:15:30 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/8] perf-probe updates
References: <20091208220232.10142.2643.stgit@dhcp-100-2-132.bos.redhat.com> <20091209072220.GA4328@elte.hu> <20091209084341.GA21333@elte.hu> <4B1FE022.1030704@redhat.com> <4B201993.9020005@redhat.com> <20091211205141.GA1949@ghostprotocols.net>
In-Reply-To: <20091211205141.GA1949@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Wed, Dec 09, 2009 at 04:41:39PM -0500, Masami Hiramatsu escreveu:
>> Masami Hiramatsu wrote:
>>>> Here the failure was because the symbol does not exist.
>>>
>>> Yeah, so that's what I'm expecting to be implemented with below item :-)
>>>
>>>    - Symbol search by libelf/kallsyms
>>>
>>> I guess it will be done by using symbol.c.
>>> (Actually, current
>>
>> Oops, I might miss something, forgot it.
>> actually, current perf probe doesn't decode kallsyms/elf, it just depends on
>> kprobe-tracer. And kprobe-tracer will return -EINVAL not only if the symbol
>> was not found, but also other reasons.
>>
>> So, if we want to show below message, we need to decode elf or kallsyms.
> 
> Should be easy now with my latest patch :-)

Thanks! that's looks very useful for me!


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

