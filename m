Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab0BBWcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 17:32:16 -0500
Received: from thunk.org ([69.25.196.29]:43264 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003Ab0BBWcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 17:32:14 -0500
Date: Tue, 2 Feb 2010 17:32:12 -0500
From: tytso@mit.edu
To: Marco <mpiazza@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Phoronix test
Message-ID: <20100202223212.GA16384@thunk.org>
Mail-Followup-To: tytso@mit.edu, Marco <mpiazza@gmail.com>,
	linux-kernel@vger.kernel.org
References: <Xns9D138D644D73mpiazzafastwebnetit@213.140.2.16>
 <20100202130002.68E043A6641@erode.bofh.it>
 <f124e3b71002020716u5ee3cec7tbe35e07d70367948@mail.gmail.com>
 <f124e3b71002020720x98f7fedg1ad1aba4a1087494@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f124e3b71002020720x98f7fedg1ad1aba4a1087494@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 04:20:07PM +0100, Marco wrote:
> 
> And is really ext4 so unreliable as they say in here?:
> http://www.phoronix.com/scan.php?page=news_item&px=Nzk0OA
> 
> It happens also to me using git master: several times my GPU goes
> wild (i915) and the only thing to do is press the halt button. And
> ext4 sometimes looses data, without doing a fsck at restart.  Is
> there a way to know something went wrong, even if fsck did not say
> anything?

If you can reliably reproduce data failure after a crash that involves
a file containing existing data (i.e., not a file that was being
actively written at the time of the crash), I would certainly like to
know about it.  

If the Phoronix people had written to me (as far as I know, they
haven't bothered to send mail to me or the linux-ext4 list), I would
have told them that if they lost information that was located in the
same directory as one that was beeing modified, but those files hadn't
been written recently (not even in the same ext4 mount session), to
shutdown the system, and run fsck on the file system, and that
hopefully the files would appear in lost+found.

Of course, if the crappy proprietary video driver from ATI (or Nvidia)
scribbled garbage over cached inode tables which were then written
back to disk, there's not much anyone can do about it, no matter what
file system they were running.

My guess is that the reason why they didn't bother sending e-mail to
the developers first is they wanted lots of web hits since they get
their revenue from web ads (and that's more important than the lost
data), but maybe that's just me being cynical....

       	   	 	     	      - Ted
