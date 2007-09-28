Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbXI1Fgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbXI1Fgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 01:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbXI1Fg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 01:36:29 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:21943 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbXI1Fg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 01:36:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GR9oCun58b1GlPy0DAEnMUIpq32waTP+XAeacFRJKTB28DGhiufBGI9vCs+c1UIwBf7Ffdi1lJaBivSV79WFK2Mr0hL8edaFnZHcXm2UpljNjRmaiJm4GIIA2173Wl7b6BnO8QAzhMP+Vk7oxbJipXa1nF5WGFdYASyj6SELQBI=
Message-ID: <64bb37e0709272236g7da8f370lc7f737e908725e88@mail.gmail.com>
Date: Fri, 28 Sep 2007 07:36:26 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46FC1104.8080105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0709261326h4890a07fx60c7d6772e4e63c4@mail.gmail.com>
	 <46FB3793.9060607@gmail.com> <46FB3843.2030708@gmail.com>
	 <64bb37e0709262314x1b0100d8lfe34327db6b9bec8@mail.gmail.com>
	 <46FB4CB3.3090004@garzik.org>
	 <64bb37e0709271034h72b5eb9fy3aa7980cbc483f4f@mail.gmail.com>
	 <46FC1104.8080105@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/27/07, Tejun Heo <htejun@gmail.com> wrote:
> Torsten Kaiser wrote:
> > Known good is for me 2.6.23-rc3-mm1, the first known bad is 2.6.23-rc4-mm1.
> > I will try to look at the diff between these revisions some more, but
> > the change in sata_sil24.c looked like a perfect match for the
> > symptoms I was seeing.
>
> I think the first thing to do here is to verify 2.6.23-rc3-mm1 still
> works fine and my previous debug patch is pretty much meaningless if
> address initialization failure isn't the cause.

After the first trouble with -rc4-mm1 I switched back to -rc3-mm1. I
booted that kernel 7 times over 4 days and never had trouble. (Before
-rc4-mm1 came out, I used -rc3-mm1 for over a week)

So in case of -rc3-mm1 I'm pretty sure that it works.

Not completely sure is if 2.6.23-rc7-sglist kernel works. I booted
that 9 times, but from a quick look in /var/log/messages, I might not
have hit the "correct" situation to trigger the error.
That kernel is vanilla 2.6.23-rc7 plus the patch from
http://www.kernel.org/pub/linux/kernel/people/tomo/misc/v2.6.23-rc7-sglist-arch.diff.bz2
( http://marc.info/?l=linux-ide&m=119055574826083&w=2 )

Torsten
