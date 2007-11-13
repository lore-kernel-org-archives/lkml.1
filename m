Return-Path: <linux-kernel-owner+w=401wt.eu-S1763841AbXKMVjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763841AbXKMVjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761616AbXKMVjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:39:12 -0500
Received: from lazybastard.de ([212.112.238.170]:56977 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761557AbXKMVjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:39:11 -0500
Date: Tue, 13 Nov 2007 22:33:58 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Mark Lord <liml@rtr.ca>
Cc: Ingo Molnar <mingo@elte.hu>, alsa-devel@alsa-project.org,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       linux-ide@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113213358.GC20167@lazybastard.org>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113193750.GD1356@flint.arm.linux.org.uk> <473A067F.3090007@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <473A067F.3090007@rtr.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 November 2007 15:18:07 -0500, Mark Lord wrote:
> 
> I just find it weird that something can be known broken for several -rc*
> kernels before I happen to install it, discover it's broken on my own 
> machine,
> and then I track it down, fix it, and submit the patch, generally all 
> within a
> couple of hours.  Where the heck was the dude(ess) that broke it ??  AWOL.
> 
> And when I receive hostility from the "maintainers" of said code for fixing
> their bugs, well.. that really motivates me to continue reporting new ones..

Given a decent bug report, I agree that having the bug not looked at is
shameful.  But what can a developer do if a bug report effectively reads
"there is some bug somewhere in recent kernels"?  How can I know that in
this particular case it is my bug that I introduced?  It could just as
easily be 50 other people and none of them are eager to debug it unless
they suspect it to be their bug.

This is a common problem and fairly unrelated to linux in general or the
kernel in particular.  Who is going to be the sucker that figures out
which developer the bug belongs to?  And I have yet to find a project,
commercial or opensource, where volunteers flock to become such a
sucker.

One option is to push this role to the bug reporter.  Another is to
strong-arm some developers into this role, by whatever means.  A third
would be for $LARGE_COMPANY to hire some people.  If you have a better
idea or would volunteer your time, I'd be grateful.  Simply blaming one
side, whether bug reporter or a random developer, for not being the
sucker doesn't help anyone.

Jörn

-- 
Joern's library part 2:
http://www.art.net/~hopkins/Don/unix-haters/tirix/embarrassing-memo.html
