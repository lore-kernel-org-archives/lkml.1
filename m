Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbXFVWde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbXFVWde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbXFVWdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:33:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:22846 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbXFVWdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YQ1n1wSXStfezqQhOXz/fEVXcVkARA7p6usa2NOM9tS/P3hOaYnL2E8wmAdqBwz0JqU7+eJYMB5tNiWFqIj7UEHUO+nAkpn52AnCi2/LOCL6xUjXfqCuqoauIJiAJpnRzpNHFznaQY9Uois89TaKZaIjKZQDLDbNlulB1mje6c0=
Message-ID: <a781481a0706221533j34c341c5gf7ff92997e2463a6@mail.gmail.com>
Date: Sat, 23 Jun 2007 04:03:21 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re: [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
Cc: "Trent Piepho" <xyzzy@speakeasy.org>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>, toralf.foerster@gmx.de,
       "Oliver Neukum" <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Luca Risolia" <luca.risolia@studio.unibo.it>
In-Reply-To: <Pine.LNX.4.64.0706230017430.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706211117.55908.toralf.foerster@gmx.de>
	 <200706211231.53898.luca.risolia@studio.unibo.it>
	 <200706211326.45031.toralf.foerster@gmx.de>
	 <200706211350.14526.oneukum@suse.de>
	 <1182518566.14289.20.camel@gaivota>
	 <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
	 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
	 <Pine.LNX.4.64.0706222336210.1817@scrub.home>
	 <a781481a0706221501s4887f88bh3b8cc549deb6886e@mail.gmail.com>
	 <Pine.LNX.4.64.0706230017430.1817@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

On 6/23/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> On Sat, 23 Jun 2007, Satyam Sharma wrote:
>
> > > menuconfig is really a type of config symbol, rather than a type of menu.
> >
> > Well, I'd have to disagree here. A config symbol has code associated
> > with it (at least _all_ config symbols in the kernel originally did, till
> > when these "menuconfig" things got introduced, which is precisely
> > what made them "special").
>
> Only because it's currently used mostly like this, it doesn't add any
> "special" meaning.

But this will always be true (not just currently):

1. Kconfig symbols will always have code associated with them.
That's the entire purpose of Kconfig, is it not?

2. "menuconfig" symbols, otoh, were _invented_ for another reason
entirely: presentation and user interface i.e. so that users are able
to disable entire menus (and all the options contained therein)
without having to enter into the menu first, and without having to
disable all options individually (which was the situation that existed
before the introduction of these menuconfig objects).

The fact that these menuconfig objects are similar to "config symbols"
is only because of the way they got implemented, and has nothing to
do with their original purpose or the problem they try to solve.

Satyam
