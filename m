Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbZHSN6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbZHSN6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZHSN6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:58:12 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46901 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZHSN6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uukTClFD/YxrR35+Xuqgt+vI4msKdZ2xiHgQMr4pl+5kr7Bxlh3HdqP5Zxpp5HzUB1
         wPoWimJ+9iYGKZxVtY4/Om/QAUQkrxJaR+ol9k9hWE3uqTdBJOApGnSZrN8/ernT2oMQ
         ONSSoeV/S8WgT1yUsSyFYzCAu84+tkBVEdwec=
Date: Wed, 19 Aug 2009 15:58:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH -tip v14 07/12] tracing: Introduce TRACE_FIELD_ZERO()
	macro
Message-ID: <20090819135802.GA4972@nowhere>
References: <20090813203403.31965.20973.stgit@localhost.localdomain> <20090813203501.31965.30172.stgit@localhost.localdomain> <20090819010903.GI5231@nowhere> <4A8B615B.7000200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8B615B.7000200@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 10:20:11PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> > On Thu, Aug 13, 2009 at 04:35:01PM -0400, Masami Hiramatsu wrote:
> >> Use TRACE_FIELD_ZERO(type, item) instead of TRACE_FIELD_ZERO_CHAR(item).
> >> This also includes a fix of TRACE_ZERO_CHAR() macro.
> > 
> > 
> > I can't find what the fix is about (see below)
> 
> Ah, OK. This patch actually includes two parts.
> 
> One is introducing TRACE_FIELD_ZERO which is more generic than
> TRACE_FIELD_ZERO_CHAR, I think.
> 
> Another is a typo fix of TRACE_ZERO_CHAR.


Ok.

 
> >>  
> >> +#undef TRACE_FIELD_ZERO
> >> +#define TRACE_FIELD_ZERO(type, item)
> >> +
> > 
> > 
> > 
> > Is it about the above moving?
> > If so, could you just tell so that I can add something about
> > it in the changelog.
> 
> No, I assume that TRACE_ZERO_CHAR is just a typo of TRACE_FIELD_ZERO_CHAR.
> (because I couldn't find any other TRACE_ZERO_CHAR)
> 
> BTW, this patch may not be needed after applying patch 10/12, since
> it removes ftrace event definitions of TRACE_KPROBE/KRETPROBE.
> 
> Perhaps, would I better merge and split those additional patches(and
> remove this change)?
> (It also could make the incremental review hard...)
> 
> Thank you,
> 


No let's keep it as is. It should be fine.

Thanks.


> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

