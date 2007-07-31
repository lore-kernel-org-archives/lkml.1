Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbXGaQPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbXGaQPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763965AbXGaQO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:14:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:53045 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761596AbXGaQO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hLD7FFouG8fsMobly90UxyMlIf8D0PBfFNewiIq0Rl2bkq0P1FPYrWfoCAr6nRWKnnh1URPvTzUO/rr5XVHNVwOv6cGBZKQyYdo1qMsYdVH+FE6O1YHD/+JNCaWyK2508YQ+l6F8BsrmDx8dqPDlUypdS5hnXtrDYKEkyeLzEwo=
Message-ID: <b21f8390707310914p435c8b06r878db20f6803cdc6@mail.gmail.com>
Date: Wed, 1 Aug 2007 02:14:55 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Cc: "Kenneth Prugh" <ken69267@gmail.com>, ck@vds.kolivas.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kasper Sandberg" <lkml@metanurb.dk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070731141857.GA22209@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070729170641.GA26220@elte.hu> <20070729204716.GB1578@elte.hu>
	 <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com>
	 <20070730114649.GB19186@elte.hu> <46AE25F3.7020904@gmail.com>
	 <20070730191029.GA29327@elte.hu> <46AE570B.3050802@gmail.com>
	 <20070731094526.GA16300@elte.hu>
	 <b21f8390707310616o1ac04f15r7f84023ca773008e@mail.gmail.com>
	 <20070731141857.GA22209@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Ingo Molnar <mingo@elte.hu> wrote:
> > The only other thing of interest is that the -ck kernel had the WM
> > menus appear in about 3 seconds rather than 5-8 under the other two.
>
> under what load is that - 10 loops? There's no disk or network IO going
> on during a WM menu appearance, correct?

Incorrect.  This is before doing any tests whatsoever, just using the
menu to get to the launcher for nexuiz.  E-17 wants to load up pretty
little icons next to every menu item, and "games" is fourth down the
list of menus... the three above it contain practically everything
else installed on the system (since it includes Applications).
Thanks, debian menu! ;)

So obviously on first load these things aren't cached yet (in E's own
cache), so its madly searching the disk for pretty little icons.
After caching, the games menu pops up in 2 seconds.

For the newly-tested kernel (-ck+sched_yield_hack) it was 4-5 seconds
for initial load, same as CFS normally does for me.  I think the 8
second one was because I got in quick and the system was still running
some startup crap (so I blame disk i/o not the scheduler).  I'll keep
an eye on it just in case, but hardly consider it a regression at this
stage.

Thanks for the other experimentation hints, its always nice to have
that little extra bit of documentation!

-- 
Matt
