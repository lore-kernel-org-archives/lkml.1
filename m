Return-Path: <linux-kernel-owner+w=401wt.eu-S932643AbXGSUYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbXGSUYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760362AbXGSUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:24:15 -0400
Received: from www.osadl.org ([213.239.205.134]:48962 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759641AbXGSUYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:24:14 -0400
From: =?iso-8859-15?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/3] UIO: Hilscher CIF card driver
Date: Thu, 19 Jul 2007 22:24:09 +0200
User-Agent: KMail/1.9.5
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20070718232332.GA4620@kroah.com> <200707192128.45595.hjk@linutronix.de> <Pine.LNX.4.64.0707192201260.31013@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707192201260.31013@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707192224.09062.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 19 Juli 2007 22:02 schrieb Jan Engelhardt:
> 
> On Jul 19 2007 21:28, Hans-Jürgen Koch wrote:
> >Am Donnerstag 19 Juli 2007 18:33 schrieb Jan Engelhardt:
> >> On Jul 18 2007 16:26, Greg Kroah-Hartman wrote:
> >> >
> >> >http://www.tglx.de/private/hjk/cif-orig-2.6.tar.bz2
> >> >
> >> >WARNING: Don't look at the code for too long, you might become sick :-)
> >> 
> >> Taking precautions for people? I get a 404...
> >
> >Now it's there.
> 
> aaaa, my eyes... ("Microsoft" is a good summary of the codingstyle...)

It's not just coding style, it's also concept. This was written with
the only goal to get a card working at one particular time. What happens
in future is not important. Would you like to port this driver to 2.6.22?
Would you like to post it on lkml, signed-off by you?

The concept is bad because the authors of that driver never tried to
find out how a driver should look like and what has to be done to get
it into mainline. Allright, with such a big driver for a relatively
unknown card(?) it's not easy to include that in mainline. That's
why we now have UIO... It greatly simplifies tasks like that.

I really hope that UIO will soon be used for industrial cards like
this one, and that we can fill drivers/uio/ with lots of small
kernel modules. And yes, these programmers in industry who wrote
drivers like the above, they will still be doing what they want and
what they're able to. But, hopefully, they'll now do it in userspace.

Thanks,
Hans
 
