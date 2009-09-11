Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZIKPSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZIKPSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbZIKPSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:18:15 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51738 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbZIKPSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BzsHxJ7aaFxCVTZXpoAruswJM2xFI3r4hsew+SeIxjALTy5rDtX7R14WRi/ov/t61w
         GX0xJOWVJTgE//7Wbs/E0UuWWrDflewi4QhqWy2i4yacvm2++qRswWoxQETzZ/KuCmor
         e4JTLttaSIgsuyl2fIY5xE00w9DK5cRr/z2vA=
Date: Fri, 11 Sep 2009 17:18:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, edwintorok@gmail.com
Subject: Re: [PATCH 3/3] tracing: add latency format to function_graph
	tracer
Message-ID: <20090911151811.GB6119@nowhere>
References: <20090911135452.866274568@goodmis.org> <20090911135626.824079836@goodmis.org> <20090911145521.GA6119@nowhere> <1252681916.18996.697.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252681916.18996.697.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 11:11:56AM -0400, Steven Rostedt wrote:
> On Fri, 2009-09-11 at 16:55 +0200, Frederic Weisbecker wrote:
> 
> > Oh, BTW, what would you think about addding the current->lock_depth
> > in the latency format? That may help debug the bkl...
> 
> Hmm, that would require adding another field for all traces. I don't
> want to increase the size of an entry unneeded. BTW, this is for all
> entries (even events).


Right...

 
> Ug! I just noticed that tgid was added to struct trace_entry, with the
> only user as the user stack entry. This should be in the user stack
> field not something that goes into every event!
> 
> I guess I need to fix that too.
> 
> Well, maybe replacing tgid with lock_depth may not be a bad idea after
> all.


Yeah, would be nice. This would be an interesting  general purpose
field.

