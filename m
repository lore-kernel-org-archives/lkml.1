Return-Path: <linux-kernel-owner+w=401wt.eu-S1760847AbYJJWNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847AbYJJWNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbYJJWM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:12:59 -0400
Received: from kroah.org ([198.145.64.141]:42849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754504AbYJJWM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:12:59 -0400
Date: Fri, 10 Oct 2008 15:09:38 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Stefan Bader <stefan.bader@canonical.com>,
       stable@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in
	used_vectors bitmap
Message-ID: <20081010220938.GB12671@kroah.com>
References: <48EFB4B2.2020508@canonical.com> <20081010201805.GC32164@kroah.com> <48EFBCA4.6020008@zytor.com> <20081010204133.GB32357@kroah.com> <20081010215038.13be501e@lxorguk.ukuu.org.uk> <20081010211225.GA17695@kroah.com> <20081010224907.480a9aa2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010224907.480a9aa2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 10:49:07PM +0100, Alan Cox wrote:
> > > And more importantly dev->irq == 0 or IRQ == 0 to anything but arch
> > > internal code means "no interrupt line".
> > 
> > I thought we had changed that a while ago, as some arches had 0 as a
> > valid irq line.
> 
> No .. Linus decreed (and I think sensibly myself that IRQ = 0 meant no
> IRQ assigned).. the argument being that in C you naturally write stuff
> like
> 
> 		if (!dev->irq)

Ok, I was confused, thanks.

> I can dig up the reference URLS to the list mails if you want

Nah, I trust you :)

thanks,

greg k-h
