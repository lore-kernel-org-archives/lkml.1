Return-Path: <linux-kernel-owner+w=401wt.eu-S1762701AbXINNsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762701AbXINNsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:48:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbXINNso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:48:44 -0400
Received: from rtr.ca ([76.10.145.34]:2219 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbXINNsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:48:43 -0400
Message-ID: <46EA8AC4.3000007@rtr.ca>
Date: Fri, 14 Sep 2007 09:21:08 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
References: <20070913154019.GG3563@stusta.de> <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org> <20070913201910.GH3563@stusta.de> <alpine.LFD.0.999.0709131341300.16478@woody.linux-foundation.org> <20070913212842.GI3563@stusta.de> <20070913220543.GJ3563@stusta.de> <alpine.LFD.0.999.0709131709320.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709131709320.16478@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 14 Sep 2007, Adrian Bunk wrote:
>> E.g. when looking at the reverse dependencies of libhal, it would not be 
>> funny if kernel 2.6.43 required a more recent version of HAL.
> 
> Adrian, what's the point of answering your questions, WHEN YOU DON'T EVEN 
> READ THE ANSWERS!
> 
> So stop repeating your inane question, and instead LISTEN to what people 
> are saying.
> 
> There is *no* requirement what-so-ever on user space. End of story.
> 
> If user-space doesn't tell devices to go to autosuspend, they just won't 
> do so. But this has nothing to do with white-lists, black-lists, 2.6.43, 
> or your HAL version.
> 
> That black-listing was a mistake. We got over it. Now PLEASE you get over 
> it too!

Adrian, please note that this is NOT the normal "suspend to ram/disk" stuff
that is being discussed / affected here.  But rather something brand new 
(to Linux), the automatic powerdown (well, nearly) of idle USB devices
during regular running.

Things will work just fine without chewing up gobs of memory in a futile effort
to list everything inside the kernel.  Devices will plug in and work fine
(which they didn't in 2.6.23 until this stuff got reverted) the same as always.

To gain the last xx% in power savings, some userspace support may be needed,
that's all.  And with the pace of new/updated USB devices coming/going these days,
userspace is really the only appropriate place for this kind of stuff.

Cheers
