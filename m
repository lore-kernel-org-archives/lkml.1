Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbZD1UxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbZD1UxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZD1UxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:53:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58052 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZD1UxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:53:08 -0400
Date: Tue, 28 Apr 2009 16:51:54 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zhaolei@cn.fujitsu.com, mingo@elte.hu, kosaki.motohiro@jp.fujitsu.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for worklet lifecycle tracing
Message-ID: <20090428205154.GE13893@redhat.com>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com> <20090424130616.a3c217cb.akpm@linux-foundation.org> <y0mr5zclmhi.fsf@ton.toronto.redhat.com> <20090428114827.afb8bbe6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428114827.afb8bbe6.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew -

On Tue, Apr 28, 2009 at 11:48:27AM -0700, Andrew Morton wrote:
> [...]
> > To be fair, if you ask for someone to specify and quantify the
> > "benefits" side of this, shouldn't someone specify and quantify the
> > "cost" side of this too?
> [...]
> >  That way we would have something to compare.
> 
> Well, there are two aspects to this.  There's the immediate up-front
> cost - a little added complexity, more code, etc.

Yes, a little.


> But there's also the where-the-hell-is-this-all-going question.  Are we
> going to end up with hundreds or thousands of tracepoints sprinkled all
> over core kernel?  If so, what use are they?  What userspace tools will
> be used to pull them into something useful?  Who will be developing
> those tools and are they involved in the development of the
> tracepoints?  

(Well, that's back to the "benefits" side, isn't it?)


> Will this proliferation of static tracepoints actively kill off the
> development and maturation of dynamic tracepoints?  If so, is that
> good?

I hope not, but I believe the consensus has been that both dynamic and
static instrumentation are necessary & useful.


> From where I sit it looks like a mad scramble to sprinkle fairly
> random tracepoints all over the place under the assumption that
> this-may-be-useful-to-someone-one-day.  But of course, that means
> that they many never be useful to anyone ever. [...]

You may not be giving enough credit to the subsystem developers.  If
they opine that those tracepoints may accomplish (or have already
accomplished) something forseeably useful, at a reasonably "little"
cost, should it not require a large burden of proof to overcome their
judgement?


- FChE
