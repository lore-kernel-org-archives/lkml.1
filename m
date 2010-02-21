Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab0BUAJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 19:09:00 -0500
Received: from mx.treblig.org ([80.68.94.177]:51317 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab0BUAI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 19:08:59 -0500
Date: Sun, 21 Feb 2010 00:02:29 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Extended error reporting to user space?
Message-ID: <20100221000229.GA8092@gallifrey>
References: <201002161520.26700@zigzag.lvk.cs.msu.su> <87r5ok5gl2.fsf@basil.nowhere.org> <201002171316.49165@zigzag.lvk.cs.msu.su> <20100217103504.GO21783@one.firstfloor.org> <20100217192058.GA8937@gallifrey> <20100217202312.GQ21783@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217202312.GQ21783@one.firstfloor.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.31.5-kvm-i386-2009-10-30 (i686)
X-Uptime: 23:57:53 up 97 days,  7:07,  1 user,  load average: 0.07, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > I'd wondered about some form of halfway house where the error
> > value is expanded but could be truncated for compatibility - i.e.
> 
> Who would do the truncation?

I'd assumed something like the code in entry*.S or equivalent for
existing syscalls, but have another entry that would pass it through
to a newer libc that new how to handle it.

> > if at the moment we had:
> > 
> >     return -EINVAL;
> > 
> > it would become:
> > 
> >     return ERRORNUM(EINVAL, BADLENGTH);
> 
> x86 only has about 12 bits in the current ABI btw.

Ah yes I can see that now, hmm.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
