Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbXCPKM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbXCPKM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbXCPKM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:12:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48468 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753153AbXCPKM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:12:57 -0400
Date: Fri, 16 Mar 2007 11:12:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Zachary Amsden <zach@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: hardwired VMI crap
Message-ID: <20070316101239.GB1821@elf.ucw.cz>
References: <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu> <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com> <20070308211306.GA20934@elte.hu> <45F08B71.50606@vmware.com> <20070308223317.GC30113@elte.hu> <45F09093.6070302@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F09093.6070302@vmware.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-03-08 14:39:15, Zachary Amsden wrote:
> Ingo Molnar wrote:
> >* Zachary Amsden <zach@vmware.com> wrote:
> >
> >  
> >>Ingo, either you or Thomas have vetoed every attempt we have made to 
> >>make our code operate with clockevents. [...]
> >>    
> >
> >this is news to me - do you have any proof of such a veto?
> >  
> 
> Yes, your refusal to discuss any technical details when asked point 
> blank which solution you prefer, and your continued whining and 
> threatening to unmerge our code.

Failing to answer a question is hardly a veto.

> And I ask again for your feedback on which approach you think is correct:

> 1) Rewrite the interrupt subsystem of our hypervisor, making it 
> incompatible with full virtualization, so that we can support an 
> abstract interrupt controller with a "clean" interface
> 2) Reuse the same method that HPET, PIT and other time clients in i386 
> use - the global_clock_event pointer which allows you to wrest control 
> back from the APIC and reuse the lapic_events local clockevents.
...

Do all of them then decide which code is nicest. I mean... this looks
like trap question for Ingo. He tells you 2, you'll do crappy
implementation of 2, and then claim Ingo can't object.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
