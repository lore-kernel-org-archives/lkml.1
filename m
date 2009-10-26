Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZJZNTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZJZNTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbZJZNTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:19:20 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47805 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbZJZNTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:19:19 -0400
Message-ID: <4AE5A17D.5020202@polymtl.ca>
Date: Mon, 26 Oct 2009 09:17:49 -0400
From: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: GeunSik Lim <leemgs1@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Jesper Juhl <jj@chaosbits.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Adrian Bunk <bunk@stusta.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL	v2,headers
 to Dual BSD/GPL
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal> <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net> <20091026015357.GA6033@localhost> <023001ca55e1$436e38e0$808410ac@zhaoleiwin> <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com> <20091026073048.GC8162@elte.hu>
In-Reply-To: <20091026073048.GC8162@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Poly-FromMTA: (modemcable245.214-56-74.mc.videotron.ca [74.56.214.245]) at Mon, 26 Oct 2009 13:17:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> But i also disagree with it on a technical level: code duplication is 
> _bad_. Why does the code have to be duplicated in user-space like that? 
> I'd like Linux tracing code to be in the kernel repo. Why isnt this done 
> properly, as part of the kernel project - to make sure it all stays in 
> sync?
> 

If you mean that this code should solely be used inside the kernel, then
what you propose technically does not work. There is a very high cost to
accessing kernel code from userspace. This cost is simply unacceptable
for the kind of userspace tracing that is needed today.

OTOH, if you mean that the code should reside in the kernel repository,
as GPL, and should be included inside userspace applications from there,
then you don't have this problem. But you create an even worse problem,
which is that only GPL applications can be distributed with support for
tracing compiled in. Again, this won't do for the needs of the industry.

So the GPL code will have to be rewritten. And this will result in the
exact same drawbacks you are trying to avoid by being against
dual-licensing. The goal of dual-licensing is to make it possible to
keep the code in sync between kernel and userspace, not the opposite!

pmf
