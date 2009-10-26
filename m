Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZJZN3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZJZN3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbZJZN3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:29:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58391 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbZJZN3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:29:51 -0400
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL
 v2,headers to Dual BSD/GPL
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, GeunSik Lim <leemgs1@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Jesper Juhl <jj@chaosbits.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>
In-Reply-To: <4AE5A17D.5020202@polymtl.ca>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal>
	 <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
	 <20091026015357.GA6033@localhost>
	 <023001ca55e1$436e38e0$808410ac@zhaoleiwin>
	 <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com>
	 <20091026073048.GC8162@elte.hu>  <4AE5A17D.5020202@polymtl.ca>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 09:29:52 -0400
Message-Id: <1256563793.26028.240.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 09:17 -0400, Pierre-Marc Fournier wrote:
> Ingo Molnar wrote:
> > 
> > But i also disagree with it on a technical level: code duplication is 
> > _bad_. Why does the code have to be duplicated in user-space like that? 
> > I'd like Linux tracing code to be in the kernel repo. Why isnt this done 
> > properly, as part of the kernel project - to make sure it all stays in 
> > sync?
> > 
> 
> If you mean that this code should solely be used inside the kernel, then
> what you propose technically does not work. There is a very high cost to
> accessing kernel code from userspace. This cost is simply unacceptable
> for the kind of userspace tracing that is needed today.

I think that Ingo is thinking that the tracing is for the kernel, and is
asking why the duplication needs to be done for tools tracing the
kernel.

But what I think is trying to be done here is to use the same types of
MACROS that we have in the kernel to do tracing in userspace. That a
userspace program can add their own "TRACE_EVENT" and that the headers
there will create a tracepoint for them the same way we currently do in
the kernel.

Am I correct in my analysis?

-- Steve


