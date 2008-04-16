Return-Path: <linux-kernel-owner+w=401wt.eu-S1764671AbYDPO7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764671AbYDPO7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbYDPO7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:59:43 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:57331 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756320AbYDPO7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:59:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EABSxBUhMROPA/2dsb2JhbACBYK0x
Date: Wed, 16 Apr 2008 10:54:40 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [TEST PATCH] Test NMI kprobe modules
Message-ID: <20080416145440.GB15554@Krystal>
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416134735.GA13399@Krystal> <20080416143408.GG24383@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080416143408.GG24383@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:52:07 up 47 days, 11:03,  4 users,  load average: 0.42, 0.39,
	0.35
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> 
> > +long debug_eip, debug_cs, debug_eflags, debug_extra, debug_extra2, debug_extra3, debug_extra4;
> > +long debugo_eip, debugo_cs, debugo_eflags, debugo_extra, debugo_extra2, debugo_extra3, debugo_extra4;
> > +EXPORT_SYMBOL(debug_eip);
> > +EXPORT_SYMBOL(debug_cs);
> > +EXPORT_SYMBOL(debug_eflags);
> > +EXPORT_SYMBOL(debug_extra);
> > +EXPORT_SYMBOL(debug_extra2);
> > +EXPORT_SYMBOL(debug_extra3);
> > +EXPORT_SYMBOL(debug_extra4);
> > +EXPORT_SYMBOL(debugo_eip);
> > +EXPORT_SYMBOL(debugo_cs);
> > +EXPORT_SYMBOL(debugo_eflags);
> > +EXPORT_SYMBOL(debugo_extra);
> > +EXPORT_SYMBOL(debugo_extra2);
> > +EXPORT_SYMBOL(debugo_extra3);
> > +EXPORT_SYMBOL(debugo_extra4);
> 
> ok, while this is a test patch of yours, lets make one thing sure: all 
> things hook-alike instrumentation _MUST_ and will stay stay GPL 
> exported. It's all very internal, and there will be no automatic, 
> programmable interface stability guarantees for any of the markers that 
> kabi crap could come and shackle the kernel with ... (it will all be 
> stable to SystemTap of course - but SystemTap is a kernel-internal 
> entity in that regard)
> 
> 	Ingo
> 

Yes, I agree. This patch is just an ugly test-hack. :)

I already designed my LTTng tracer so it follows changes to the internal
kernel structures as easily as possible, but yes, it is kernel internal
too.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
