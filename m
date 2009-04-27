Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbZD0QlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbZD0QlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbZD0QlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:41:12 -0400
Received: from fifo99.com ([67.223.236.141]:33800 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175AbZD0QlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:41:11 -0400
X-Greylist: delayed 667 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Apr 2009 12:41:11 EDT
Subject: Re: [PATCH 0/5] [PATCH][GIT PULL] remove unnecessary (un)likelys
From: Daniel Walker <dwalker@fifo99.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <20090325051920.406564281@goodmis.org>
References: <20090325051920.406564281@goodmis.org>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 09:30:04 -0700
Message-Id: <1240849804.7763.45.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 01:19 -0400, Steven Rostedt wrote:
> Ingo,
> 
> I guess this can go through you. This is a start of clean ups to
> get rid of (un)likelys that are at least 50% incorrect. This series
> has some that are 100% incorrect.
> 
> The branch profiler used is from 2.6.29 which does not have the
> fixed header that is in tip. This branch is also based off of
> 2.6.29 and not tip.
> 
> Perhaps, since some of these cases are 100% wrong they can simply
> be reversed. I'm choosing to just remove the annotation, and then
> later I'll be using the full branch profiler to look for candidates
> for adding (un)likelys.  That way each added annotation can be
> scrutinized individually.

What kind of methodology are you using to determine which to remove? It
looks like some you review the code, and other you just remove based on
it being %50 wrong or more.. I found workloads are especially important.
Where finding one that is %50 or %100 wrong does necessarily mean
anything..


Daniel

