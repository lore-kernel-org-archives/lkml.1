Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZDTBjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZDTBjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZDTBiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:38:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52931 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbZDTBiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:38:14 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Zhaolei" <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make workqueuetracepoints use TRACE_EVENT macro
Cc: kosaki.motohiro@jp.fujitsu.com, "Ingo Molnar" <mingo@elte.hu>,
       "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Tom Zanussi" <tzanussi@gmail.com>, <linux-kernel@vger.kernel.org>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <8B355A33A87242028FF3EF61F39BDFB8@zhaoleiwin>
References: <20090417134557.GA23493@elte.hu> <8B355A33A87242028FF3EF61F39BDFB8@zhaoleiwin>
Message-Id: <20090420103612.4B4E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 20 Apr 2009 10:38:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks for your suggest.
> I read distinction between workqueue and worklet.
> In my schedule, this patch is first step of our target, my image of steps is:
>   1: Move current workqueuetracepoints into TRACEEVENT (this patch)
>   2: Make workqueuetrace support per-worklet output (doing)
>   3: Add time information to workqueuetrace's worklet stat (need above new TRACEPOINT)
> 
> So, i prepared to add new worklet tracepoints in step3.
> What's your opinion?

Zhao-san, Maintainer's easy reviewability is very important.
Can you switch 2 and 3 ?

it cause Ingo can review the patch fill his request or not directly.


