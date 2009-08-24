Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbZHXLPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbZHXLPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZHXLPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:15:01 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53619 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZHXLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:15:00 -0400
Date: Mon, 24 Aug 2009 20:15:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Josh Stone <jistone@redhat.com>,
       linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 2/4] tracing: Make syscall_(un)regfunc arch-specific
Message-ID: <20090824111501.GB18420@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
	Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Jiaying Zhang <jiayingz@google.com>,
	Martin Bligh <mbligh@google.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>
References: <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <1250917125-6174-3-git-send-email-jistone@redhat.com> <20090823211422.GG6256@nowhere> <20090824014025.GA12653@linux-sh.org> <20090824084101.GE2424@elte.hu> <20090824085944.GA15330@linux-sh.org> <20090824095652.GC25267@elte.hu> <20090824103251.GA18106@linux-sh.org> <20090824110040.GA4050@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824110040.GA4050@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 01:00:40PM +0200, Ingo Molnar wrote:
> And the thing is, s390 was always a pleasure to deal with. I cannot 
> say the same about anything SH. SH always was a huge PITA to deal 
> with (to me at least), mainly because you seem to have a false sense 
> of entitlement: you think everyone else must be perfect and must not 
> affect you while you can sit on your own little island not worrying 
> about the rest of the world - who develops and tests core kernel 
> facilities for you. It doesnt work like that.
> 
If you had bothered to read any of my earlier mail you would realize that
this is complete and utter nonsense. I expect there to be breakage, and I
expect that I will be the one fixing it up (even when most of the time
that breakage is not even in my own tree). Unsurprisingly, this is
largely a result of SH being one of the first architectures testing these
new core kernel facilities, which is something you seem intent on just
writing off completely. I can imagine why s390 is a pleasure to deal
with in a -tip context, when you break their tree, no one complains.

Where I take issue with -next is that this is not an isolated thing, and
over time it has only become more frequent. In the case of -mm, releases
were infrequent, but we did have this thing called quality control,
something that is utterly lacking in -next and which the trees being
sucked in seem unable to adhere to on their own.

Rather than wasting any more time on this, we can continue this at kernel
summit during the -next session. If the consensus is that I'm just being
unconstructive and my workflow is inherently broken, I can live with
that.

> You are not being constructive at all.
> 
Nor have been any of your responses. At least we've found something to
agree on!
