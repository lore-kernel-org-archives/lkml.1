Return-Path: <linux-kernel-owner+w=401wt.eu-S1767130AbXEBSXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767130AbXEBSXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767132AbXEBSXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:23:08 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3629 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767130AbXEBSXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:23:05 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 2 May 2007 11:23:02 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Davi Arnaut <davi@haxent.com.br>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 00/22] pollfs: filesystem abstraction for pollable objects
In-Reply-To: <4638CECE.6060409@haxent.com.br>
Message-ID: <Pine.LNX.4.64.0705021053040.7176@alien.or.mcafeemobile.com>
References: <20070502052235.914764000@haxent.com.br>
 <20070501230529.424f17c6.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705021010390.7176@alien.or.mcafeemobile.com>
 <4638CECE.6060409@haxent.com.br>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Davi Arnaut wrote:

> Davide Libenzi wrote:
> > On Tue, 1 May 2007, Andrew Morton wrote:
> > 
> >   
> > > David, could you provide some feedback please?  The patches are stunningly
> > > free of comments, but you used to do that to me pretty often so my
> > > sympathy
> > > is limited ;)
> > >     
> > 
> > You bastard! :)
> > Ok, from a brief look ...
> > 
> > [general]
> > The code adds an extra indirection over the already existing
> > file_operations, that IMO already sufficently abstract a file.
> > The compat code, if I read it correctly, does not support files crossing
> > 32/64 bits boundaries (exec or SCM_RIGHTS).
> > 
> >   
> 
> The compat code is not already finished, I plan to address compat
> code on the next version.

How? Compat on sys_read/sys_write?



> > [timers]
> > Returns a structure instead of a 32 bit counter (ala timerfd), and needs
> > extra compat code.
> >   
> 
> Yes, but the compat code will be quite small.

Why would that be even justified?



> > [signal]
> > All the discussions that went on for signalfd has been lost. It pins the
> > task struct and it does not handle process detach signaling.
> >   
> 
> No, I just went into a different direction.

I'd say wrong, because signalfd addressed valid concerns of quite a few 
ppl.



- Davide


