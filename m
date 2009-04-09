Return-Path: <linux-kernel-owner+w=401wt.eu-S936494AbZDIQql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936494AbZDIQql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936138AbZDIQil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:38:41 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:42248 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936129AbZDIQik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:38:40 -0400
Message-ID: <49DE243C.8070505@oracle.com>
Date: Thu, 09 Apr 2009 09:37:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH][RESEND] tracing: consolidate documents
References: <49DD6E2B.6090200@cn.fujitsu.com> <49DD70E0.9080302@cn.fujitsu.com>	 <49DD728D.8030608@cn.fujitsu.com> <20090409041319.GE20692@elte.hu> <84144f020904082216hfb5f5ene87781f9aaf7e76c@mail.gmail.com>
In-Reply-To: <84144f020904082216hfb5f5ene87781f9aaf7e76c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49DE2430.0111:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Thu, Apr 9, 2009 at 7:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> * Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>>> Li Zefan wrote:
>>>> Move tracepoints.txt, ftrace.txt and mmiotrace.txt to the new
>>>> directory trace/
>>>>
>>> Should we also move kmemtrace.txt to trace/, or leave it in vm/?
>> Eduard, Pekka, any preferences?
>>
>> Are symbolic links in Documentation/ frowned upon? I think it would
>> be best to have the file in both places:
>>
>> We do want to direct people interested in Documentation/vm/ to
>> kmemtrace ... and we do want to let people who are interested in
>> Documentation/trace/ that there's kmemtrace.
>>
>> Tracing and instrumentation is generally a multi-subsystem thing.
> 
> I'm not sure a symbolic link is necessary. Just put it under trace/.

Thanks.  I like that too.

-- 
~Randy
