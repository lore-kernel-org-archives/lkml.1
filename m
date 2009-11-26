Return-Path: <linux-kernel-owner+w=401wt.eu-S1752502AbZKZTq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbZKZTq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 14:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZKZTq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 14:46:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65308 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZKZTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 14:46:56 -0500
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
 DECLARE_EVENT_CLASS()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <1259264667.21397.131.camel@gandalf.stny.rr.com>
References: <4B0E286A.2000405@cn.fujitsu.com>
	 <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
	 <1259224390.21397.87.camel@gandalf.stny.rr.com>
	 <20091126084039.GA15919@elte.hu>
	 <1259246730.21397.97.camel@gandalf.stny.rr.com>
	 <20091126175548.GC4997@nowhere> <20091126181205.GA18670@elte.hu>
	 <1259262740.21397.121.camel@gandalf.stny.rr.com>
	 <20091126192019.GA11245@elte.hu>
	 <1259264667.21397.131.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 26 Nov 2009 14:47:01 -0500
Message-Id: <1259264821.21397.133.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 14:44 -0500, Steven Rostedt wrote:

> Come to think of it, since current TRACE_EVENT is now just:
> 
> #define TRACE_EVENT() \
> 	TRACE_EVENT_TEMPLATE() \
> 	DEFINE_EVENT
> 
> This may make the most sense. I haven't tried it, but I believe that you
> could even base other events off of the TRACE_EVENT. That is:
> 
> TRACE_EVENT(x, ...);
> 
> DEFINE_EVENT(x, y, ...);
> 
> And y would use x as its class.
> 
> So going back to your scheme of DECLARE_EVENT_CLASS(), it may make sense
> to have DECLARE_AND_DEFINE_EVENT().
> 
> 
> DECLARE_EVENT_CLASS(class, ...);
> DEFINE_EVENT(class, foo, ...);
> 
> DECLARE_AND_DEFINE_EVENT(bar, ...);

Perhaps being the most descriptive to what it does:

	DECLARE_CLASS_AND_DEFINE_EVENT() ?

-- Steve

> 
> DEFINE_EVENT(bar, zoo, ...);
> 


