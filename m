Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYJ2UX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYJ2UX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbYJ2UXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:23:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45661 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbYJ2UXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:23:38 -0400
Date: Wed, 29 Oct 2008 16:23:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Adrian Bunk <bunk@kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/11] ftrace: handle generic arch calls
In-Reply-To: <20081029201646.GA1816@cs181140183.pp.htv.fi>
Message-ID: <alpine.DEB.1.10.0810291622050.18694@gandalf.stny.rr.com>
References: <20081022184313.179487464@goodmis.org> <20081022185135.618026303@goodmis.org> <alpine.DEB.1.10.0810271337370.8006@gandalf.stny.rr.com> <20081029190045.GC22105@uranus.ravnborg.org> <alpine.DEB.1.10.0810291517220.13214@gandalf.stny.rr.com>
 <20081029194956.GA22606@uranus.ravnborg.org> <20081029201646.GA1816@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 29 Oct 2008, Adrian Bunk wrote:
> > > 
> > > Since x86 is the ambiguous case, I made it the one that would be converted 
> > > to i386 or x86_64 since those could be passed in directly.
> > The trick is usually to replace use of ARCH with SRCARCH.
> 
> That won't help - what he wants to know is whether he's on 32bit or
> on 64bit.

I will still get the "bits" parameter. The issue that we are talking about 
here is that I have this ugly if statement that deals with the fact that 
we can get "x86", "x86_64" or "i386" passed in as the ARCH. I'm guessing 
if we switch ARCH to SRCARCH then we can just test against x86 and bits?

-- Steve
