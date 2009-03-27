Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbZC0UUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbZC0UUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZC0UUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:20:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36327 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbZC0UUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:20:34 -0400
Message-ID: <49CD3507.3080409@redhat.com>
Date: Fri, 27 Mar 2009 16:20:23 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip 3/4 V3] tracing: kprobe-tracer plugin supports	arguments
References: <49CC08D2.30608@redhat.com> <20090327114453.GB5976@nowhere> <49CCFAD8.7040304@redhat.com> <20090327181539.GA6005@nowhere>
In-Reply-To: <20090327181539.GA6005@nowhere>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
>>> Anyway both would be handy:
>>>
>>> rp: current ip
>>> ra: return address
>> current ip can be fetched by 'r12' on i386 ('r16' on x86-64).
>> (hmm, we'd better support %ip, %ax, etc.)
>>
> 
> 
> Yes, as an example, I'm currently unable to tell you
> which number is esi :)

Agreed. But I doubt that we can implement it before moving
fetch_* APIs into arch/ directory, can we?


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

