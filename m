Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZLHNl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZLHNl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 08:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbZLHNl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 08:41:28 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:50329 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbZLHNl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 08:41:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TmIL4aii4WFA4VDHMezO755Gffch2H95hNQSgkjLXPtvEXksrLdyvtjSDZBv13F20J
         E1CjYQ35aDMD5GOhGvh18bdrKxk/adpFqKXtD1ILi29b7t/eUT1NRMBxpUa2EGZpmJ+k
         O3nfQHyHuFbw47cA/b4K2P0zUYdmSJw8sTpV8=
MIME-Version: 1.0
In-Reply-To: <1260278980.2165.21.camel@frodo>
References: <4B1DC476.3030700@cn.fujitsu.com> <20091208122255.GB5016@nowhere>
	 <1260278980.2165.21.camel@frodo>
Date: Tue, 8 Dec 2009 14:41:33 +0100
Message-ID: <c62985530912080541i424bed19j3e3795cdc9d5d66c@mail.gmail.com>
Subject: Re: [PATCH 00/13] tracing: various cleanups and small fixes (updated)
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/8 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 2009-12-08 at 13:23 +0100, Frederic Weisbecker wrote:
>> On Tue, Dec 08, 2009 at 11:13:58AM +0800, Li Zefan wrote:
>> > Updates:
>> >
>> > - took a further step to save more spaces (01/13)
>> > - fixed a mistake in (03/13)
>> > - collected some ACKs
>> >
>> >
>> > Here are some patches that I've collected. All are cleanups and
>> > small fixes, no change in functionality.
>> >
>> > As a result, 24K bytes are saved, and 87 lines of code are
>> > reduced:
>> >
>> >    text    data     bss     dec     hex filename
>> > 5355293 1961928 7103260 14420481         dc0a01 vmlinux.o.old
>> > 5331208 1961864 7103260 14396332         dbabac vmlinux.o
>> >
>> > ---
>> >  include/linux/ftrace_event.h       |    4 +-
>> >  include/linux/syscalls.h           |    6 +-
>> >  include/trace/ftrace.h             |   56 ++-----------
>> >  kernel/trace/ftrace.c              |   30 ++++---
>> >  kernel/trace/power-traces.c        |    2 -
>> >  kernel/trace/trace.c               |  166 +++++++++++++-----------------------
>> >  kernel/trace/trace.h               |   23 +++---
>> >  kernel/trace/trace_event_profile.c |    6 +-
>> >  kernel/trace/trace_events.c        |   38 +++++++--
>> >  kernel/trace/trace_export.c        |    4 -
>> >  kernel/trace/trace_kprobe.c        |    9 --
>> >  kernel/trace/trace_ksym.c          |   13 ++--
>> >  kernel/trace/trace_syscalls.c      |   18 +----
>> >  13 files changed, 144 insertions(+), 231 deletions(-)
>>
>>
>> I'm queuing these patches.
>
> I don't mind you queing them, but I still want to have a deeper look.
> Could you hold on a bit. I'll look at them today, and give an ack, or
> comments later on.
>
> Thanks,


Sure.
