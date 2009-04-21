Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbZDUSdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbZDUSdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 14:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZDUSd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 14:33:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:61898 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbZDUSd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 14:33:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wt6/tf0uZTocra7/Jm5n9IaKq7s46zz6jdGoLYLpEDPlpHE/o6j3OBq3WqHyE3j+B3
         IE5qbrgYkovij22S15MK6TEhHle5vqLfKe3EwfllNhxy4BUdz9jVMNY2I+qJ/+smrj9p
         BgPUKIJ22BEQYVQOUMiXR3NEavFM46iW9bCR0=
Date: Tue, 21 Apr 2009 20:33:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make
	workqueuetracepoints use TRACE_EVENT macro
Message-ID: <20090421183322.GC6001@nowhere>
References: <20090420103612.4B4E.A69D9226@jp.fujitsu.com> <47EF9F5C609F496FBBD423EA81A00920@zhaoleiwin> <20090420104734.4B51.A69D9226@jp.fujitsu.com> <20090420084631.GA32625@elte.hu> <20090420222514.GA15680@redhat.com> <20090420234835.GC5997@nowhere> <20090421152843.GA5402@redhat.com> <20090421155032.GB5402@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421155032.GB5402@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 05:50:32PM +0200, Oleg Nesterov wrote:
> On 04/21, Oleg Nesterov wrote:
> >
> > On 04/21, Frederic Weisbecker wrote:
> > >
> > > For example,
> > >
> > > - the user opens the stat file
> > > - then the entries are loaded and sorted into memory
> > > - one of the workqueues is destroyed
> 
> Hmm. And what protects cws when, say, workqueue_stat_show() is called?
> Can't we race with probe_workqueue_destruction()->kfree() ?
> 
> Oleg.
>


Indeed. I plan to implement a waitqueue on the stat tracing framework
to fix it (per tracer of course).

Thanks. 

