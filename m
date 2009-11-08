Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760AbZKHRhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbZKHRhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZKHRhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:37:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48197 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZKHRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:37:10 -0500
Date: Sun, 8 Nov 2009 18:37:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matteo Croce <technoboy85@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091108173708.GF1372@ucw.cz>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-11-06 23:18:06, Matteo Croce wrote:
> On Fri, Nov 6, 2009 at 5:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 11/06/2009 06:59 AM, Matteo Croce wrote:
> >> indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction (NOPL).
> >
> > MMX and MMXEXT are hardly hallmarks of i686, which leaves only cmov.
> > I'm somewhat wondering about the general value of this patch; is i686
> > code really that much faster on Geode that it's worth it?
> >
> > ? ? ? ?-hpa
> >
> > --
> > H. Peter Anvin, Intel Open Source Technology Center
> > I work for Intel. ?I don't speak on their behalf.
> >
> >
> 
> yes, I did some test like gzip, bzip2, lame etc and they give more or less
> the same results of dhrystone
> 
> root@alix:/usr/src# CFLAGS='-march=i586' ./dry.c
> Microseconds for one run through Dhrystone:        1.4
> Dhrystones per Second:                          740741
...
> root@alix:/usr/src# CFLAGS='-march=i686' ./dry.c
> Trying 5000000 runs through Dhrystone:
> Microseconds for one run through Dhrystone:        1.2
> Dhrystones per Second:                          841751

Teach gcc that geodelx exists? No need to break kernel for that... and
you probably can gain even bigger gains.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
