Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYAVQCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYAVQCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYAVQCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:02:40 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59801 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbYAVQCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:02:39 -0500
Date: Tue, 22 Jan 2008 18:01:14 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Newall <davidn@davidnewall.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
Message-ID: <20080122160114.GB23277@does.not.exist>
References: <20080120031153.GB6275@one.firstfloor.org> <4792D221.1010704@davidnewall.com> <20080120051822.GB19784@one.firstfloor.org> <4792DD22.4070902@davidnewall.com> <20080120055544.GB19861@one.firstfloor.org> <4792E8E2.1090307@davidnewall.com> <20080120072922.GA21047@one.firstfloor.org> <4793F775.6090403@davidnewall.com> <20080122111205.GA25090@elte.hu> <4796081A.7060505@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4796081A.7060505@davidnewall.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 01:43:30AM +1030, David Newall wrote:
> Ingo Molnar wrote:
> > * David Newall <davidn@davidnewall.com> wrote:
> >   
> >> Andi Kleen wrote:
> >>     
> >>> You seem to be under the illusion that iBCS2 support works currently
> >>> in mainline and that only this patch would break it.
> >>>       
> >> I cannot imagine what brings you to that conclusion.  Suffice to say 
> >> you are entirely and inexplicably wrong.
> >>     
> >
> > it should be very easy for you to prove me wrong then. I've got a very 
> > simple question: please tell me, how do i run a binary compiled for an 
> > iBCS2 platform under Linux v2.6.23?
> >   
> 
> You're being silly.  Either that or you're not reading what I write. 
> You know perfectly well iBCS2 compatibility doesn't work (anymore.)  The
> question, in my mind, is will it ever be made to work again?  I think
> the answer should be yes.

Fact is that it isn't working with what is in the kernel today.

That is enough for justifying the removal of what is dead code today.

If someone submits at some point in the future a patch using this stuff 
he can as well put these tiny bits back.

But Linux kernel development is not driven by people producing hot air 
about what they wish to see in the future, Linux kernel development is 
driven by people sending patches.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

