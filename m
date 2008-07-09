Return-Path: <linux-kernel-owner+w=401wt.eu-S1757855AbYGIQAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbYGIQAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYGIQAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:00:17 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:39094 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845AbYGIQAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:00:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEADV8dEhMQWVt/2dsb2JhbACBW68X
Date: Wed, 9 Jul 2008 12:00:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 05/15] LTTng instrumentation - scheduler (repost)
Message-ID: <20080709160011.GA10601@Krystal>
References: <20080709145929.352201601@polymtl.ca> <20080709150045.025136754@polymtl.ca> <20080709153434.GA9186@Krystal> <20080709153911.GB23339@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080709153911.GB23339@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:57:15 up 34 days, 20:38,  4 users,  load average: 2.96, 2.45,
	2.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > There were 2 rejects when I ported the patch to linux-next. Sorry. 
> > Here is a repost.
> 
> there's still a standing objection (NAK) from Peter Zijstra so none of 
> this can go into linux-next yet i'm afraid.
> 
> 	Ingo

Hi Ingo,

This "tracepoint" infrastructure has been created to answer to Peter's
concerns about trace_mark uglyness. The last comment I had from him when
we discussed the tracepoint idea was "Looking forward to your
proposal..", so I guess it's up to him to decide if tracepoints are
clean enough to live.

I'll submit a revised scheduler instrumentation which turns all
scheduler trace_mark() already in linux-next into tracepoints, with the
same arguments. ftrace will have to be updated accordingly.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
