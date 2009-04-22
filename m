Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZDVRWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZDVRWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZDVRWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:22:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50326 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZDVRWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:22:37 -0400
Date: Wed, 22 Apr 2009 13:22:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
In-Reply-To: <49EF5138.3030408@goop.org>
Message-ID: <alpine.DEB.2.00.0904221321410.24310@gandalf.stny.rr.com>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <20090422114750.GA14202@nowhere> <alpine.DEB.2.00.0904220943280.24310@gandalf.stny.rr.com>
 <20090422171047.GA5975@nowhere> <49EF5138.3030408@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Apr 2009, Jeremy Fitzhardinge wrote:

> > 
> >    
> > > Do you have CONFIG_PARAVIRT on?  When I disabled it, I have yet to
> > > reproduce the bug. But I've only rebooted a few times. I'm going to
> > > continue to reboot to see if I can trigger it.
> > >     
> > 
> > 
> > Yes it is enabled.
> > 
> > 
> > 
> >   
> > > I'm thinking that the paravirt alternative code may have clobbered a
> > > register in either the enable or disabling of interrupts. This might cause
> > > a strange value to go into the hardirqs_enabled flag.
> > >     
> > 
> > 
> > 
> > Ok I will try it without PARAVIRT and tell you if I can reproduce it.
> >   
> 
> Interesting.  What code is generated for native_irq_enable/disable?

Note, when I take my standard config and enable PARAVIRT and LOCKDEP it 
still boots up fine. It may be a combination of some configs :-/

I'm currently doing a "config bisect" to find out what configs are needed.

-- Steve

