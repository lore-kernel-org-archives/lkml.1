Return-Path: <linux-kernel-owner+w=401wt.eu-S934470AbXLNRC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470AbXLNRC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbXLNRCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:02:20 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:52655 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXLNRCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:02:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Date: Fri, 14 Dec 2007 17:59:58 +0100
User-Agent: KMail/1.9.6
Cc: stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Daniel Walker" <dwalker@mvista.com>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       mbuesch@freenet.de, linux@bohmer.net, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
References: <20071213003028.676998182@mvista.com> <2c0942db0712140827x38e5d971sbdb3d5864fc32364@mail.gmail.com> <2c0942db0712140845p1dfd8b23va13525b75224f4c0@mail.gmail.com>
In-Reply-To: <2c0942db0712140845p1dfd8b23va13525b75224f4c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141759.59273.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 December 2007 17:45:52 Ray Lee wrote:
> On Dec 14, 2007 8:27 AM, Ray Lee <ray-lk@madrabbit.org> wrote:
> > On Dec 14, 2007 6:40 AM,  <stefano.brivio@polimi.it> wrote:
> > > Agreed. As a b43legacy maintainer, I'd be happy to know if Ingo
> > > suggests other ways to smooth out the transition. I haven't read
> > > proposals yet.
> >
> > This isn't rocket science guys. Put a file in somewhere in your tree
> > called ReleaseAnnouncement or something, and ask Linus to adjust his
> > kernel release process to include the contents of `cat $( find . -name
> > ReleaseAnnouncement )` in the release message he sends out. Clear out
> > the file after the release.
> >
> > Include things such as "bcm43xx is scheduled for removal. build both
> > b43 and b43legacy as a replacement. Be sure to download the latest
> > firmware from $URL and follow the instructions there to extract the
> > correct latest firmware necessary for your chip. There are known
> > incompatibilities with old udev versions, please ensure blah blah
> > blah."
> 
> Or even better, keep the history, and show the diff of the old versus
> new in the release announcement, with an appropriate sed 's/+/ /' or
> somesuch.
> 
> <shrug> I'm sure you all will figure something out. Regardless, my
> point is a higher level changelog that is human readable would be
> helpful. (There are thousands of per-commit changelog entries to read,
> it's beyond what I have the time to do when testing a new kernel).
> Also, it seems distributing the release announcement work would be as
> helpful as distributing the code development work.

In my opinion this all is the work of the distributions and not the
work of the kernel developers. Distributions have to make sure that
everything works after a kernel update. Yes I know that this is difficult
with b43, as the firmware is closed source. But this can be worked
around by explicitely prompting the user when the kernel is updated.
This is all distribution stuff.

What if you want to compile your own kernel? Well, then you are on
your own anyway. You have to track kernel changes anyway.
And I am pretty sure that it really is simple to track kernel changes.
Get your favourite kernel news site. It will tell you the changes
without this magic ReleaseAnnouncement file stuff.
I mean. There are news sites (even not specific ones for the kernel)
that reported the bcm43xx->b43 change weeks ago. There must be some
place where they get this information from without magic files. ;)

-- 
Greetings Michael.
