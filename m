Return-Path: <linux-kernel-owner+w=401wt.eu-S1761053AbYETUFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053AbYETUFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759084AbYETUE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:04:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933358AbYETUE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:04:27 -0400
Date: Tue, 20 May 2008 13:02:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0 of 8] x86: use PTE_MASK consistently
In-Reply-To: <20080520195147.GA17648@elte.hu>
Message-ID: <alpine.LFD.1.10.0805201300010.3081@woody.linux-foundation.org>
References: <patchbomb.1211268376@localhost> <20080520195147.GA17648@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 May 2008, Ingo Molnar wrote:
> 
> yep, this has been problem-free in x86.git and then in -tip, we had a 
> separate x86/ptemask topic for it that we originally intended for 
> v2.6.27, and we dont mind to see it upstream now ;-)

Well, since we actually had a regression, I had to do something before 
actually doing 2.6.26.

So to fix the X crash problem with PAE, the choice was between either 
applying this series that cleans things up or alternatively add yet 
another hack to work around the problem.

And I'm much happier taking the proper fix, even if it was slightly 
bigger. It's not like it was a huge and complicated and scary fix ;)

		Linus
