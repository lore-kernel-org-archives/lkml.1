Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbXIQMFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbXIQMFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 08:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbXIQMFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 08:05:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:5706 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXIQMFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 08:05:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DBhvNHlNod0hhh2RfhJcoVd1b3lXHqPP1MoFQRf/lQantBTzVdNlqQs7khhp8veQq2Z1wnj2ojRxYfJlc5ctNlNj8UO5mvl9vypK9hrTw6cSJFlEx8Pqza2sJiJaEoqhrrWonTugOmk5IihO+FGAxOsONV5cUtWmPj6DM/4qW40=
Message-ID: <ac0be4d70709170505l6c4bba29pc8ad1c92fcb16ae9@mail.gmail.com>
Date: Mon, 17 Sep 2007 16:05:00 +0400
From: "Sergey Dolgov" <dolgovs@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: ata_piix, laptop cdrom, ICH7: EH, limiting speed to PIO
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <46EE66EA.3090902@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/07, Tejun Heo <htejun@gmail.com> wrote:

[...]
> >>>> BTW, this only happens when using libata of course. The
> >>>> old CONFIG_IDE stuff works fine every time.
> >>> This maybe one of libata weirdness (I really don't get it why some hardware
> >>> works perfectly fine with an old IDE and don't work well with libata).
> >> Hmmm... Is MWDMA2 mode used with ide driver too?
> >>
> >
> > What's the best way to tell whether it does or not? (the log says
> > "selected mode 0x22", see below)
>
> Yes, that's MWDMA2.  Hmm... We're seeing many cases where MWDMA doesn't
> work with libata while it works fine with IDE but have no idea what's
> going on yet.  :-(
>

Okay, thanks. Please feel free to contact me if you need any more testing done.

-- 
Sergey
