Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbXIQRSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbXIQRSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbXIQRS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:18:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:8199 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbXIQRS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QPAtcxyGGogoo5W8G9kgVJQPMnqxV73kLVZgUUjRcjXRnJNWe9VSXYsxDUKYAcCUJ5uHjbvUo7/V5dxz39J+N4PGNiqI75kG0vxHchUNyzIJRVhUhQe9savz336xFdzh0BFlWFIXvoqvvK/vN0OdYuhi0/BK5gw/QlWSmLFonNk=
Message-ID: <f19298770709171018x6c4a150yfe6e490d7cc1721b@mail.gmail.com>
Date: Mon, 17 Sep 2007 21:18:26 +0400
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Sergey Dolgov" <dolgovs@gmail.com>
Subject: Re: ata_piix, laptop cdrom, ICH7: EH, limiting speed to PIO
Cc: "Tejun Heo" <htejun@gmail.com>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <ac0be4d70709170505l6c4bba29pc8ad1c92fcb16ae9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070911212030.GA2817@slk.laptop>
	 <6bffcb0e0709120933p6d58127fv3c85076fe41daaca@mail.gmail.com>
	 <20070912200706.GA2620@slk.laptop> <46E849B7.9040402@googlemail.com>
	 <20070912212025.GB2620@slk.laptop> <46E8663E.3080205@googlemail.com>
	 <46ED19F0.8060205@gmail.com>
	 <ac0be4d70709170257o62e856f4re049c968ab5590a7@mail.gmail.com>
	 <46EE66EA.3090902@gmail.com>
	 <ac0be4d70709170505l6c4bba29pc8ad1c92fcb16ae9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, Sergey Dolgov <dolgovs@gmail.com> wrote:
> On 9/17/07, Tejun Heo <htejun@gmail.com> wrote:
>
> [...]
> > >>>> BTW, this only happens when using libata of course. The
> > >>>> old CONFIG_IDE stuff works fine every time.
> > >>> This maybe one of libata weirdness (I really don't get it why some hardware
> > >>> works perfectly fine with an old IDE and don't work well with libata).
> > >> Hmmm... Is MWDMA2 mode used with ide driver too?
> > >>
> > >
> > > What's the best way to tell whether it does or not? (the log says
> > > "selected mode 0x22", see below)
> >
> > Yes, that's MWDMA2.  Hmm... We're seeing many cases where MWDMA doesn't
> > work with libata while it works fine with IDE but have no idea what's
> > going on yet.  :-(
> >
>

This may be well a hardware problem. Same laptop (HP nx7300 GB848ES)
works fine with either 2.6.22 and 2.6.23-rc. Maybe actually using the
DVD is required to trigger the problem on the next reboot?

Sergey, btw, on this laptop I've observed lockups twice with the -rc5.
After switching to 2.6.22 it was stable for at least one day. Can you
confirm or refute this?
