Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbXEZJbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbXEZJbY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 05:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbXEZJbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 05:31:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4893 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753592AbXEZJbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 05:31:14 -0400
Date: Fri, 25 May 2007 10:42:54 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Nitin Gupta <nitingupta910@gmail.com>
Cc: Richard Purdie <richard@openedhand.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael-Luke Jones <mlj28@cam.ac.uk>, linux-kernel@vger.kernel.org,
       linux-mm-cc@laptop.org
Subject: Re: [RFC] LZO de/compression support - take 3
Message-ID: <20070525104253.GA4555@ucw.cz>
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com> <0F6CEFD7-86F2-4903-B4F7-F723DF88BE9A@cam.ac.uk> <4cefeab80705230439n6bbb1259le3c3b9704ce49b75@mail.gmail.com> <624FD7A7-5552-415F-96D8-4353453EA2A3@cam.ac.uk> <4cefeab80705230703vdb3c414s250a61c4c2d70c51@mail.gmail.com> <1CF43BBC-79EF-449B-A398-AE374E399573@cam.ac.uk> <4cefeab80705230721i492b5f1ehfa2d775344b1c04e@mail.gmail.com> <20070523091601.f8c6b833.akpm@linux-foundation.org> <1179938960.5864.26.camel@localhost.localdomain> <4cefeab80705232104n54b23b9bi8b5db8e6a6dd1c0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cefeab80705232104n54b23b9bi8b5db8e6a6dd1c0a@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Perhaps you have opinion of maintaining diffability with 
> original LZO
> code which differs from mine. Since the code is now just 
> ~500 lines it
> should be fair enough to have major overhauls for sake 
> of clean
> KernelStyle(tm) code. It shouldn't be that hard to 
> verify this small
> code for bugs that might have crept in during porting 
> work. As regard
> to keeping up with future LZO versions, hm.... that will 
> be hard - but
> I don't think algorithm itself will change and 
> optimizations can
> always be done separately in this fork.
> 
> >
> >> I'd agree with the proposed renaming.  In fact I'd 
> >suggest that the unsafe
> >> APIs just be removed - it's hard to imagine a 
> >situation in which they're OK
> >> to be used in the kernel.
> >
> >The compressed cache code might be one exception since 
> >it does the
> >compression itself and shouldn't get corrupted. If it 
> >does get
> >corrupted, you have bigger problems.
> >
> 
> Yes. Compressed Caching is one of cases where compressed 
> data cannot
> get magically corrupted. Hence, there is no need to go 
> for the 'safe'
> version. There might be other such cases too, so 
> removing 'unsafe'
> version is not good.

What is the performance difference between safe and unsafe version?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
