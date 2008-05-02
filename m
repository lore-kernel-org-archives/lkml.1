Return-Path: <linux-kernel-owner+w=401wt.eu-S1761215AbYEBIaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761215AbYEBIaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYEBIa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:30:29 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48609 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYEBIa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:30:27 -0400
Date: Fri, 2 May 2008 11:29:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Josh Boyer <jwboyer@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-ID: <20080502082936.GB2003@cs181133002.pp.htv.fi>
References: <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org> <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org> <20080501132159.GC29330@cs181133002.pp.htv.fi> <18458.30641.838156.434563@cargo.ozlabs.ibm.com> <1209697815.2946.156.camel@vader.jdub.homelinux.org> <18458.37891.268060.691285@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <18458.37891.268060.691285@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 02:09:39PM +1000, Paul Mackerras wrote:
> Josh Boyer writes:
> 
> > On Fri, 2008-05-02 at 12:08 +1000, Paul Mackerras wrote:
> > > Adrian Bunk writes:
> > > 
> > > > "Kernel oops while running kernbench and tbench on powerpc" took more 
> > > > than 2 months to get resolved, and we ship 2.6.25 with this regression.
> > > 
> > > That was a very subtle bug that only showed up on one particular
> > > powerpc machine.  I was not able to replicate it on any of the powerpc
> > > machines I have here.  Nevertheless, we found it and we have a fix for
> > > it.  I think that's an example of the process working. :)
> > 
> > Was it even a regression in the classical sense of the word?  Seemed
> > more of a latent bug that was simply never triggered before.
> 
> That's right.  The bug has been there basically forever (i.e. since
> before 2.6.12-rc2 ;) and no-one has been able to trigger it reliably
> before.

But for users this is a recent regression since 2.6.24 worked
and 2.6.25 does not.

If this problem was on x86 Linus himself and some other core developers 
would most likely have debugged this issue and Linus would have delayed 
the release of 2.6.25 for getting it fixed there.

And stuff that "only showed up on one particular machine" often shows up 
on many machines (we only know in hindsight) and the "one particular 
machine" is often due to the fact that of the many machines that might 
trigger a regression only one was used for testing this -rc kernel.

This not in any way meant against you personally, and due to the fact 
that the powerpc port is among the better maintained parts of the kernel 
this regression eventually got fixed, but in many other parts of the 
kernel this would have been one more of the many regressions that were 
reported and never fixed.

> Paul.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

