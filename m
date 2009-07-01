Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZGAOkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZGAOkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZGAOkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:40:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52346 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751549AbZGAOkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:40:40 -0400
Date: Wed, 1 Jul 2009 15:41:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       john.lanza@linux.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090701154151.7f45abad@lxorguk.ukuu.org.uk>
In-Reply-To: <19019.27736.647500.497114@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<19019.16217.291678.588673@samba.org>
	<20090701123141.402c17d2@lxorguk.ukuu.org.uk>
	<19019.25035.244941.352337@samba.org>
	<20090701143844.07728fdf@lxorguk.ukuu.org.uk>
	<19019.27736.647500.497114@samba.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If there is another approach that achieves this goal in a better way
> then we should look at it. Can you suggest an alternative that will
> work better for Linux handheld device makers?

They can type 

patch -p1 < linux-foundation-recommended-ussa-fat.patch

which removes all the subversive terrorist code that Americans are scared
to posess.

As has already been said from their point of view thats lowest risk so
they will go that path anyway because the question is always "how do I
cover my backside maximally"

Vendors already do this for other stuff. Why is the kernel special or
different ? Take a look at Red Hat RPMS of music players, video players,
even things like netpbm for a while where JBIG had patent issues and was
simply ripped out of the package.

I think you are in real danger of creating a compromise that helps nobody

Putting the stuff in kernel upsets everyone who isn't under US rule,
creates situations where things cannot be discussed and doesn't make one
iota of difference to the vendors because they will remove the code from
the source tree options and all anyway - because as has already been said
it reduces risk.

It also sets a very dangerous precedent. What do you want to do about say
our Kconfig help for 'Taiwanese' if it doesn't meet Chinese regulations.
What about the Burmese code page. What about code submissions from Iran ?

The kernel really cannot and should not get involved in these. Its a
vendor problem. They deal with it every day of the year already from MP3
to Taiwanese flags to US crypto export regulations to patents to the
openssh option for using the DVD crypto algorithm to making sure their
language definitions don't get their product banned in some jurisdiction
or another. They have to remove games that glorify war in any way from
German product, and so on..

None of this other mass of red tape, bogocracy and the like gets dumped
on users all over the world. It's handled by specialists in vendor
companies supported by qualified legal personnel with whom they can have
full and frank discussion.

Another problem with this is that the foundation lawyers goals are almost
certainly influenced by the goal to maximise arse coverage for large
businesses with US connections. That is who pays them, that is who asks
their advice. That puts them partly at odds with the general good.

Alan
