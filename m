Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYH0AaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYH0AaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 20:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYH0A3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 20:29:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbYH0A3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 20:29:51 -0400
Date: Tue, 26 Aug 2008 17:28:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <20080827002316.GE11734@cs181140183.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0808261726560.3363@nehalem.linux-foundation.org>
References: <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org> <20080826183051.GB10925@cs181140183.pp.htv.fi>
 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826205916.GB11734@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org> <20080826232411.GC11734@cs181140183.pp.htv.fi>
 <alpine.LFD.1.10.0808261648140.3363@nehalem.linux-foundation.org> <20080827002316.GE11734@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Aug 2008, Adrian Bunk wrote:
> 
> When did we get callpaths like like nfs+xfs+md+scsi reliably 
> working with 4kB stacks on x86-32?

XFS may never have been usable, but the rest, sure.

And you seem to be making this whole argument an excuse to SUCK, adn an 
excuse to let gcc crap even more on our stack space.

Why?

Why aren't you saying that we should be able to do better? Instead, you 
seem to asking us to do even worse than we do now?

			Linus
