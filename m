Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbZIFDCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbZIFDCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 23:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZIFDCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 23:02:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753866AbZIFDCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 23:02:51 -0400
Date: Sat, 5 Sep 2009 20:02:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH v2] viafb: 2D engine rewrite (and
 viafb patches in general)
Message-Id: <20090905200233.8819cc95.akpm@linux-foundation.org>
In-Reply-To: <4AA3048D.2090605@gmx.de>
References: <1251666438-5448-1-git-send-email-FlorianSchandinat@gmx.de>
	<1252097032-3568-1-git-send-email-FlorianSchandinat@gmx.de>
	<20090905161645.74a49a84@bike.lwn.net>
	<20090905160140.7b36527f.akpm@linux-foundation.org>
	<4AA3048D.2090605@gmx.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Sep 2009 02:38:37 +0200 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> >>  I'm going to be doing some work here (writing a
> >> driver for the video capture engine), and there's patches sitting in
> >> Harald's tree and the OLPC tree.
> > 
> > As far as the rest of the world is concerned, that stuff doesn't exist.
> 
> I'll try to sort out the patches that still add anything to my stuff. I 
> know Harald's tree and I know that I probably broke every of his 
> patches. However, he seems to not have done anything for about 3 months 
> so I rebased/rewrote my patches on linux-2.6 and started sending. I 
> guess in the meantime I obsolated about half of his patches but there 
> are still some things I'd like to have (PCI rework, VX855/OLPC support). 
> Although I'm a bit unsure how to take these things, fix them to apply on 
> top of my changes and correctly give the original author credit for it.

Sure, that works.  Please coordinate with Harald of course, but we do
that sort of thing regularly.

> Do you have a pointer to the OLPC tree?

I don't.

> I'd really like to see VX855/OLPC support in mainline as soon as 
> possible as I consider it a good thing to support "new" hardware early. 
> However even if I am capable to write such support based on Haralds work 
> I don't want to see it in mainline as long as no one with that hardware 
> tested it.
> 
> >>  It seems like a central merge point
> >> might be a nice thing to have.
> >>
> >> I'd be happy to run such a tree.  I'm really *not* qualified to be
> >> passing judgment on patches to the framebuffer driver at this point,
> >> though, so I'm not sure that I'm the best person for the job.
> > 
> > Send 'em over.  I haven't heard anything from the original viafb
> > submitters for a long time.  Hopefully Florian has time to help out
> > with some review-n-test.
> 
> I do not object against a tree that collects all viafb patches, I even 
> could do it. But one should really send the patches to Andrew ASAP as 
> otherwise we may end up with a dead forest ;)
> Actually it would be very nice to see some more activity around viafb. 
> It might be bad if I'm the only one who patches it and who knows how it 
> works. Discussion can be quite inspiring.
> 
> I'll do the things I can. But in the next few weeks I'll be probably a 
> bit short on time. Okay I guess I won't do any big patches for a while 
> but wait until some patches advance or receive some comments. So I still 
> have some time to review-n-test but expect some delay. In the long run 
> my test platform might become better as I'll be able to 'revive' some 
> old VIA boards currently not available for testing.
> 

Sounds good, thanks.  Things appear to be going OK from where I sit
(famous last words ;))

