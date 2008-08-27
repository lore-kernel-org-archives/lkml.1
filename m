Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYH0L7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYH0L7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 07:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYH0L7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 07:59:22 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43412 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbYH0L7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 07:59:21 -0400
Date: Wed, 27 Aug 2008 14:58:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
	bisected
Message-ID: <20080827115829.GF11734@cs181140183.pp.htv.fi>
References: <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org> <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org> <20080826232411.GC11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261648140.3363@nehalem.linux-foundation.org> <20080827002316.GE11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261726560.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808261726560.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 05:28:37PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 27 Aug 2008, Adrian Bunk wrote:
> > 
> > When did we get callpaths like like nfs+xfs+md+scsi reliably 
> > working with 4kB stacks on x86-32?
> 
> XFS may never have been usable, but the rest, sure.
> 
> And you seem to be making this whole argument an excuse to SUCK, adn an 
> excuse to let gcc crap even more on our stack space.
> 
> Why?
> 
> Why aren't you saying that we should be able to do better? Instead, you 
> seem to asking us to do even worse than we do now?

My main point is:
- getting 4kB stacks working reliably is a hard task
- having an eye on gcc increasing the stack usage, and fixing it if
  required, is relatively easy

If we should be able to do better at getting (and keeping) 4kB stacks 
working, then coping with possible inlining problems caused by gcc
should not be a big problem for us.

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

