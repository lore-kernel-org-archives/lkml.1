Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYJ2UdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYJ2UdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYJ2Ucw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:32:52 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41660 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbYJ2Ucv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:32:51 -0400
Date: Wed, 29 Oct 2008 22:31:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/11] ftrace: handle generic arch calls
Message-ID: <20081029203133.GC1816@cs181140183.pp.htv.fi>
References: <20081022184313.179487464@goodmis.org> <20081022185135.618026303@goodmis.org> <alpine.DEB.1.10.0810271337370.8006@gandalf.stny.rr.com> <20081029190045.GC22105@uranus.ravnborg.org> <alpine.DEB.1.10.0810291517220.13214@gandalf.stny.rr.com> <20081029194956.GA22606@uranus.ravnborg.org> <20081029201646.GA1816@cs181140183.pp.htv.fi> <alpine.DEB.1.10.0810291622050.18694@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810291622050.18694@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2008 at 04:23:34PM -0400, Steven Rostedt wrote:
> 
> On Wed, 29 Oct 2008, Adrian Bunk wrote:
> > > > 
> > > > Since x86 is the ambiguous case, I made it the one that would be converted 
> > > > to i386 or x86_64 since those could be passed in directly.
> > > The trick is usually to replace use of ARCH with SRCARCH.
> > 
> > That won't help - what he wants to know is whether he's on 32bit or
> > on 64bit.
> 
> I will still get the "bits" parameter.

Ah, I didn't get this bit from your email.

> The issue that we are talking about 
> here is that I have this ugly if statement that deals with the fact that 
> we can get "x86", "x86_64" or "i386" passed in as the ARCH. I'm guessing 
> if we switch ARCH to SRCARCH then we can just test against x86 and bits?

Yes.

And as a bonus you will automatically get the correct output when you'll 
add support for UML.

> -- Steve

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

