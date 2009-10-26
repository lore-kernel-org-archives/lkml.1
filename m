Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbZJZOSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbZJZOSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 10:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZJZOR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 10:17:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:60646 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZJZOR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 10:17:58 -0400
Date: Mon, 26 Oct 2009 07:18:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
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
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL
 v2,headers to Dual BSD/GPL
Message-ID: <20091026071832.36405c9a@infradead.org>
In-Reply-To: <4AE5A17D.5020202@polymtl.ca>
References: <20091023160257.GA30447@Krystal>
	<20091023160632.GA2198@Krystal>
	<alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net>
	<20091026015357.GA6033@localhost>
	<023001ca55e1$436e38e0$808410ac@zhaoleiwin>
	<49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com>
	<20091026073048.GC8162@elte.hu>
	<4AE5A17D.5020202@polymtl.ca>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 09:17:49 -0400
Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca> wrote:

> Ingo Molnar wrote:
> > 
> > But i also disagree with it on a technical level: code duplication
> > is _bad_. Why does the code have to be duplicated in user-space
> > like that? I'd like Linux tracing code to be in the kernel repo.
> > Why isnt this done properly, as part of the kernel project - to
> > make sure it all stays in sync?
> > 
> 
> If you mean that this code should solely be used inside the kernel,
> then what you propose technically does not work. There is a very high
> cost to accessing kernel code from userspace. 

yeah 100 cycles is insanely high, that's at least the equivalent of...
say one cache miss.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
