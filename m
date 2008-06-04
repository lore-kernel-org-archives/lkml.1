Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbYFDSXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbYFDSXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbYFDSXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:23:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45115 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbYFDSXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:23:39 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5310"; a="3504817"
Message-ID: <4846DDC1.1050203@qualcomm.com>
Date: Wed, 04 Jun 2008 11:24:01 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       rostedt@goodmis.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com
Subject: Re: Stop machine threads are getting preemted by the rt period	enforcement
References: <20080601213019.14ea8ef8.pj@sgi.com>	 <20080602164203.GA2477@sgi.com> <48443E66.6060205@qualcomm.com>	 <20080602214151.GA7072@sgi.com> <48446D46.2010903@qualcomm.com>	 <20080603144010.GA25948@sgi.com> <20080604140036.GC18993@sgi.com>	 <4846D9FE.4030804@qualcomm.com> <1212603506.19205.2.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1212603506.19205.2.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Wed, 2008-06-04 at 11:07 -0700, Max Krasnyansky wrote:
>> Peter, Ingo,
>>
>> Take a look at the report below (came up during isolcpu= remove discussions).
>>
>> It looks like stop_machine threads are getting forcefully preempted because
>> they exceed their RT quanta. It's strange because rt period is pretty long.
>> But given that disabling rt period logic solves the issue the machine was not
>> really stuck.
> 
> Yeah, I know, I'm already looking at this

I see. Does it look like a bug in the rt period logic ?
Or did the stop_machine thread really run for a long time (in the report that
you got that is) ?

Max
