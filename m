Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbZIIOXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbZIIOXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZIIOXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:23:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42484 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZIIOXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:23:04 -0400
Date: Wed, 9 Sep 2009 10:01:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, swetland@google.com
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090909080132.GA1548@ucw.cz>
References: <20090903041429.GA29875@kroah.com> <20090906052819.GE1324@ucw.cz> <1252338939.2139.21.camel@desktop> <20090909095702.GB28615@elf.ucw.cz> <1252505941.14793.97.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252505941.14793.97.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-09-09 07:19:01, Daniel Walker wrote:
> On Wed, 2009-09-09 at 11:57 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > > 	  Note, Pavel has been adding some of the Dream hardware
> > > > > 	  drivers, which are separate from the core Android drivers.  I
> > > > > 	  have no objection to those, but they should work to get merged
> > > > > 	  to their "correct" places in the tree in another release or
> > > > > 	  so.
> > > > 
> > > > Well, some of those drivers should be moderately easy (touchscreen),
> > > > but some (camera) will take longer than that. For example camera --
> > > > contains _lots_ of code, and uses obsolete v4l api.
> > > > 
> > > > Plus, I really need to get recent kernel to boot and then get arch/arm
> > > > pieces merged....
> > > 
> > > I've got a tree with a lot of the arch/arm/msm pieces isolated, doesn't
> > > boot yet .. I had to drop certain parts like the key pad support since
> > > it had a big generic change attached to it .. It's all part of a git
> > > tree which I can expose if you want to look at it.
> > 
> > Yes, minimal, but booting version would be very welcome. I tried to
> > produce exactly that few times, but did not succeed (yet).
> 
> Last night I discovered maybe a better tree to use ..
> 
> https://www.codeaurora.org/gitweb/quic/kernel/?p=bryanh/linux-2.6.git;a=summary
> 
> It's based off a newer kernel 2.6.31-rc6 . I have a feeling it's minus a
> lot of the google stuff.

Big question is... 'does it boot?' :-). The rest should be easy.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
