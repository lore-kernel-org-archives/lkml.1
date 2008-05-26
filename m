Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYEZQtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYEZQtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYEZQt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:49:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45329 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYEZQt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:49:27 -0400
Date: Mon, 26 May 2008 18:48:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080526164858.GA24098@elte.hu>
References: <4836EE8C.1010200@linux.intel.com> <20080524222304.GD20563@atrey.karlin.mff.cuni.cz> <20080524153020.1df96cf2@linux.intel.com> <20080524224554.GA5970@mit.edu> <20080526093913.GG13529@elte.hu> <20080526101646.GD24507@mit.edu> <20080526104832.GG23261@elte.hu> <20080526162048.GH32407@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526162048.GH32407@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Kara <jack@suse.cz> wrote:

> just fine, as far as I understand. It only spits a dangerously looking 
> warning and that's it. I agree we shouldn't be doing this but I don't 
> really find this a critical problem.

yeah i know it's "just" a warning, i checked the stack dump on 
kerneloops.org before i wrote the mail.

Pulling removable media out while it might still be mounted is a fact of 
life and comes not from the stupidity of the user but from the lack of 
physical barriers on the device side.

What if the USB stick was pulled mistakenly, the user notices her 
mistake later on and plugs the USB stick back in and expects all the 
data to not be corrupted?

What if the user puts the stick back in and it wont be mounted or will 
be critically damaged?

How do we even know whether these cases all work 100% robustly if the 
attitude is that removing a mounted device is a stupid thing to do and a 
bug related to it gets deprioritized? [starting with the issue of why 
the user should even care about such a relatively low-level abstraction 
as a "mounted filesystem".]

And any such problems do come up in the enterprise space as well, in 
terms of multipath IO issues - and Linux still does quite poorly in that 
area.

	Ingo
