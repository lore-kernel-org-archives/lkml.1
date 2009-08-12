Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbZHLVhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbZHLVhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZHLVhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:37:12 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:40677 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZHLVhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NVOfmWACCL7bX3HXYkE0k8duux3zKdbA15UoPi5G8ygGd/zUI1b86eur9XszEttAXa
         R3DPOkQ1gmT6e+aYqpSyVSaDOTaUhVFsXRgqpRniHJEvavspjcWmUJ5VMWe/cSDgm0ds
         tq+A0q/4o9iE8CvtQAxDPWDKQNFghp+R6GJPU=
Date: Wed, 12 Aug 2009 23:37:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [RFD] Kprobes/Kretprobes perf support
Message-ID: <20090812213707.GD5974@nowhere>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <4A82EEC5.8000603@redhat.com> <4A82F5A0.2090603@redhat.com> <20090812191305.GB5974@nowhere> <1250111397.7035.1.camel@laptop> <4A8333B4.7020301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8333B4.7020301@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 05:27:16PM -0400, Masami Hiramatsu wrote:
> Peter Zijlstra wrote:
> > On Wed, 2009-08-12 at 21:13 +0200, Frederic Weisbecker wrote:
> > 
> >> Ingo, Peter do you have an idea on how we could do that?
> > 
> > Wouldn't it be easiest to use ftrace to create dynamic tracepoints in
> > the ftrace way such that they become available in
> > debugfs://tracing/events/kprobes/*/ and then have them interfaced the
> > same way as all other tracepoints?
> 
> Yes, almost same. One big difference is that they are sharing
> same event-id(TRACE_KPROBE and TRACE_KRETPROBE).
> But I can make each kprobe events to have different ids, if you need.
> 
> Thank you,

Yeah that would be better. That's also what Jason did with the syscall events.

