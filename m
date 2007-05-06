Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXEFSGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXEFSGL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 14:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbXEFSGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 14:06:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48979 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864AbXEFSGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 14:06:10 -0400
X-Sasl-enc: e93rL630ZE96ur/FoeMbU49kB7RbOOesFyQhPGsWbyA1 1178474769
Date: Sun, 6 May 2007 15:06:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: ian <spyro@f2s.com>, kernel-discuss@handhelds.org,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class (was: battery class)
Message-ID: <20070506180604.GA31940@khazad-dum.debian.net>
References: <20070503213139.GC20067@zarina> <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com> <20070505035413.GB21359@khazad-dum.debian.net> <1178372786.3901.4.camel@wirenth> <1609424106.20070505170603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609424106.20070505170603@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 May 2007, Paul Sokolovsky wrote:
> Saturday, May 5, 2007, 4:46:26 PM, you wrote:
> > On Sat, 2007-05-05 at 00:54 -0300, Henrique de Moraes Holschuh wrote:
> >> Given that USB-power *is* usually also "dumb" (i.e. it doesn't do any
> >> control signaling over the USB bus for power-control purposes),
> 
> > it might be dumb, but it is useful to know wether the PDA is charging
> > from usb or mains power. and some devices allow one to switch on / off
> > the ability to charge via usb
> 
>         And USB does have power budgetting requirements, etc. (like
> was already pointed in own of initial review messages). So, USB
> is definitely not the same thing as "dumb DC".

Everything does.  A dumb DC power source is a dumb DC power source.  USB is
no different here, *unless* it is using USB signaling to control the power
link, at which point it is not a dumb DC power source anymore.

There really is no difference beween an AC brick, a DC brick, an AC/DC
brick, or an USB port supplying DC power in a dumb way in a laptop or
handheld: they are all supposed-continous DC power supplies with a maximum
power budget.

But the "GUI should show it differently" part does make sense.  I am not
completely convinced a high number of top-level types is the best way to go
about it, though.  I'd use subtypes, and a comprehensive enough set of
standard types and sub-types, along with a description of exactly what they
are to be used for.  This will make it MUCH easier on the userspace side for
GUI authors, and it will be much better for people to not use the wrong
types when converting to the new class...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
