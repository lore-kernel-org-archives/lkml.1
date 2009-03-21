Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbZCUQnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbZCUQnk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZCUQnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:43:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZCUQnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:43:31 -0400
Date: Sat, 21 Mar 2009 12:43:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: Fix TRACING_SUPPORT dependency
In-Reply-To: <alpine.DEB.2.00.0903211239170.13615@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903211242530.13615@gandalf.stny.rr.com>
References: <20090320150914.GA22769@oksana.dev.rtsoft.ru> <20090320190428.GD6224@elte.hu> <20090320193904.GA13707@oksana.dev.rtsoft.ru> <20090320195743.GA25147@elte.hu> <20090320202247.GA30654@oksana.dev.rtsoft.ru> <20090321161814.GC11183@elte.hu>
 <alpine.DEB.2.00.0903211230580.13615@gandalf.stny.rr.com> <20090321163328.GH11183@elte.hu> <alpine.DEB.2.00.0903211239170.13615@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 21 Mar 2009, Steven Rostedt wrote:
> 
> Since we know that's not an issue with PPC32, perhaps we should add (I 
> hate to do this)...
> 
> 
> 	depends on TRACE_IRQFLAGS_SUPPORT || PPC32
> 
> And document that the "|| PPC32" should go when PowerPC32 gets its act
> together.  :-/

Note, the only tracer broken on PPC32 is the IRQSOFF tracer, and that 
already depends on TRACE_IRQFLAGS_SUPPORT.

-- Steve

