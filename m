Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZJEVVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZJEVVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZJEVVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:21:52 -0400
Received: from mail-ew0-f225.google.com ([209.85.219.225]:41119 "EHLO
	mail-ew0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbZJEVVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pqY1CxKXfrXyHrVV5WgRXY+UrXgenQzmuQjGbHPY5mrjc/pIcDm4YO10H2NGw6qWfN
         vSW4AfrZnwCLH2r3NmSPNs6vjPYaBjiuzdzwxph9zEuKiqpWhC8zgaBYjhZU01l5uUfb
         OGvIQCu6dAbMwlTXN9AOFcE2ZT91K6lDvUX7U=
Date: Mon, 5 Oct 2009 23:21:39 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v2 1/5] tracing/kprobes: Rename special
	variables syntax
Message-ID: <20091005212137.GG6071@nowhere>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com> <20091002214842.30906.49220.stgit@dhcp-100-2-132.bos.redhat.com> <20091003015444.GE4828@nowhere> <4AC830F0.2010003@redhat.com> <20091005191829.GA6071@nowhere> <4ACA549F.9010300@redhat.com> <20091005205826.GE6071@nowhere> <4ACA60E9.30404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACA60E9.30404@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 05:11:05PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>> Hmm, the problem is that %1, %2, etc. is not very self-explainable.
>>
>> May be %arg1, %arg2, etc.. But would that sound confusing since we
>> have % for registers?
>
> As I sent right now, how about %argumentN ? it will not conflict with
> register names...
>

There are archs that have %arg0 %arg1, ... as register names?

Well, arg(n) looks shorter but I won't personnally mind if
we eventually chose %argumentN. It's also clear, self-explainable
and it won't collide.

