Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbXE2Lib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbXE2Lib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbXE2LiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:38:25 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39233 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750758AbXE2LiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:38:24 -0400
Date: Tue, 29 May 2007 13:38:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Neil Brown <neilb@suse.de>
Cc: Theodore Tso <tytso@mit.edu>,
       Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ext3-users@redhat.com
Subject: Re: fs periodic check (was Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted)
Message-ID: <20070529113812.GE23046@elf.ucw.cz>
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com> <20070518143529.GB14611@ribosome.natur.cuni.cz> <20070518215731.GB10655@thunk.org> <20070520195526.GA5235@ucw.cz> <20070522180158.GA4668@thunk.org> <20070524173911.GA4541@ucw.cz> <20070529025534.GD24003@thunk.org> <18011.39033.841231.377192@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18011.39033.841231.377192@notabene.brown>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-05-29 13:05:29, Neil Brown wrote:
> On Monday May 28, tytso@mit.edu wrote:
> > On Thu, May 24, 2007 at 05:39:11PM +0000, Pavel Machek wrote:
> > > Right. Could we get more helpful message here? 'Filesystem check on
> > > next boot on AC power'? 
> > 
> > So "(check deferred; on battery)" wasn't explicit enough?  I guess I
> > assumed that users would understand that the opposite of "on battery"
> > was "on AC power".  I guess I could say "(check defferred 'til on AC
> > power)" if people think it would be clearer.
> > 
> 
> So when I use my travelling power adapter which I plug into the 12V-DC
> power in my car, and it delivers DC power to my notebook.....
> My note book tells me that I am using AC power....
> 
> I really think "AC" as the opposite of "battery" is wrong and should
> be stamped out everywhere, certainly not introduced here.

> "external power" maybe?

Well, on one sunny day, we'll want to tell the difference between
"cheap" power and "expensive" power.

zaurus running on AC or car adapter is "cheap".

zaurus running from external notebook's battery is something in
between -- given that notebook battery should keep zaurus powered for
few weeks.

zaurus running on external 4xAA batteries or on internal li-ion is
"expensive".

...but I'm afraid it will take long time before we can worry about that.

>   Check deferred until system is externally powered.

Check deferred; on battery is completely fine; I just did not see that
message for some reason.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
