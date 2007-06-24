Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbXFXD24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbXFXD24 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 23:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXFXD2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 23:28:48 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:32102 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbXFXD2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 23:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KliiKmEMm5ElFvGK2ZaQzQVsbDnxLDy2R1YxVBqTDqWQvxbRlBf+CTtj9tpkKlZbIFaPSd7Uxyr1ZQIFmKIV/l3R57F2J36wLCsjqFB2D1fzIqPGgdKcv7dN2ow14JAiV8Va6795mlx9EzlQcjPaxIk+QaHJIdUxfxT4nkrwJLo=
Message-ID: <a781481a0706232028ie3b6277u65ba4c6bbc773f5e@mail.gmail.com>
Date: Sun, 24 Jun 2007 08:58:45 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Trent Piepho" <xyzzy@speakeasy.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re: [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Roman Zippel" <zippel@linux-m68k.org>, toralf.foerster@gmx.de,
       "Oliver Neukum" <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Luca Risolia" <luca.risolia@studio.unibo.it>
In-Reply-To: <Pine.LNX.4.58.0706231525130.4914@shell4.speakeasy.net>
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
	 <Pine.LNX.4.58.0706231525130.4914@shell4.speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/24/07, Trent Piepho <xyzzy@speakeasy.org> wrote:
> On Sat, 23 Jun 2007, Satyam Sharma wrote:
> > On 6/23/07, Trent Piepho <xyzzy@speakeasy.org> wrote:
> > > [...]
> > > Now all the usb drivers will gain USB as a dependency directly and can't be
> > > set to something higher than USB.
> >
> > Ok, so we add this as solution 2.(c) to the reply I just sent to Jan :-)
> >
> > But I still prefer 2.(b) -- making the config scripts intelligent so that if a
> > given "menuconfig FOO depends on BAR", then all the "config BAZ"s
> > inside this menuconfig also automatically "depend on" BAR too.
>
> Of course, there currently is no "inside" a menuconfig.  You would have to do
> something like make everything inside an "if FOO / endif" gain not just a
> dependency on FOO, but also gain a dependency on all of FOO's dependencies.

Yes, making the config scripts do what you describe there
automagically is exactly what I meant there.

> > This is simpler in the long run because it requires least amount
> > (actually none) of redundant typing and would continue to work in
> > the future if/when the:
> > [...]
> > configmenu FOO
> > ...
> > endconfigmenu # FOO
> >
> > kind of idiom ...
>
> Like that I suggested here?
> http://article.gmane.org/gmane.linux.kernel/524823
>
> Basically, make menuconfig work like menu does, except the menu itself can be
> turned on and off.  Instead of having menuconfig work like a config, but with
> some kind of "menu" hint.  It seems like the former is more in line with what
> menuconfig is actually used for.

Again, we're in complete agreement here (also like what Jan
mentioned elsewhere on this thread). But then there's often
too much "suggestions" on Kconfig/Kbuild matters on lkml,
but too little code (wonder if that was what got Roman
irritated yesterday). This may be because stuff in scripts/ doesn't
quite get the kind of eyeballs kernel/ or fs/ or even drivers/ gets,
but I guess the only way to get Roman around to our view would
be start submitting patches for the solutions we're all fond of
"suggesting" :-)

Satyam
