Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbXIENrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbXIENrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbXIENrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:47:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:45715 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbXIENrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:47:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MP5XE7lFeCtaMqFzjgCHcVkEbcYEwSpggFk2JWOJqh5beCUVaA0xKE3PiW4Ltrxqw6z2o5oVNK9ckjNnpuYZ3jBSOiuvf0gjC2iJ7H+ktoXSLoo2LHTINWKLhG81xnvUwKYeKsdIR1eM77r/606fnoVUwuBokUtN80Ry3XKAWYI=
Message-ID: <d120d5000709050647v516d042av3975117c97e6e65d@mail.gmail.com>
Date: Wed, 5 Sep 2007 09:47:15 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.22.6 iPod conflict with PS/2 device.
Cc: "Satyam Sharma" <satyam@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       apiszcz@solarrain.com, "Jiri Kosina" <jkosina@suse.cz>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0709050613260.10967@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708310755210.17987@p34.internal.lan>
	 <alpine.LFD.0.999.0709051513150.23793@enigma.security.iitk.ac.in>
	 <Pine.LNX.4.64.0709050613260.10967@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

On 9/5/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Wed, 5 Sep 2007, Satyam Sharma wrote:
>
> >
> >
> > On Fri, 31 Aug 2007, Justin Piszcz wrote:
> >
> >> When I have an iPod attached via USB to an ABIT IC7-G board before it boots up
> >> and let X start etc, the mouse (PS/2) does not function, but the keyboard
> >> works OK.
> >>
> >> GPM does not work either.
> >>
> >> When I attach the iPod after the machine has booted up, everything is OK,
> >> until the next reboot (with the iPod still attached via USB)
> >
> > Interesting :-) And this happens reproducibly?
> >
> > You see this on 2.6.22.6 right? It'll be useful if you could test latest
> > mainline -git (or -rc5). If you still find this problem, then often the
> > best way to hunt such bugs is to find a previous kernel where this did
> > *not* occur, and then git-bisect ...
> >
> >
> >> Any idea why this happens?
> >
> > CC'es added.
> >
>
> My guess is it will occur with all kernels, it is probably a motherboard
> or IRQ issue and not kernel related.  I have seen a few bugs over 5-6
> years with these boards and this is another that can be added to the
> list.
>

What do you have in your BIOS under "USB Keyboard support" and "USB
Mouse support" (in "OnChip PCI device" section) ?

-- 
Dmitry
