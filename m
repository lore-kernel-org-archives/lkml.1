Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbZKBV6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbZKBV6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbZKBV6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:58:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874AbZKBV6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:58:04 -0500
Message-ID: <4AEF55AB.50701@redhat.com>
Date: Mon, 02 Nov 2009 16:56:59 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes and
 perf-probe syntax changes
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu> <4AE9C919.4070003@redhat.com> <4AEF4C29.2060501@redhat.com> <20091102212632.GH4880@nowhere>
In-Reply-To: <20091102212632.GH4880@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Nov 02, 2009 at 04:16:25PM -0500, Masami Hiramatsu wrote:
>> Masami Hiramatsu wrote:
>>> Ingo Molnar wrote:
>>>> What we want here is two fold:
>>>>
>>>>     - enable kprobes event support when perf events is enabled and kprobes
>>>>       is enabled. We dont want another config option for it.
>>>
>>> Sure, at least that combination should enable kprobe-tracer forcibly.
>>
>> Hmm, someone may not want to enables kprobe-tracer. Perhaps,
>> "default y if (EVENT_PROFILE)" is enough, isn't it?
>>
>
>
> I guess it should be sufficient yeah. We want to strongly recommend
> the kprobe events if we have enabled perf, but we don't want to force
> it.
>
> Also in this case we need a verbose runtime report of the lack of this
> tracer in debugfs from perf probe if needed.

Sure, error message should be changed as warning user to enable
CONFIG_KPROBE_TRACER :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

