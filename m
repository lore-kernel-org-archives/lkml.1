Return-Path: <linux-kernel-owner+w=401wt.eu-S934682AbYAaSUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682AbYAaSUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765113AbYAaSUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:20:32 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57995 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbYAaSUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:20:30 -0500
Date: Thu, 31 Jan 2008 20:21:08 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, wli@holomorphy.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       sparclinux@vger.kernel.org
Subject: Re: sparc compile error caused by x86 arch updates
Message-ID: <20080131182108.GI19700@cs181133002.pp.htv.fi>
References: <20080130011550.GA31853@elte.hu> <20080131155739.GA19700@cs181133002.pp.htv.fi> <20080131160033.GA11501@elte.hu> <20080131161235.GB19700@cs181133002.pp.htv.fi> <20080131161523.GA12347@elte.hu> <20080131162920.GE19700@cs181133002.pp.htv.fi> <47A1FC6D.6090305@goop.org> <20080131174331.GA11881@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080131174331.GA11881@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 06:43:31PM +0100, Ingo Molnar wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > But I guess I overlooked the comment...
> >
> > I guess the fix is to scatter linux/pagemap.h into the appropriate 
> > places where these macros are used (asm-generic/tlb.h, for a start).
> 
> no. The fix is always to undo the damage ASAP, to keep the window of 
> breakage minimized.
> 
> Adrian, could you please check whether latest x86.git:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> resolves the Sparc build failure you were seeing? All known issues are 
> fixed in it. (let me know if you know about more)

Compiles here on sparc.

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

