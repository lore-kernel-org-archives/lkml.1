Return-Path: <linux-kernel-owner+w=401wt.eu-S1753554AbZDTBtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbZDTBtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZDTBtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:49:15 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59780 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZDTBtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:49:14 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Zhaolei" <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make workqueuetracepoints use TRACE_EVENT macro
Cc: kosaki.motohiro@jp.fujitsu.com, "Ingo Molnar" <mingo@elte.hu>,
       "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Tom Zanussi" <tzanussi@gmail.com>, <linux-kernel@vger.kernel.org>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <47EF9F5C609F496FBBD423EA81A00920@zhaoleiwin>
References: <20090420103612.4B4E.A69D9226@jp.fujitsu.com> <47EF9F5C609F496FBBD423EA81A00920@zhaoleiwin>
Message-Id: <20090420104734.4B51.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 20 Apr 2009 10:49:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
> >> Thanks for your suggest.
> >> I read distinction between workqueue and worklet.
> >> In my schedule, this patch is first step of our target, my image of steps is:
> >>   1: Move current workqueuetracepoints into TRACEEVENT (this patch)
> >>   2: Make workqueuetrace support per-worklet output (doing)
> >>   3: Add time information to workqueuetrace's worklet stat (need above new TRACEPOINT)
> >> 
> >> So, i prepared to add new worklet tracepoints in step3.
> >> What's your opinion?
> > 
> 
> Hello, Kosaki-san
> 
> > Zhao-san, Maintainer's easy reviewability is very important.
> I agree it.
> 
> > Can you switch 2 and 3 ?
> Sorry for my poor English.
> I means 2 is to add worklet stat, 3 is to add more information to worklet stat,
> 3 is based on 2, switch 2 and 3 means merge 2 and 3.

OK.

thus, I recoomend to pending 2 and 3. and change 1 as Ingo suggested.
if not, reviewer might forgot this thread.



