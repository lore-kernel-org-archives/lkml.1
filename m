Return-Path: <linux-kernel-owner+w=401wt.eu-S1760739AbXFIXgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739AbXFIXgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 19:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758027AbXFIXgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 19:36:09 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50450 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758144AbXFIXgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 19:36:08 -0400
Date: Sun, 10 Jun 2007 01:35:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Christian Leber <christian@leber.de>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: beeping patch for debugging acpi sleep
Message-ID: <20070609233541.GC21229@elf.ucw.cz>
References: <20070518213701.GA810@core> <20070520200142.GB5235@ucw.cz> <20070602182014.GB29546@core> <20070609130817.GI27793@elf.ucw.cz> <20070609131604.GM2649@lug-owl.de> <20070609225421.GA20521@elf.ucw.cz> <1181431675.14045.140.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181431675.14045.140.camel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-06-10 09:27:55, Nigel Cunningham wrote:
> Hi.
> 
> On Sun, 2007-06-10 at 00:54 +0200, Pavel Machek wrote:
> > On Sat 2007-06-09 15:16:04, Jan-Benedict Glaw wrote:
> > > On Sat, 2007-06-09 15:08:17 +0200, Pavel Machek <pavel@ucw.cz> wrote:
> > > > 
> > > > Starting beeper as soon as ACPI sleep returns is very useful in
> > > > debugging "apparently dead" machines. If it beeps at all, it makes
> > > > sense to start playing with CMOS tracer.
> > > 
> > > I'd even go so far and implement it unconditionally.
> > 
> > Well, try it; it is too annoying to be unconditional.
> 
> Could you modify the pitch or the length then, to make it less annoying?
> It sounds like a really good idea to me.

Modifying length is non-trivial, AFAICT, but feel free to submit a
patch...

Actually, *any* tone will be annoying in quiet room, and kernel should
not really be making sounds on its own, so scratch that idea.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
