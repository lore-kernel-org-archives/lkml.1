Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbYKXKjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbYKXKjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYKXKjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:39:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34351 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbYKXKjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:39:12 -0500
Date: Mon, 24 Nov 2008 08:39:01 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Brian Phelps" <lm317t@gmail.com>, linux-kernel@vger.kernel.org,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Alexander Shaduri" <ashaduri@gmail.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: kernel BUG at mm/slab.c:601
Message-ID: <20081124083901.4689f301@pedra.chehab.org>
In-Reply-To: <19f34abd0811211726h143c83f6obdfcb97e71fa595f@mail.gmail.com>
References: <ea3b75ed0811181524y7cdad2afl85e0281e293922cc@mail.gmail.com>
	<19f34abd0811191419x3f6981ady7de5bf40f9ae2983@mail.gmail.com>
	<ea3b75ed0811200901p1bd9e746q5b3757dd6114f3bd@mail.gmail.com>
	<19f34abd0811211710q65d6200bt3a145971cd1bc911@mail.gmail.com>
	<19f34abd0811211725s169dc42ao195c61b6dac3e975@mail.gmail.com>
	<19f34abd0811211726h143c83f6obdfcb97e71fa595f@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008 02:26:52 +0100
"Vegard Nossum" <vegard.nossum@gmail.com> wrote:

> [Resend with (I hope) working e-mail address for Mauro]
> 
> On Sat, Nov 22, 2008 at 2:25 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > On Sat, Nov 22, 2008 at 2:10 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> >>> [  527.562373]  ffffffff8043b157 0000000000200200 ffffffffa02810d4
> >>> ffff88001e13c600
> >>
> >> LIST_POISON2 on the stack:
> >>
> >> include/linux/poison.h:#define LIST_POISON2  ((void *) 0x00200200)
> >
> > So looking at bttv source code, I wonder what the codes like these are
> > trying to do:
> >
> >                        if (set->top->vb.queue.next)
> >                                list_del(&set->top->vb.queue);
> >
> > Code is ancient, I'll ask Mauro.

Your patch seemed correct. I'll test it later. Better alto to wait for Brian
updates, since I never saw this bug on my environment.

Cheers,
Mauro
