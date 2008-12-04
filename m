Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYLDKa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYLDKa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYLDKaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:30:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54259 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYLDKaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:30:17 -0500
Date: Thu, 4 Dec 2008 11:32:06 +0100
From: Pavel Machek <pavel@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Theodore Tso <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: SD/MMC cards: how crappy they are?
Message-ID: <20081204103206.GD22396@elf.ucw.cz>
References: <20081202144830.GB1549@ucw.cz> <493562A5.40308@zytor.com> <20081202165608.GD18162@mit.edu> <4935778E.1020405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4935778E.1020405@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-02 09:59:42, H. Peter Anvin wrote:
> Theodore Tso wrote:
> > 
> > If this is your random eject out from your HP laptop problem, note
> > that random ejects while the card is writing can cause corruption of
> > the flash translation layer (FTL), which for some really crappy cards,
> > can permanently damage them; hopefully most of those are gone from the
> > market, but I wouldn't be positive about that.  The better ones will
> > have some kind of journalling scheme for their FTL...
> > 
> 
> I have seen flash cards die permanently from having a partition table it
> didn't like written to it.  Yes, the microcontroller on the flash card
> tried to interpret the partition table, assumed to be MS-DOS style, and
> would crash.

Aha... that explains why I killed few flashcards by tar xzvf /dev/sdX files
... hopefully thats fixed in the better/bigger cards now.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
