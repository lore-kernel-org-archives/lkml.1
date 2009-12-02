Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZLBQ5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZLBQ5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 11:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754611AbZLBQ5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 11:57:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754010AbZLBQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 11:57:41 -0500
Date: Wed, 2 Dec 2009 08:56:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Beulich <JBeulich@novell.com>
cc: a.p.zijlstra@chello.nl, mingo@elte.hu, tglx@linutronix.de,
       mingo@redhat.com, npiggin@suse.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten 
 __ticket_spin_trylock()
In-Reply-To: <4B16A2CC020000780002313A@vpn.id2.novell.com>
Message-ID: <alpine.LFD.2.00.0912020853240.2872@localhost.localdomain>
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com> <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org> <alpine.LFD.2.00.0912020714420.2872@localhost.localdomain> <4B16A2CC020000780002313A@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Dec 2009, Jan Beulich wrote:
> 
> This just can't be the case: In order for two compilers to be
> interoperable, the processor specific ABI has to define the handling of
> bool, just like it has to for any other data type.

You are full of crap.

The fact is, compilers are _not_ interoperable in general, and ABI's are 
often compiler-specific. Look at MSVC vs gcc on x86 for just a really 
obvious and trivial example. The fact is, on x86-unix we simply don't 
have any real ABI at all, and gcc picks whatever randon choices it has. 

So stop making excuses. Just admit that 'bool' was wrong, and you made a 
fundamental mistake in choosing it. The fact is, the compiler can do 
whatever the hell it does, which is not necessarily sensible with any 
other type. 'bool' really is special.

			Linus
