Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0CDVan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:30:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59601 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab0CDVal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:30:41 -0500
X-Authority-Analysis: v=1.0 c=1 a=JmiDjSKT-SYA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=tK20XPZL8-7P23MAwC0A:9 a=xoeaE6sM9RG6h97i_WXa8B3qr3kA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
 events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Greg KH <greg@kroah.com>
In-Reply-To: <20100304211741.GB3643@elte.hu>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
	 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
	 <1267632387.10871.59.camel@gandalf.stny.rr.com>
	 <1267634258.25158.88.camel@laptop>
	 <1267636046.10871.74.camel@gandalf.stny.rr.com>
	 <1267636595.25158.93.camel@laptop> <20100304112531.GF21977@elte.hu>
	 <1267715801.10871.191.camel@gandalf.stny.rr.com>
	 <20100304153606.GA32496@elte.hu>
	 <1267718131.10871.240.camel@gandalf.stny.rr.com>
	 <20100304211741.GB3643@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 04 Mar 2010 16:30:38 -0500
Message-ID: <1267738238.10871.582.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 22:17 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 

> No, we want to decouple it from 'tracing'. It's events, not tracing. Events 
> are more broader, they can be used for RAS, profiling, counting, etc. - not 
> just tracing.
> 
> Furthermore, we only want /debug/tracing/events really, not the various 
> dynamic ftrace controls - those could remain in /debug/tracing/.

I was talking about the files in the events directory:

events/sched/sched_switch/{id,format,enable,filter}


Seems only the format file should go in, and perhaps the id.

I can keep the debug/tracing/events/* as is too, where the format and id
just call the same routines that the eventfs calls, but add the enable
and filter to be specific to ftrace.

-- Steve


