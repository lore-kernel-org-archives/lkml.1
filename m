Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYLBTWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYLBTWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYLBTWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:22:46 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:15801 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbYLBTWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:22:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=trEzlK0MWZ4afcLBnBk5UGBE/CF56/7inT0QPa4as250YIkuQFzjjhCTOSNpDQgvFq
         +hxQNz4A2j2cVki4YaucVev/5dsxmX5GGh6c6J3l/qkJUnrTkBqOkzGTqIb8EenPzGL/
         jV7mosk+E3v84nfaWcnYQj8/h8aj3D/cY85pQ=
Date: Tue, 2 Dec 2008 20:22:39 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       "Michael B. Trausch" <mike@trausch.us>
Subject: Re: Linux 2.6.28-rc7
Message-ID: <20081202202239.3cb899a8@varda>
In-Reply-To: <20081202194907.4eaffc0a@varda>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org>
	<20081202131442.42e7df48@varda>
	<alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org>
	<20081202165637.09984819@varda>
	<alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
	<20081202194907.4eaffc0a@varda>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Tue, 2 Dec 2008 19:49:07 +0100
Alejandro Riveira Fernández <ariveira@gmail.com> escribió:

> El Tue, 2 Dec 2008 08:13:47 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> escribió:
> 
> > 
> > 
> > On Tue, 2 Dec 2008, Alejandro Riveira Fernández wrote:
> 
> [ ... ]
> > 
> > Since you are apparently a git user, and 2.6.28-rc6-00007-ged31348 was 
> > fine, there's really only 270 commits in between that and 2.6.28-rc7. Can 
> > I ask you to bisect for a couple of runs, which would cut it down to a 
> > handful? (Ie you don't even need to do a full bisect, although that should 
> > really only require about 8 reboots).
> > 
> > Just do
> > 
> > 	git bisect start
> > 	git bisect bad v2.6.27
>                        v2.6.28-rc7 <<< 
> > 	git bisect good v2.6.28-rc6-00007-ged31348
> > 
> > and off you go. That would help enormously.
> > 
> > There are very few console-related changes in that range, and the most 
> > notably one is actually radeon-specific so it shouldn't be an issue for 
> > you. I'd _suspect_ bca404afdc5206c3bb30168315ee8a98a579ec65 ("fbdev: fix 
> > FB console blanking"), but quite frankly, it could be something random 
> > that just interacted badly. A bisection would narrow things down.
> 
>  Here you go 
> 
>  [alex@varda:kernel/linux-2.6]$ git bisect bad                                   
> 31168481c32c8a485e1003af9433124dede57f8d is first bad commit
> commit 31168481c32c8a485e1003af9433124dede57f8d
> Author: Al Viro <viro@ftp.linux.org.uk>
> Date:   Sat Nov 22 17:33:24 2008 +0000
> 
[ ... ]


> 
> 
>  That's what i got after the bisection dunno if that helps...


 Well i can tell that reverting this commit did not help :(
I'm building my "good" kernel again to test it... 

> 
> 
> > 
> > 			Linus
