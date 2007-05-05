Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbXEEP1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbXEEP1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbXEEP02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:26:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:56525 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbXEEPY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:24:58 -0400
Message-ID: <74d0deb30705050639s4166a2acm5fd0947c5c1a8cb8@mail.gmail.com>
Date: Sat, 5 May 2007 15:39:40 +0200
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: cbou@mail.ru
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class (was: battery class)
Cc: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>, "Greg KH" <gregkh@suse.de>,
       "David Woodhouse" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       "Shem Multinymous" <multinymous@gmail.com>,
       kernel-discuss@handhelds.org
In-Reply-To: <20070505123230.GA6460@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070503213139.GC20067@zarina>
	 <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com>
	 <20070505035413.GB21359@khazad-dum.debian.net>
	 <20070505123230.GA6460@zarina>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Anton Vorontsov <cbou@mail.ru> wrote:
> Hello Henrique, Shem,
>
> On Sat, May 05, 2007 at 12:54:13AM -0300, Henrique de Moraes Holschuh wrote:
> > On Fri, 04 May 2007, Shem Multinymous wrote:
> > > >+enum power_supply_type {
> > > >+       POWER_SUPPLY_TYPE_BATTERY = 0,
> > > >+       POWER_SUPPLY_TYPE_UPS,
> > > >+       POWER_SUPPLY_TYPE_AC,
> > > >+       POWER_SUPPLY_TYPE_USB,
> > > >+};
> > >
> > > How about dumb (non-USB) DC power? Any reason to distinguish it from AC?
> >
> > Hmm, if it should not be distinguished, it is better to rename AC to
> > something that means continuous power.  But I'd rather have it AC and DC, as
> > something might have both supplies separate, and you might want to
> > differentiate them for some (human interface) reason.  After all, USB and DC
> > are not really different anyway...
> >
> > Anyway, what IS the difference between UPS and battery, or UPS and AC/DC for
> > that matter?  When should UPS be used?  If you have UPS there, should not
> > MGG (motor-generator group) also be provided?
> >
> > Given that USB-power *is* usually also "dumb" (i.e. it doesn't do any
> > control signaling over the USB bus for power-control purposes), IMHO it
> > might be better to have just battery, AC and DC as types.  And a primary and
> > secondary notion too, as that is common.  It would be generic.
> >
> > Or maybe I just didn't get the idea behind the "type" attribute :-)
> >
> > I'd appreciate if these were documented in the text file.
>
> I think I got the start point of confusion. It's indeed bad to call such
> power supply type as AC. Maybe I should it rename to ADAPTER? Or WALL?

or MAINS?

> type, is really `type' of power supply: imagine icon GUI application will
> use for different types. Type is not alternating/direct current stuff,
> it will be better to impelemnt `current_type' attribute for such matter.
>
> As for Battery/UPS difference.. yes, they're quite similar.. but again,
> imagine laptop with battery, and connected to UPS. ;-) How userspace
> will differ internal battery from UPS? Yup, by type attribute. I hope
> it makes sense... If not, we simply can remove UPS type.
>
>
> And again, much thanks for your review and ideas!
>
> --
> Anton Vorontsov
> email: cbou@mail.ru
> backup email: ya-cbou@yandex.ru
> irc://irc.freenode.org/bd2
> _______________________________________________
> Kernel-discuss mailing list
> Kernel-discuss@handhelds.org
> https://handhelds.org/mailman/listinfo/kernel-discuss
>
