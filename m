Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZJTRvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZJTRvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 13:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZJTRvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 13:51:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:56132 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbZJTRvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 13:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SD48im9ntEEmf1K9xSPj1X62o72zdqbSEmU0jzrHM59cpSMHZzYQ6Av75BwVID08Xz
         nyp+kBpwRw83cKBh5ysbvS7JbYaZQqSFKIE1TuJ9Qy5HZV5n7hx6EbU7kZ1KomWRoYKT
         EvJLJX+QQbfMkpGocuePONrkQGV9zX9lOXF8E=
Date: Tue, 20 Oct 2009 19:51:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
	probe and kprobe-tracer bugfixes
Message-ID: <20091020175116.GD4906@nowhere>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere> <20091019112125.GA12829@elte.hu> <20091019193248.GB4880@nowhere> <20091020064334.GK8550@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020064334.GK8550@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 08:43:34AM +0200, Ingo Molnar wrote:
> also useful for command line workflows: 'perf probe --list' output - i 
> think we users to generate func_symbol+rel_position kind of probes.
> 
> Plus a relative position is more intuitive as well. If you see 
> 'schedule+10' versus 'schedule+102', you'll know it immediate that the 
> first one is early in the function while the second one is near the end.
> 
> If you see 'schedule@2465' versus 'schedule@2555' that kind of 'where in 
> the function is the probe, roughly' subjective impression is lost.
> 
> 	Ingo


Yeah, from a probe id reading POV, that's much better.

