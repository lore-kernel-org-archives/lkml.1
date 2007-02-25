Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXBYKmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXBYKmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964783AbXBYKmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:42:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40248 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778AbXBYKmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:42:04 -0500
Date: Sun, 25 Feb 2007 11:41:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: bert hubert <bert.hubert@netherlabs.nl>, Andi Kleen <andi@firstfloor.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: all syscalls initially taking 4usec on a P4? Re: nonblocking UDPv4 recvfrom() taking 4usec @ 3GHz?
Message-ID: <20070225104154.GA2045@elf.ucw.cz>
References: <20070219231447.GA4400@outpost.ds9a.nl> <p73d545drx6.fsf@bingen.suse.de> <20070220162714.GA3245@outpost.ds9a.nl> <20070220164124.GA24930@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220164124.GA24930@2ka.mipt.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I've done so, with some interesting results. Source on
> > http://ds9a.nl/tmp/recvtimings.c - be careful to adjust the '3000' divider
> > to your CPU frequency if you care about absolute numbers!
> > 
> > These are two groups, each consisting of 10 consecutive nonblocking UDP
> > recvfroms, with 10 packets preloaded. Reported is the number of microseconds
> > per recvfrom call which yielded a packet:
> > 
> > $ ./recvtimings
> > 4.142333
> 
> It can be recvfrom only problem - syscall overhead on my p4 (core duo,
> debian testing) is bout 300 usec - to test I ran 

core duo is _not_ p4 class cpu; rsulets there will be very different.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
