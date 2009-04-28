Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbZD1KKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbZD1KKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbZD1KKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:10:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57943 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbZD1KKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:10:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
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
In-Reply-To: <84144f020904280257j57b5b686k91cc4096a8e5ca29@mail.gmail.com>
References: <20090428093621.GD21085@elte.hu> <84144f020904280257j57b5b686k91cc4096a8e5ca29@mail.gmail.com>
Message-Id: <20090428190822.EBED.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 28 Apr 2009 19:10:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess the main question here is whether this approach will scale to
> something like kmalloc() or the page allocator in production
> environments. For any serious workload, the frequency of events is
> going to be pretty high.

Immediate Values patch series makes zero-overhead to tracepoint
while it's not used.

So, We have to implement to stop collect stastics way. it restore
zero overhead world.
We don't lose any performance by trace.



