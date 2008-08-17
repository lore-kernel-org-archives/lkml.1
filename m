Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYHQAVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYHQAVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 20:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYHQAVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 20:21:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbYHQAVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 20:21:42 -0400
Date: Sat, 16 Aug 2008 17:21:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: davem@davemloft.net, Andreas Schwab <schwab@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27-rc3 - build failure: undefined reference to
 `.lockdep_count_forward_deps'
In-Reply-To: <200808162111.23914.elendil@planet.nl>
Message-ID: <alpine.LFD.1.10.0808161720470.3324@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org> <jefxp8ofmz.fsf@sykes.suse.de> <200808162111.23914.elendil@planet.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 16 Aug 2008, Frans Pop wrote:

> Andreas Schwab wrote:
> >> David Miller (3):
> >>       lockdep: fix combinatorial explosion in lock subgraph traversal
> > 
> > lockdep_count_forward_deps is only defined if CONFIG_PROVE_LOCKING but
> > used unconditionally in lockdep_proc.c.
> > 
> > kernel/built-in.o: In function `.lockdep_stats_show':
> > lockdep_proc.c:(.text+0x3fea8): undefined reference to `.lockdep_count_forward_deps'
> > kernel/built-in.o: In function `.l_show': 
> > lockdep_proc.c:(.text+0x401f0): undefined reference to `.lockdep_count_forward_deps'
> > lockdep_proc.c:(.text+0x40210): undefined reference to `.lockdep_count_backward_deps'
> 
> I have so far been unable to build -rc3 because of this same error.
> Just tried again with current git HEAD. Failing config attached.

Ok, I think this one is fixed by df60a8441866153d691ae69b77934904c2de5e0d, 
just pushed out.

		Linus
