Return-Path: <linux-kernel-owner+w=401wt.eu-S935124AbXGYSbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935124AbXGYSbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933803AbXGYSaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:30:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3020 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762095AbXGYSaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:30:13 -0400
Date: Wed, 25 Jul 2007 14:02:50 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Ken Moffat <zarniwhoop@ntlworld.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] what should 'uptime' be on suspend?
Message-ID: <20070725140250.GD9256@ucw.cz>
References: <46A0210E.6010207@tmr.com> <20070720171729.GA19935@deepthought> <20070720104215.476f4cc1.randy.dunlap@oracle.com> <20070720175730.GB21550@deepthought> <46A2101D.5020400@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A2101D.5020400@tmr.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-07-21 09:54:37, Bill Davidsen wrote:
> Ken Moffat wrote:
> >On Fri, Jul 20, 2007 at 10:42:15AM -0700, Randy Dunlap 
> >wrote:
> >  
> >>man uptime:
> >>	uptime - tell how long the system has been running
> >>
> >>I claim that the system is not running when it is 
> >>suspended,
> >>so the suspension time should not be included in 
> >>uptime.
> >>
> >>    
> > So, maybe I shouldn't have put corrected in inverted 
> > commas,
> >because this was a real correction and my previous 
> >usage was an
> >unintended side-effect of an error.
> >
> > Anyway, the current behaviour is known and I guess any 
> > attempt to
> >change it (e.g. to what Bill was expecting) won't be 
> >well received.
> >  
> 
> So is setting it to a random number considered correct 
> behavior? Any of the first three values I mentioned 
> would make sense, but the value I see is neither time 
> since resume, time since power-on to do the resume, or 
> any of the logical uptime values. That was the whole 
> point of the original post, the uptime reported makes no 
> sense at all.

Ouch, seems like something is wrong with timer subsystem. Can you
verify that rest of the clock machinery behaves ok?

We do manual correction of uptime during resume (IIRC) - perhaps
something goes wrong there?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
