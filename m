Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbYHXTXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbYHXTXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 15:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbYHXTXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 15:23:31 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:57286 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbYHXTXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 15:23:30 -0400
Message-ID: <48B1B526.2030100@dgreaves.com>
Date: Sun, 24 Aug 2008 20:23:18 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241030060.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808241030060.3363@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11405
>> Subject		: 2.6.27-rc3 segfault on cold boot; not on warm boot.
>> Submitter	: David Greaves <david@dgreaves.com>
>> Date		: 2008-08-21 9:45 (3 days old)
>> References	: http://marc.info/?l=linux-kernel&m=121931198904777&w=4
> 
> It would be good to have some kind of bisection of this one, because it 
> looks pretty odd. Also, google doesn't find anybody else seeing that 
> "segfault at ffffffbf", even though it seems to be very consistent for 
> David. So I don't think we'll be able to even _guess_ where it is without 
> some more information about exactly when it started happening.
> 
> Since it's present in 2.6.26 too, it's clearly not a regression from that 
> one, but perhaps more importantly, since it's apparently an old one I'd 
> have expected more reports like this if it was some common problem. And 
> the warm-vs-cold-boot thing makes me think it's some hardware setup issue.
> 
> Possibly the disk controller, possibly the CPU (eg some MTRR/PAT 
> setup issue or TLB thing). But the dmesg's are all from late enough at 
> boot that I can't even tell what disk controller it is (except that it is 
> SATA), nor can I tell what CPU it is.
> 
> But again, if it was some MTRR/PAT issue, I'd expect a _lot_ more reports 
> of this. 

OK, that all makes sense.

Given that I'll manage at best 1 bisect/day with a reasonable chance of data
corruption and hardware intermittency screwing it all up I thought it best to
ask first in case there was another debug approach that could work. However
since it does indeed sounds somewhat hardware related and it's an isolated
problem for my wife (as opposed to a problem that others are having too) then I
think she deserves a new machine...

Thanks for the impetus to cheer her up ;)

David
PS if anyone really is interested then I am happy to try the bisection once I've
moved her to a new box; otherwise I'm happy to close this.
