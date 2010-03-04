Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0CDWCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 17:02:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58388 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247Ab0CDWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 17:02:50 -0500
X-Authority-Analysis: v=1.0 c=1 a=JmiDjSKT-SYA:10 a=7U3hwN5JcxgA:10 a=6M4o5OfCScs0ekI8mnAA:9 a=P3gq2e3muj9qdlMgAxOB8Mnrk1YA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
 events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Greg KH <greg@kroah.com>
In-Reply-To: <20100304213725.GA8169@nowhere>
References: <1267632387.10871.59.camel@gandalf.stny.rr.com>
	 <1267634258.25158.88.camel@laptop>
	 <1267636046.10871.74.camel@gandalf.stny.rr.com>
	 <1267636595.25158.93.camel@laptop> <20100304112531.GF21977@elte.hu>
	 <1267715801.10871.191.camel@gandalf.stny.rr.com>
	 <20100304153606.GA32496@elte.hu>
	 <1267718131.10871.240.camel@gandalf.stny.rr.com>
	 <20100304211741.GB3643@elte.hu>
	 <1267738238.10871.582.camel@gandalf.stny.rr.com>
	 <20100304213725.GA8169@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 04 Mar 2010 17:02:48 -0500
Message-ID: <1267740168.10871.617.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 22:37 +0100, Frederic Weisbecker wrote:

> > I can keep the debug/tracing/events/* as is too, where the format and id
> > just call the same routines that the eventfs calls, but add the enable
> > and filter to be specific to ftrace.
> 
> 
> The /debug/tracing/events could contain symlinks for the format
> files so that the rest can stay there.

Symlinks buy us nothing but headaches. This is a pseudo filesystem, we
can use the same code that generates the file with no extra overhead.

-- Steve
 


