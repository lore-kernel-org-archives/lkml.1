Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbZADWjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbZADWjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbZADWi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:38:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58291 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZADWiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:38:55 -0500
Date: Sun, 4 Jan 2009 23:40:52 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104224052.GE1913@elf.ucw.cz>
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no> <fa.b62zZFe5e154PhgA+0sdwVXD9F0@ifi.uio.no> <fa.ZTpiSvxEhp3YJDepiUQs+cU0C98@ifi.uio.no> <fa.xvvufQC6zTpU9R6vhDl51DR5V7A@ifi.uio.no> <fa.pkV69eXC76Pb9fnmERdAwXX9OKA@ifi.uio.no> <fa.hQTLXdIllf+hs4yQb092u6fowq0@ifi.uio.no> <49610911.8000204@yahoo.com> <20090104193141.GA22958@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104193141.GA22958@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-01-04 14:31:41, Theodore Tso wrote:
> On Sun, Jan 04, 2009 at 07:08:01PM +0000, Sitsofe Wheeler wrote:
> > Theodore Tso wrote:
> >> So what's the use case where people want to be able to mount a
> >> filesystem needing recovery read/only without running the journal?
> >
> > Corrupted SD card[1] that's been locked to read only for recovery  
> > purposes without having the FS tear itself apart further?
> 
> In that case, the right answer is to copy the 32 GB SD card to hard
> drive, and then operate on the hard drive.....  In general, if the
> media has started going bad, the *first* thing you want to do is an
> immediate copy of the media to some place stable.

Not neccessarily.

If I have a bit of precious data and lot of junk on the card, I want
to copy out the precious data before the card dies. Reading the whole
media may just take too long.

That's probably very true for rotating harddrives after headcrash...

"ro, noload" seems like very acceptable solution in that case.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
