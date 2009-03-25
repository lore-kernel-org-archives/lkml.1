Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZCYBNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZCYBNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZCYBNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:13:37 -0400
Received: from ozlabs.org ([203.10.76.45]:47036 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbZCYBNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:13:36 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/9] LTTng instrumentation - kernel
Date: Wed, 25 Mar 2009 11:43:11 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>
References: <20090324155625.420966314@polymtl.ca> <20090324160148.872305963@polymtl.ca> <20090324183313.GH31117@elte.hu>
In-Reply-To: <20090324183313.GH31117@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251143.12472.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009 05:03:13 Ingo Molnar wrote:
> 
> (Rusty Cc:-ed - for the module.c tracepoints below)

Thanks, tho they look fine and non-intrusive to me.

> I believe that to have a complete picture of module usage, module 
> refcount get/put events should be included as well, beyond the basic 
> load/free events.
> 
> These both have performance impact (a module get/put in a fastpath 
> hurts scalability), and are informative in terms of establishing the 
> module dependency graph.

A module_get()/put() should not hurt scalability at all!  I went to great and
horrible lengths to ensure that was the case since the rewrite in 2.4.

But a module dependency graph et. al. would be kind of cool.

Thanks,
Rusty.
