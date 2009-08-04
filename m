Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbZHDUTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbZHDUTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZHDUTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:19:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988AbZHDUTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:19:30 -0400
Date: Tue, 4 Aug 2009 13:18:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       rostedt@goodmis.org, mel@csn.ul.ie, lwoodman@redhat.com,
       riel@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing
 script for page-allocator-related ftrace events
Message-Id: <20090804131818.ee5d4696.akpm@linux-foundation.org>
In-Reply-To: <20090804195717.GA5998@elte.hu>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie>
	<1249409546-6343-5-git-send-email-mel@csn.ul.ie>
	<20090804112246.4e6d0ab1.akpm@linux-foundation.org>
	<20090804195717.GA5998@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009 21:57:17 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Let me demonstrate these features in action (i've applied the 
> patches for testing to -tip):

So?  The fact that certain things can be done doesn't mean that there's
a demand for them, nor that anyone will _use_ this stuff.

As usual, we're adding tracepoints because we feel we must add
tracepoints, not because anyone has a need for the data which they
gather.

There is some benefit in providing MM developers with some code which
they can copy-n-paste for their day-to-day activity.  But as I said,
they can do that with vmstat too.


If we can get rid of vmstat all together (and meminfo) and replace all
that with common infrastructure then that would be a good cleanup.  But
if we end up leaving vmstat and meminfo in place and then adding
_another_ statistic gathering mechanism in parallel then we haven't
cleaned anything up at all - it just gets worse.


I don't really oppose the patches - they're small.  But they seem
rather useless too.

It would be nice to at least partially remove the vmstat/meminfo
infrastructure but I don't think we can do that?
