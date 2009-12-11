Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbZLKOhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbZLKOhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbZLKOhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:37:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50649 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbZLKOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:37:31 -0500
X-Authority-Analysis: v=1.0 c=1 a=7U3hwN5JcxgA:10 a=WtMCi8wR5WqSJ5HAtMgA:9 a=nvlmOd-MUDLKgD51MgJxWuZAQeYA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: dynamic ftrace - graph
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: monstr@monstr.eu
Cc: wuzhangjin@gmail.com, linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
In-Reply-To: <4B21F4F6.5080600@monstr.eu>
References: <4AF848C0.7010807@monstr.eu>
	 <1260506225.2146.347.camel@gandalf.stny.rr.com>
	 <4B21F4F6.5080600@monstr.eu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 11 Dec 2009 09:37:35 -0500
Message-ID: <1260542255.2146.350.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 08:29 +0100, Michal Simek wrote:
> Steven Rostedt wrote:
> > Hi Michal,
> > 
> > Sorry for such a late reply, you sent this email to me at the worst
> > time. My wife was having shoulder surgery and I heading for a
> > conference. I fell very far behind in email and I only now just noticed
> > this.
> 
> No problem. I prepared Microblaze ftrace patches. You can find them in 
> linux-next. I am going to send pull request to Linus soon that's why if 
> you have any your comments please let me know.
> 

Hey, if they work and they are only in your arch, then I'm fine with
them ;-)

> > 
> > 
> > I'll answer these ever though you may already figured it out.
> > 
> > On Mon, 2009-11-09 at 17:52 +0100, Michal Simek wrote:
> >> Hi Steve and others,
> >>
> >> I have working dynamic ftrace function. :-)
> >>
> >> I look at __ftrace_modify_code function and I have one question about.
> >> Below are function which are called when I enable function_graph.
> >>
> >> I personally think that make more sense to call 
> >> ftrace_enable_ftrace_graph_caller before ftrace_update_ftrace_func.
> >> The reason for it is that graph_caller enable calling graph tracing 
> >> which should be setup before ftrace_update_ftrace_func which enable 
> >> whole tracing function.
> > 
> > Have you seen any difference in output with this?
> 
> I haven't tested it. It was just suggestion. I don't know if is relevant 
> or not.

I'm not sure it is relevant. Those are enabled in stop_machine so the
only thing you would be missing is the tracer enabling itself.

-- Steve


