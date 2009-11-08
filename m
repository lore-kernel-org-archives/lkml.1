Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZKHTwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZKHTwD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZKHTwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:52:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55859 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbZKHTwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:52:02 -0500
Date: Sun, 8 Nov 2009 20:51:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matteo Croce <technoboy85@gmail.com>
Cc: Sven-Haegar Koch <haegar@sdinet.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091108195158.GD4186@elf.ucw.cz>
References: <20091003072127.GC21407@elte.hu>
 <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
 <4AF4526B.4060101@zytor.com>
 <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
 <20091108173708.GF1372@ucw.cz>
 <40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>
 <20091108181016.GB32364@elf.ucw.cz>
 <alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>
 <20091108193618.GB4186@elf.ucw.cz>
 <40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40101cc30911081147j77f7b81o86f2cc5a869aca1f@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> But no standard distribution will be made available in a geode special
> >> version - not enough machines in the marekt. So I think it is better to
> >> be able to use the i686 specific things they already support, like
> >> libc6-686 from debian for example.
> >
> > So hack your distribution to use libc6-686 if you know that it is
> > safe... (that is no NOPL usage there). Still no need to break
> > /proc/cpuinfo.
> 
> Better to be sure that a NOPL whouldn't SIGILL your program, isn't
> it?

SIGILL is easier to debug than NOPL mysteriously taking 100x time it
should, sorry.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
