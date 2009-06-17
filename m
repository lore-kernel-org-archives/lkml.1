Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbZFQUJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbZFQUJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbZFQUJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:09:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154AbZFQUJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:09:41 -0400
Date: Wed, 17 Jun 2009 13:09:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-afs@lists.infradead.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
In-Reply-To: <29249.1245268301@redhat.com>
Message-ID: <alpine.LFD.2.01.0906171303390.16802@localhost.localdomain>
References: <alpine.LFD.2.01.0906171112530.16802@localhost.localdomain> <alpine.LFD.2.01.0906171027470.16802@localhost.localdomain> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617001157.065ee652@lxorguk.ukuu.org.uk>
 <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <28023.1245259479@redhat.com> <28259.1245261823@redhat.com>  <29249.1245268301@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, David Howells wrote:
> 
> > But if you do that new system call, then what's the point again? You're 
> > back to pinfo() anyway.
> 
> Ummm...  pinfo()?  Did you mean pioctl()?

Yes.

> > No. It's because it's another _typeless_ multiplexor.
> 
> What do you mean by 'typeless'?  Even the master syscall mux is typeless,
> depending on how you look at it; either that, or it's the superposition of a
> multiplicity of types selected by an arbitrary number.

No, it's not typeless, and you're just an ugly troll.

The master syscall mutex is VERY WELL DEFINED, and doesn't change randomly 
depending on what file you happen to look at. It's also somethign where 
people actually spend time and effort before adding new entries, instead 
of the incessant cluster-fuck that is always the random ioctl, where 
subsystems add a new entry at the drop of a hat.

> Short of doing something like an XML or ASN1 structured interface, we aren't
> going to get that, and do we really want to go down that path?
> 
> The difference between the syscall mux and a filesystem's ioctl/pioctl mux is
> that the both need to check on their arguments.

What kind of idiotic "arguments" are these. Neither of them is in the 
least true, relevant, or anything sane at all.

Why should I bother reading any further, when you show that your emails 
are full of pointless crap?

> >  - learn from your mistake, and not do another f*cking disaster that just 
> >    takes a pathname instead of a fd. Do something else, that actually has 
> >    semantics and has a well-defined input and output buffer.
> 
> That sounds like you want all the pioctl functions promoted to syscalls.

No.

It means that I want more structure. Stop making these things up.

More structure to make _guarantees_ that you will never need a compat 
layer, for example. More structure so that people can _figure out_ what 
the supported set of interfaces are, since they are going to differ for 
different files. More structure so that we can see security issues without 
having to know every f*cking new entry in that table. Etc etc etc.

> > And guess which one "pioctl()" is. Just take a wild stab at it.
> 
> Well, I'd say it's more intelligent that open+ioctl...

Why?

So far, you're just spouting total nonsense.

			Linus
