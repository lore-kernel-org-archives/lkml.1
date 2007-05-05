Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbXEES6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbXEES6M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbXEES6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:58:12 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:44484 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbXEES5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:57:54 -0400
Date: Sat, 5 May 2007 20:50:38 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: pHilipp Zabel <philipp.zabel@gmail.com>
cc: cbou@mail.ru, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Greg KH <gregkh@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Shem Multinymous <multinymous@gmail.com>,
       kernel-discuss@handhelds.org
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class
 (was: battery class)
In-Reply-To: <74d0deb30705050639s4166a2acm5fd0947c5c1a8cb8@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705052046350.18504@yvahk01.tjqt.qr>
References: <20070503213139.GC20067@zarina>  <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com>
  <20070505035413.GB21359@khazad-dum.debian.net>  <20070505123230.GA6460@zarina>
 <74d0deb30705050639s4166a2acm5fd0947c5c1a8cb8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 5 2007 15:39, pHilipp Zabel wrote:
>> > > > +enum power_supply_type {
>> > > > +       POWER_SUPPLY_TYPE_BATTERY = 0,
>> > > > +       POWER_SUPPLY_TYPE_UPS,
>> > > > +       POWER_SUPPLY_TYPE_AC,
>> > > > +       POWER_SUPPLY_TYPE_USB,
>> > > > +};
>> > > 
>> > > How about dumb (non-USB) DC power? Any reason to distinguish it
>> > > from AC?
>> > 
>> > Hmm, if it should not be distinguished, it is better to rename
>> > AC to something that means continuous power.  But I'd rather
>> > have it AC and DC, as something might have both supplies
>> > separate, and you might want to differentiate them for some
>> > (human interface) reason.  After all, USB and DC are not really
>> > different anyway...
>> > 
>> > Anyway, what IS the difference between UPS and battery, or UPS
>> > and AC/DC for that matter?  When should UPS be used?  If you
>> > have UPS there, should not MGG (motor-generator group) also be
>> > provided?

Sorry for jumping in late... there is basically no way to know whether 
you are on AC or DC, unless you have a *really smart* power supply. 
Embedded or near-embedded devices usually have a "12V DC" connector on 
the mainboard. "Home" use usually requires a small PSU as are common for 
laptops to transform from 230V to whatever is needed. So the mainboard 
technically is always on 12VDC (what could be called "DC"), even if you 
power it up with using the 230VAC->12VDC PSU (what people call "AC").


Jan
-- 
