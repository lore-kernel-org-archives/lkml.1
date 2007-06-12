Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbXFLFmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbXFLFmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXFLFmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:42:15 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:6133 "EHLO
	asav03.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbXFLFmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:42:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmYmAATPbUZKhRO4UGdsb2JhbACHM4gMAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Date: Tue, 12 Jun 2007 01:42:12 -0400
User-Agent: KMail/1.9.3
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Andi Kleen <ak@suse.de>,
       Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070604112426.GA2707@elf.ucw.cz> <d120d5000706041046j1da16c6el350d9da1d74d508b@mail.gmail.com> <20070604205701.GD2711@elf.ucw.cz>
In-Reply-To: <20070604205701.GD2711@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120142.13173.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 June 2007 16:57, Pavel Machek wrote:
> On Mon 2007-06-04 13:46:45, Dmitry Torokhov wrote:
> > On 6/4/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > >On Mon, 04 Jun 2007, Dmitry Torokhov wrote:
> > >> >...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
> > >> >often. Launch the line above and try to do some typing...
> > >>
> > >> This used to work fine on my box last time I tried it (the switch
> > >> itself is offloaded to a keventd and shoud not get in the way) but
> > >> then they push all kind of ACPI/SMM crap together with KBC so who
> > >> knows... I should try it again when I get home.
> > >
> > >Err... in laptops, almost *always* the KDC is emulated by the embedded
> > >controller, so I bet you're right on the money, there.  It is not "a buggy
> > >KDC", it is a buggy EC firmware and/or buggy SMBIOS which is a lot more
> > >common.
> > >
> > >And DoS'ing the EC is very high on the Don't Do That list on a laptop.  If
> > >the X60 is only losing keypresses and producing no bigger fireworks, that's
> > >outstanding behavior (as far as I trust ThinkPad firmware, anyway).
> > >
> > >So please throttle anything that might access the KDC way too much (as
> > >compared to normal keyboard operation by an user).
> > 
> > What would be reasonable throttling? Once every 100 ms?
> 
> Well... this thread began with me having problems with leds blinking
> once per ten seconds. I do not think throttling is going to help.

For what it worth I finally tried that setleds loop on my laptop. I am
not getting any lost keypresses/releases. But then I don't have EC
(or at least it is not exported via ACPI). This is an old Dell notebook.

-- 
Dmitry
