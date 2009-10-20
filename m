Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbZJTOZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbZJTOZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 10:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZJTOZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 10:25:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZJTOZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 10:25:53 -0400
Message-ID: <4ADDC8BB.3030207@redhat.com>
Date: Tue, 20 Oct 2009 10:27:07 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
 probe and kprobe-tracer bugfixes
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <4ADCB655.2020101@redhat.com> <20091020065426.GN8550@elte.hu>
In-Reply-To: <20091020065426.GN8550@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> How about the following syntax?
>> <adding>
>> perf probe schedule
>> perf probe --add schedule
>>
>> <deleting>
>> perf probe --del schedule
>> perf probe --del all	/* delete all probepoints */
>>
>> So, this doesn't symmetric, but provides simple way to add a probe.
> 
> agreed. For deletion, eventually this:
> 
>   perf probe --del "*"
> 
> should also work - as should other regexp (or glob) matches on a range 
> of existing probes.

Ah, that's a nice idea :-), it allows user to delete a group of
probes, like --del "schedule*".

> plus there should be a perf probe call to output all current probes as 
> perf probe commands - so that it can be saved (and restored).

Sure. 'perf probe --save file' & 'perf probe --restore file' will be
fine for me.

Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

