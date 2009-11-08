Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZKHTu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZKHTu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZKHTu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:50:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49493 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbZKHTuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:50:55 -0500
Date: Sun, 8 Nov 2009 20:50:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matteo Croce <technoboy85@gmail.com>
Cc: Sven-Haegar Koch <haegar@sdinet.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091108195052.GC4186@elf.ucw.cz>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com>
 <20091003072127.GC21407@elte.hu>
 <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com>
 <4AF4526B.4060101@zytor.com>
 <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
 <20091108173708.GF1372@ucw.cz>
 <40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>
 <20091108181016.GB32364@elf.ucw.cz>
 <alpine.DEB.2.00.0911082026430.30789@aurora.sdinet.de>
 <40101cc30911081146p6a72eb88m899dae0bae095f58@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40101cc30911081146p6a72eb88m899dae0bae095f58@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > > Teach gcc that geodelx exists? No need to break kernel for that... and
> >> > > you probably can gain even bigger gains.
> >
> > But no standard distribution will be made available in a geode special
> > version - not enough machines in the marekt. So I think it is better to
> > be able to use the i686 specific things they already support, like
> > libc6-686 from debian for example.
> 
> That's exactly the patch point

Not quite.

Your cpu is not 686; stop trying to pretend it is.

Now, maybe it is good idea to run libc6-686 on it. If you can
guarantee it contains no NOPL, fix whatever code is responsible for
selecting libc to use libc6-686 to use that. (Bonus points for
renaming libc6-686 to something more suitable. libc6-cmov?)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
