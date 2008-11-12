Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYKLPhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYKLPhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 10:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYKLPgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 10:36:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34587 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYKLPgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 10:36:55 -0500
Date: Wed, 12 Nov 2008 10:36:52 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2] unlikely profiler and tracer
In-Reply-To: <20081112130714.GA24472@elte.hu>
Message-ID: <alpine.DEB.1.10.0811121035180.2529@gandalf.stny.rr.com>
References: <20081112051438.843792214@goodmis.org> <20081112105314.GB31958@elte.hu> <alpine.DEB.1.10.0811120800140.2529@gandalf.stny.rr.com> <20081112130714.GA24472@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 12 Nov 2008, Ingo Molnar wrote:
> two more small details i noticed:
> 
>  - does it do proper self-test? It doesnt seem so at first sight.

Hmm, no. The problem is that it is a switch to be added to other tracers.
There's not a branch profiling tracer itself. I could add one that just 
does that, and that could do the self test.

> 
>  - i'd suggest a rename patch that does UNLIKELY_PROFILE => BRANCH_PROFILING.
> 
>     [ 'to profile' is the verb we use generally (it's a noun too but 
>        we tend to use 'profiling' for that in other places of the
>        kernel) - so we already have CONFIG_PROFILING, etc. ]

I have no hard feelings on its name. Branch profiling is fine with me.

-- Steve

