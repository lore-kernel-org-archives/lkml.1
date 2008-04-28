Return-Path: <linux-kernel-owner+w=401wt.eu-S932940AbYD1Jtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbYD1Jtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYD1Jtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:49:31 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38136 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbYD1Jta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:49:30 -0400
Date: Mon, 28 Apr 2008 12:48:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, mingo@elte.hu,
       James.Bottomley@HansenPartnership.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
Message-ID: <20080428094858.GF16379@cs181133002.pp.htv.fi>
References: <20080427231809.GA13848@elte.hu> <20080427.163106.181887129.davem@davemloft.net> <20080428100154.0ac65cb6@core> <20080428.021745.17554887.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080428.021745.17554887.davem@davemloft.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 02:17:45AM -0700, David Miller wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Mon, 28 Apr 2008 10:01:54 +0100
> 
> > > You can post whatever patches you like a million times to lkml.
> > > That's not the problem.
> > > 
> > > It's that the patches don't get reviewed, posting them more or to a
> > > different place doesn't help that.
> > 
> > So review them. Your comments strike me as the pot calling the kettle
> > black given the way the network people like to live on their own mailing
> > list.
> 
> Oh contraire.  Because we networking folks use a seperate mailing list
> with a lower signal to noise ratio than lkml, and as a result more
> specialization, more patches get more review by more specialists.
> 
> It's the point I'm trying to make every time the "post everything to
> lkml" argument gets fronted.
>...

I'd say the best solution is to do both.

Many people active only in some area want to read only stuff affecting 
their area and not linux-kernel that averaged at 525 emails per day in 
February.

But when I have time I skim over patches on linux-kernel, and when I see 
in the diffstat that a Makefile or Kconfig file gets touched I check 
whether I can spot any bugs there (and other people sometimes also spot
bugs in patches for areas they aren't active in).

And starting regression tracking was only possible since most bug 
reports went to linux-kernel, not only to a gazillion different lists.

That's why it might make sense to have everything on both specialized 
lists and linux-kernel.

If it is wanted to reduce the volume on linux-kernel, offloading the 
sending of patches to some new kernel-patches mailing list might be
an option. OTOH, patches and the discussion of patches seems to be
the signal on linux-kernel, not the noise..

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

