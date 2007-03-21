Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbXCUTeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbXCUTeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933817AbXCUTeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:34:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37412 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933813AbXCUTeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:34:17 -0400
Date: Wed, 21 Mar 2007 20:34:20 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Sid Boyce <g3vbv@blueyonder.co.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
Message-ID: <20070321193420.GP752@stusta.de>
References: <45E59D64.3070202@blueyonder.co.uk> <200702281805.13822.auxsvr@gmail.com> <20070307214730.87859590.akpm@linux-foundation.org> <45EFBC73.2030005@blueyonder.co.uk> <46016EAF.6010801@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46016EAF.6010801@blueyonder.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 05:43:11PM +0000, Sid Boyce wrote:
> Sid Boyce wrote:
> >Andrew Morton wrote:
> >>(cc restored.  Please always do reply-to-all)
> >>
> >> 
> >>>On Wed, 28 Feb 2007 18:05:13 +0200 auxsvr@gmail.com wrote:
> >>>On Wednesday 28 February 2007 17:19, Sid Boyce wrote:
> >>>   
> >>>>openSUSE 10.3 Alpha and KDE-3.5.6, xorg-x11-7.2. KDE is setup not to
> >>>>require a password to unlock, but it asks for password. When the screen
> >>>>unlocks, kwin is gone with no errors logged in /var/log/kdm or
> >>>>/var/log/messages. No problems with 2.6.20.
> >>>>
> >>>>Same problem on openSUSE 10.2 x86_64, KDE-3.5.5 and 2.6.21-rc2.
> >>>>Regards
> >>>>Sid.
> >>>>      
> >>>This is the linux kernel mailing list. Perhaps you should post your 
> >>>problem to the opensuse mailing list.
> >>>    
> >>
> >>2.6.20 worked.
> >>
> >>2.6.20-rc2 did not.
> >>
> >>Working theory: the kernel broke.
> >>
> >>Sid, the chances that anyone can work out what caused this are pretty 
> >>low. It would be great if you could perform a git bisection search 
> >>sometime in
> >>the next few weeks, work out which commit caused this.
> >>
> >>Thanks.
> >>
> >>
> >>
> >>  
> >I shall go back to 2.6.20-git3 and work forward. Up to 2.6.20-git2 was OK.
> >Regards
> >Sid.
> >
> 
> I tracked the problem down to 2.6.20-git11. Up to 2.6.20-git10 is OK, 
> but from 2.6.20-git11 up to current 2.6.21-rc4-git2 all exhibit the problem.

Thanks for this search.

Looking at the changes between 2.6.20-git10 and 2.6.20-git11, the only 
suspicious changes are the 60 sysctl patches by Eric.

Eric, can you look at this issue?

> Regards
> Sid.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

