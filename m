Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbZD1KLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbZD1KLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbZD1KLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:11:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51381 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbZD1KLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:11:06 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-2022-JP?B?RnIbJEJxRXFTGyhCaWM=?= Weisbecker 
	<fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090428095551.GB21168@localhost>
References: <20090428093833.GE21085@elte.hu> <20090428095551.GB21168@localhost>
Message-Id: <20090428190015.EBEA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 28 Apr 2009 19:11:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I am one of most strongly want guys to MM tracepoint. but No, many 
> > > cunstomer never permit to use drop_caches.
> > 
> > See my other mail i just sent: it would be a natural extension of 
> > tracing to also dump all current object state when tracing is turned 
> > on. That way no drop_caches is needed at all.
> 
> I can understand the merits here - I also did readahead
> tracing/accounting in _one_ piece of code. Very handy.
> 
> The readahead traces are now raw printks - converting to the ftrace
> framework would be a big win.
>
> But. It's still not a fit-all solution. Imagine when full data _since_
> booting is required, but the user cannot afford a reboot.
> 
> > But it has to be expressed in one framework that cares about the 
> > totality of the kernel - not just these splintered bits of 
> > instrumentation and pieces of statistics.
> 
> Though minded to push the kpageflags interface, I totally agree the
> above fine principle and discipline :-)

Yeah.
I totally agree your claim.

I'm interest to both ftrace based readahead tracer and this patch :)




