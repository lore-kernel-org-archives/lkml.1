Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbXFEFaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbXFEFaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 01:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXFEFaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 01:30:08 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:59966 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXFEFaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 01:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NMWEP2rNVdJbFHJgBz1dqifEVtL7xHBbRr5Kvr7Dudoo7ohpbtDoYE4rOYW+3wfY0KocZ2D2xvMdq1bexR6jOiWLgYvMpgcyq4w8m79Xlo4EFRYO6Tp5HAtVo0LiEkZxhgzoeAVSRbo3I0VogAqpeuZsBNe0eZ5PM8cQ0b61oQ4=
Message-ID: <4cefeab80706042230u1fc7f485j30cea371d1d3117a@mail.gmail.com>
Date: Tue, 5 Jun 2007 11:00:05 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
Cc: "Richard Purdie" <rpurdie@openedhand.com>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       LKML <linux-kernel@vger.kernel.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <20070604200606.GA5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1180971378.6313.72.camel@localhost.localdomain>
	 <200706041214.38017.dhazelton@enter.net>
	 <1180975976.6313.133.camel@localhost.localdomain>
	 <4cefeab80706041126y5f12402cl61b72ec101dd7915@mail.gmail.com>
	 <20070604200606.GA5500@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Andrian,

If you really have the opinion of not going for major cleanups,
optimizations outside of original LZO code (basically a fork), then
there is no point in me continuing this work.

If you think otherwise, please let me know and I will post a newer
version with improvements from all these feedback I got.

Thanks,
Nitin


On 6/5/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Mon, Jun 04, 2007 at 11:56:46PM +0530, Nitin Gupta wrote:
> > On 6/4/07, Richard Purdie <rpurdie@openedhand.com> wrote:
> >...
> >> The zlib code isn't kernel style and is arguably bloated, perhaps we
> >> should remove that?
> >
> > I don't know - I don't use zlib.
> > We can make LZO cleaner and perhaps faster. This will be good.
> >...
>
> "cleaner" = much harder to upgrade to new upstream LZO versions -> bad
>
> "perhaps faster" = different from the well-known original code and
>                    might again contain new bugs -> bad
>
> "perhaps faster" = if we fork LZO and actually get it faster, all the
>                    other LZO users will not benefit -> bad
>
>
> zlib and LZO are special because they are maintained userspace code
> imported into the kernel.
>
>
> > Regards,
> > Nitin
>
> cu
> Adrian
>
> --
>
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
>
>
