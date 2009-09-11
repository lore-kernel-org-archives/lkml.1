Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZIKPu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZIKPu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZIKPu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:50:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61668 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbZIKPu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:50:27 -0400
Subject: Re: [PATCH 3/3] tracing: add latency format to function_graph
 tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
In-Reply-To: <4AAA6EE2.8000807@gmail.com>
References: <20090911135452.866274568@goodmis.org>
	 <20090911135626.824079836@goodmis.org> <20090911145521.GA6119@nowhere>
	 <1252681916.18996.697.camel@gandalf.stny.rr.com>
	 <20090911151811.GB6119@nowhere>  <4AAA6EE2.8000807@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 11:50:29 -0400
Message-Id: <1252684229.18996.699.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 18:38 +0300, Török Edwin wrote:
> On 2009-09-11 18:18, Frederic Weisbecker wrote:
> > On Fri, Sep 11, 2009 at 11:11:56AM -0400, Steven Rostedt wrote:
>   
> >> Ug! I just noticed that tgid was added to struct trace_entry, with the
> >> only user as the user stack entry. This should be in the user stack
> >> field not something that goes into every event!
> >>
> >> I guess I need to fix that too.
> >>     
> 
> Indeed tgid should be part of struct userstack_entry, and set in
> ftrace_trace_userstack.
> Do you want to me to write up a patch for that, or have you already
> fixed it?

I've just fixed it, thanks!

-- Steve


