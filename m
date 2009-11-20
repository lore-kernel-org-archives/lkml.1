Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZKTITX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZKTITX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 03:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZKTITX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 03:19:23 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:38096 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZKTITW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 03:19:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CVOSg7oSn6zQuSuKahbpH2DtAJUoPirl+P3m6xr2OduAGya2pYyBlGVlJMyE86nxCg
         ts2gW9fhMf+EiNRhUobfBXRtlmoWHLueHs29VdBdu2pdkvO1bI1M2r6VcdEXSoPlceuV
         gBtKCQFpA0mJa6WGxFpJbdZ0kMopON/mopNQw=
MIME-Version: 1.0
In-Reply-To: <20091120081440.GA19778@elte.hu>
References: <4B064AF5.9060208@cn.fujitsu.com> <20091120081440.GA19778@elte.hu>
Date: Fri, 20 Nov 2009 10:19:27 +0200
X-Google-Sender-Auth: 27931d659e81f010
Message-ID: <84144f020911200019p4978c8e8tc593334d974ee5ff@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 10:14 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Pekka, Eduard and the other slab hackers might have ideas about what
> other stats they generally like to see to judge the health of a workload
> (or system).

kmalloc()/kfree() CPU ping-pong call-sites (i.e. alloc and free
happening on different CPUs) is one interesting metric we haven't
implemented yet. Valgrind massif tool type of output graph would be
helpful as well:

http://valgrind.org/docs/manual/ms-manual.html

On Fri, Nov 20, 2009 at 10:14 AM, Ingo Molnar <mingo@elte.hu> wrote:
> If this iteration looks good to the slab folks then i can apply it as-is
> and we can do the other changes relative to that. It looks good to me as
> a first step, and it's functional already.

Yeah, looks OK to me as the first step. Patch 2 looks premature,
though, looking at the output of "perf kmem" from patch 1.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

                        Pekka
