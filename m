Return-Path: <linux-kernel-owner+w=401wt.eu-S1751780Ab0ARIVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab0ARIVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469Ab0ARIVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:21:25 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44935 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0ARIVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:21:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: OOM-Killed process don't invoke pagefault-oom
Cc: kosaki.motohiro@jp.fujitsu.com, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20100118072946.GA10052@laptop>
References: <20100115085146.6EC0.A69D9226@jp.fujitsu.com> <20100118072946.GA10052@laptop>
Message-Id: <20100118172032.5F1C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Jan 2010 17:21:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jan 15, 2010 at 03:21:40PM +0900, KOSAKI Motohiro wrote:
> > > Hi,
> > > 
> > > I don't think this should be required, because the oom killer does not
> > > kill a new task if there is already one in memdie state.
> > > 
> > > If you have any further tweaks to the heuristic (such as a fatal signal
> > > pending), then it should probably go in select_bad_process() or
> > > somewhere like that.
> > 
> > I see, I misunderstood. very thanks.
> 
> Well, it *might* be a good idea to check for fatal signal pending
> similar your patch. Because I think there could be large latency between
> the signal and the task moving to exit state if the process is waiting
> uninterruptible in the kernel for a while.
> 
> But if you do it in select_bad_process() then it would work for all
> classes of oom kill.

Thank you for good advise. I'll make next version so :)



