Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbXINOPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbXINOPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXINOPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:15:34 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42641 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754321AbXINOPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:15:33 -0400
Date: Fri, 14 Sep 2007 16:15:42 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mark Lord <lkml@rtr.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, Oliver Neukum <oneukum@suse.de>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-ID: <20070914141542.GK3563@stusta.de>
References: <20070913154019.GG3563@stusta.de> <Pine.LNX.4.44L0.0709131154240.7406-100000@iolanthe.rowland.org> <20070913201910.GH3563@stusta.de> <alpine.LFD.0.999.0709131341300.16478@woody.linux-foundation.org> <20070913212842.GI3563@stusta.de> <20070913220543.GJ3563@stusta.de> <alpine.LFD.0.999.0709131709320.16478@woody.linux-foundation.org> <46EA8AC4.3000007@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46EA8AC4.3000007@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 09:21:08AM -0400, Mark Lord wrote:
> Linus Torvalds wrote:
>> On Fri, 14 Sep 2007, Adrian Bunk wrote:
>>> E.g. when looking at the reverse dependencies of libhal, it would not be 
>>> funny if kernel 2.6.43 required a more recent version of HAL.
>> Adrian, what's the point of answering your questions, WHEN YOU DON'T EVEN 
>> READ THE ANSWERS!
>> So stop repeating your inane question, and instead LISTEN to what people 
>> are saying.
>> There is *no* requirement what-so-ever on user space. End of story.
>> If user-space doesn't tell devices to go to autosuspend, they just won't 
>> do so. But this has nothing to do with white-lists, black-lists, 2.6.43, 
>> or your HAL version.
>> That black-listing was a mistake. We got over it. Now PLEASE you get over 
>> it too!
>
> Adrian, please note that this is NOT the normal "suspend to ram/disk" stuff
> that is being discussed / affected here.  But rather something brand new 
> (to Linux), the automatic powerdown (well, nearly) of idle USB devices
> during regular running.

I am quite aware of this fact.

> Things will work just fine without chewing up gobs of memory in a futile 
> effort
> to list everything inside the kernel.  Devices will plug in and work fine
> (which they didn't in 2.6.23 until this stuff got reverted) the same as 
> always.

Space saving has it's place, but there's also the point that for the 
normal desktop usage a few 100 kB of data wouldn't matter.

> To gain the last xx% in power savings, some userspace support may be 
> needed,
> that's all.  And with the pace of new/updated USB devices coming/going 
> these days,
> userspace is really the only appropriate place for this kind of stuff.

It creates one more userspace _ABI_ for something that doesn't 
necessarily need one.

Perhaps I'm wrong and people have learnt the lesson from the udev 
disaster that ABIs used by stuff like udev or HAL are _userspace ABIs_
and have to be treated accordingly.

> Cheers

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

