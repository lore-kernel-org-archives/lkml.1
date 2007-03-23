Return-Path: <linux-kernel-owner+w=401wt.eu-S934331AbXCWXAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbXCWXAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992611AbXCWXAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:00:20 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33057 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992607AbXCWXAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:00:19 -0400
Date: Sat, 24 Mar 2007 00:00:21 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David L <idht4n@hotmail.com>
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070323230021.GX752@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185028.GR752@stusta.de> <1174677338.10840.321.camel@localhost.localdomain> <46045355.1020105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46045355.1020105@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 06:23:17PM -0400, Chuck Ebbert wrote:
> Thomas Gleixner wrote:
> > On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> >> Subject    : gettimeofday increments too slowly
> >> References : http://bugzilla.kernel.org/show_bug.cgi?id=8027
> >> Submitter  : David L <idht4n@hotmail.com>
> >> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> >>              commit 92c7e00254b2d0efc1e36ac3e45474ce1871b6b2
> >> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> >> Status     : problem is being debugged
> > 
> > Patch available: http://lkml.org/lkml/2007/3/22/301
> > 
> > commit 6b3964cde70cfe6db79d35b42137431ef7d2f7e4
> > 
> 
> For the other issue raised there, clock running too slow, I now
> realize there is a similar report:
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=231626

It shouldn't be the same issue:
2.6.20-1.2925.fc6 is based in 2.6.20.3-rc1 while this issue is a
2.6.21-rc regression.
Or do the -rc kernels include parts of the -rt patchsets?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

