Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbZAMCJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbZAMCJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 21:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZAMCJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 21:09:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057AbZAMCJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 21:09:35 -0500
Date: Mon, 12 Jan 2009 18:08:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Daniel Drake <dsd@gentoo.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Phil Dibowitz <phil@ipom.com>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
In-Reply-To: <b6a2187b0901121720s1f9b12ednb76a90dcc7eddc81@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0901121807070.6528@localhost.localdomain>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>  <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com>  <20090111162949.GA15338@elte.hu>  <200901111736.24350.borntraeger@de.ibm.com>  <20090111163904.GA21806@elte.hu>  <b6a2187b0901110856j3f2ff6fepc19a816178e38a95@mail.gmail.com>
  <20090111180714.GB15326@elte.hu> <b6a2187b0901121720s1f9b12ednb76a90dcc7eddc81@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Jan 2009, Jeff Chua wrote:
>
> I was trying to bisect further, but ended up with this strange behavior...
> 
> # git bisect good a3a798c88a14b35e5d4ca30716dbc9eb9a1ddfe2
> Bisecting: 579 revisions left to test after this
> [079899c2384023cd8efcd3806680b4f1d2abbd54] Btrfs: Change
> find_extent_buffer to use TestSetPageLocked
> 
> # ls
> .  ..  .git  fs
> 
> Is this a bug or a feature?

You bisected into the btrfs development chain. Just say "git bisect good" 
when this happens, and you'll be ok.

[ Unless, of course, you were to be actually trying to bisect a btrfs bug. 
  If so, you'd need to compile btrfs as a module and insert it and do the 
  bisection based on that ]

			Linus
