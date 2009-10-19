Return-Path: <linux-kernel-owner+w=401wt.eu-S932361AbZJSXKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbZJSXKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 19:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbZJSXKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 19:10:04 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:50486 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838AbZJSXKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 19:10:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g1980klU+Jrm+G4rESSZX4KVndOeoJwjwinSwV7LaV42dJt37Bgxk/JF17b2vq/RHJ
         8XASFQkNrx+tWNjYzXEvRwqJhq+BQzIvnkdLS8gwZvwTQz/igtDC90CKFLa4YipHk1yJ
         nW5zrgUQtGuqjfgAh/qti5gFPrgYZQePI8UOw=
MIME-Version: 1.0
In-Reply-To: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
Date: Mon, 19 Oct 2009 19:10:06 -0400
Message-ID: <ad7a95ae0910191610q6f6200f1n112a71a0cbd483f1@mail.gmail.com>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf 
	probe and kprobe-tracer bugfixes
From: Ashwin Chaugule <ashbertslists@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       a.p.zijlstra@chello.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 8:07 PM, Masami Hiramatsu <mhiramat@redhat.com> wrote:

>  arch/x86/lib/x86-opcode-map.txt         |   23 ++++-
>  kernel/trace/trace_kprobe.c             |   39 ++++++--
>  tools/perf/Documentation/perf-probe.txt |   48 ++++++++++
>  tools/perf/Makefile                     |    5 +
>  tools/perf/builtin-probe.c              |   70 ++++++---------
>  tools/perf/command-list.txt             |    1
>  tools/perf/util/probe-finder.c          |  149 ++++++++++++++-----------------
>  tools/perf/util/probe-finder.h          |   17 ----
>  tools/perf/util/util.h                  |    9 ++
>  9 files changed, 206 insertions(+), 155 deletions(-)
>  create mode 100644 tools/perf/Documentation/perf-probe.txt
>

Masami,
           I really like your idea with kprobes ! I havent yet run
this stuff on my machine, but I've been planning to utilize kprobes
with perfevents too. Please let me know if the following functionality
is already possible with your patches.

The basic idea I had was to be able to profile any function in the
kernel using kprobes and use the perfevents framework to monitor
things like incorrect branch predictions, cache misses etc. for the
scope of that function. That way, we can fine tune kernel functions
that are in the hot path of kernel control flow, using gcc tricks,
inline assembly, or even architecture specific tricks.

Alternately, I think even dynamic trace could provide similar insight
with perfevents ? If none of this is already done, I plan to work on
this in my spare time and would like to team up with anyone else
interested.

Cheers,
Ashwin
