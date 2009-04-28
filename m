Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZD1JUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZD1JUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZD1JTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:19:53 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:46574 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbZD1JTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fuM9sI2ejiF2ajrDo+bAktsI8DhtPdxjAhCL/UmO1knHqnPRmf9RkInjotkebLzUdd
         LRvcCn96ReB3u6Nqb4Ji8S4Dc46BntLjGG5YrlWRoTZvJJVFaypu/7mI9zaF+ZyqO9cq
         v5vnvulffKhekSnbjy5eLeEDCbpzUpytA7Vzg=
MIME-Version: 1.0
In-Reply-To: <20090428091508.GA21085@elte.hu>
References: <20090428010907.912554629@intel.com>
	 <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu>
	 <20090428074031.GK27382@one.firstfloor.org>
	 <1240909484.1982.16.camel@penberg-laptop>
	 <20090428091508.GA21085@elte.hu>
Date: Tue, 28 Apr 2009 12:19:50 +0300
X-Google-Sender-Auth: 3a967fc62945d38f
Message-ID: <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, 2009-04-28 at 09:40 +0200, Andi Kleen wrote:
>> > > I think i have to NAK this kind of ad-hoc instrumentation of kernel
>> > > internals and statistics until we clear up why such instrumentation

* Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> > I think because it has zero fast path overhead and can be used
>> > any time without enabling anything special.

On Tue, Apr 28, 2009 at 12:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
> ( That's a dubious claim in any case - tracepoints are very cheap.
>  And they could be made even cheaper and such efforts would benefit
>  all the tracepoint users so it's a prime focus of interest.
>  Andi is a SystemTap proponent, right? I saw him oppose pretty much
>  everything built-in kernel tracing related. I consider that a
>  pretty extreme position. )

I have no idea how expensive tracepoints are but I suspect they don't
make too much sense for this particular scenario. After all, kmemtrace
is mainly interested in _allocation patterns_ whereas this patch seems
to be more interested in "memory layout" type of things.

                                                Pekka
