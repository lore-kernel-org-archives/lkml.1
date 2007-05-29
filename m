Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbXE2LfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbXE2LfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbXE2Ley
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:34:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50443 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750753AbXE2Ley (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:34:54 -0400
Date: Tue, 29 May 2007 13:34:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>,
       Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ext3-users@redhat.com
Subject: Re: fs periodic check (was Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted)
Message-ID: <20070529113449.GD23046@elf.ucw.cz>
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com> <20070518143529.GB14611@ribosome.natur.cuni.cz> <20070518215731.GB10655@thunk.org> <20070520195526.GA5235@ucw.cz> <20070522180158.GA4668@thunk.org> <20070524173911.GA4541@ucw.cz> <20070529025534.GD24003@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529025534.GD24003@thunk.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Right. Could we get more helpful message here? 'Filesystem check on
> > next boot on AC power'? 
> 
> So "(check deferred; on battery)" wasn't explicit enough?  I guess I
> assumed that users would understand that the opposite of "on battery"
> was "on AC power".  I guess I could say "(check defferred 'til on AC
> power)" if people think it would be clearer.

I did not see the "check deffered; on battery" message. Either I'm
blind, or am using too old fsck. Sorry for noise.

> > Or maybe keep counting, and when we reach 2x mount-count-limit,
> > force a fsck, battery power or not?
> 
> We do that already.  It's just tough to make that all fit on an 80
> status message.  :-)

Great, sorry for more noise.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
