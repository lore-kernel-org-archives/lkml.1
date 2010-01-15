Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab0AOGVr (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 01:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354Ab0AOGVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 01:21:46 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46059 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0AOGVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 01:21:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: OOM-Killed process don't invoke pagefault-oom
Cc: kosaki.motohiro@jp.fujitsu.com, Jeff Dike <jdike@addtoit.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20100114130257.GB8381@laptop>
References: <20100114191940.6749.A69D9226@jp.fujitsu.com> <20100114130257.GB8381@laptop>
Message-Id: <20100115085146.6EC0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 15 Jan 2010 15:21:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> I don't think this should be required, because the oom killer does not
> kill a new task if there is already one in memdie state.
> 
> If you have any further tweaks to the heuristic (such as a fatal signal
> pending), then it should probably go in select_bad_process() or
> somewhere like that.

I see, I misunderstood. very thanks.



