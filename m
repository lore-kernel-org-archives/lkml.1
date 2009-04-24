Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbZDXMa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbZDXMa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZDXMaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:30:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbZDXMaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:30:18 -0400
Date: Fri, 24 Apr 2009 08:30:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/6] tracing: increase size of number of possible
 events
In-Reply-To: <20090424071224.GD24912@elte.hu>
Message-ID: <alpine.DEB.2.00.0904240829300.24293@gandalf.stny.rr.com>
References: <20090424043005.338878133@goodmis.org> <20090424043111.983189535@goodmis.org> <20090424071224.GD24912@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > With the new event tracing registration, we must increase the number
> > of events that can be registered. Currently the type field is only
> > one byte, which leaves us only 256 possible events.
> > 
> > Since we do not save the CPU number in the tracer anymore (it is determined
> > by the per cpu ring buffer that is used) we have an extra byte to use.
> > 
> > This patch increases the size of type from 1 byte (256 events) to
> > 2 bytes (65,536 events).
> > 
> > It also adds a WARN_ON_ONCE if we exceed that limit.
> > 
> > [ Impact: allow more than 255 events ]
> 
> > -	int			type;
> > +	unsigned short		type;
> 
> Hm, the changelog is not valid anymore - as here we really cut it 
> down from 4 billion to 64K, right?

[ Impact: wrong changelog due to forward port of patch ]

;-)

-- Steve

