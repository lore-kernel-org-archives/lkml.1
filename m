Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbZGIJvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbZGIJvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 05:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759143AbZGIJu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 05:50:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52379 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757930AbZGIJuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 05:50:55 -0400
Date: Thu, 9 Jul 2009 10:51:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tridge@samba.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090709105118.5f8a985f@lxorguk.ukuu.org.uk>
In-Reply-To: <19029.29008.522539.547122@samba.org>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<1247066878.4159.153.camel@mulgrave.site>
	<20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
	<1247069202.4159.212.camel@mulgrave.site>
	<20090708171848.21633768@lxorguk.ukuu.org.uk>
	<19029.29008.522539.547122@samba.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you explain what standard you think should be applied to patent
> workaround patches for them to be acceptable? I'd like to know if
> there is the possibility of us finding some agreement in the future or
> not.
> 
> For example, some possibilities might be:
> 
>   1) no patent workarounds allowed in upstream kernel at all

I have no problem with working around alleged patents

>   2) the workaround must be shown to have 100% compatibility with all
>   current and possible future devices

If we have a workaround that is truely compatible with stuff and has no
real impact then I am all for applying it.

>   3) the workaround must be shown to have a high degree of
>   compatibility with all the devices we have available to test with

IFF the workaround can be turned off for non problem parts of the world
IFF we can define what the failure models are

That bit is critical

>   4) the workaround must have the highest degree of compatibility that
>   we can achieve with the most used devices, but some degree of
>   interoperability problems are OK for less used devices.

At this point we get into last resorts. I don't believe unpredictable
interoperability problems are acceptable, especially for file systems.

To give an example of the reverse case, a video decoder for some web
sites that only played most but not all content of that format wouldn't
worry me. Why - because the failure case is defined ("Sorry can't play
that because of patents" dialogue box) and there isn't a real risk of
loss.

> There are lots of possible levels in between these of course. I don't
> think you are advocating (1) or (2), as you seem happier with the "no
> long name creation" patch from May.

I am. For the simple reason that

	cp importantstuff.doc /media/wibble
	umount; eject

go to random other system and access the document has to be a reliable
process and it is far better to get the error copying (and use a
shortname) than to arrive at the other end of an eight hour flight to
find your document is invisible on the recipient system. Hence the focus
on definable the failure case. We wouldn't apply an fs patch that
randomly vanished files from some systems, and you wouldn't apply a SAMBA
patch that made documents vanish from some systems without apparent logic.

> I apologise if you don't think this is a reasonable way to phrase the
> question. As you are the most vocal opponent of the patch, I'd like to
> better understand what it would take for you to find a patch
> acceptable.

I want to find an elegant solution to this, that is reliable, safe for
users and doesn't mislead. If asking multi-choice questions like that
helps keeps going the right way carry on.

