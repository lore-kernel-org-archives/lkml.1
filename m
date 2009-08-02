Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZHBWIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZHBWIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbZHBWI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:08:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59210 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbZHBWI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:08:26 -0400
Date: Mon, 3 Aug 2009 00:08:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: "Michael S. Zick" <lkml@morethan.org>, linux-kernel@vger.kernel.org
Subject: Re: [VIA Support]  Instruction timing and cache coherency issues
Message-ID: <20090802220819.GB22237@elf.ucw.cz>
References: <200907250827.43400.lkml@morethan.org> <20090730090804.GE1364@ucw.cz> <20090802190851.GZ4216@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802190851.GZ4216@prithivi.gnumonks.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-08-02 21:08:51, Harald Welte wrote:
> On Thu, Jul 30, 2009 at 11:08:04AM +0200, Pavel Machek wrote:
> 
> > > Diddling with the things I have found that either "fix" or "work around"
> > > the various timing / cache coherency issues - - -
> > > Aw, so - found how to affect the timing issues sufficiently so that Linux
> > > would panic dump rather than deadlock on the troublesum combination - -
> > > *Functionally the same* panic backtrace that FreeBSD is showing.
> > > 
> > > @H.W.  Download the FreeBSD-8.0-beta2 and try running it on your Cloudbook
> > > and HP-2133, you can see what is happening.  Then you might have a word or
> > > two with the silicon growers.
> > > 
> > So... you believe you have pinpointed bug in their cpu design?
> 
> I would not preclude that, but I think what might be more likely is that there
> is some difference between how Intel and how VIA/Centaur behaves in a certain
> situation, or the compiler making a wrong assumption about what it can do or
> cannot do (remember e.g. for the VIA C3 there was no cmpxchg8, but gcc uses
> it in case you compile with i686 optiomization).

I'd expect any difference in behaviour (modulo timing, extensions, and
cpuid) between Intel 486 and VIA C3 to be VIA bug, because VIA is
supposed to be Intel 486 compatible, no?

If not, where is behaviour of VIA cpus specified? Will we have to
compare 1000s of pages of instruction manuals to see where the traps lie?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
