Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbXFDU5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbXFDU5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbXFDU5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:57:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43685 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753549AbXFDU5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:57:08 -0400
Date: Mon, 4 Jun 2007 22:57:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Andi Kleen <ak@suse.de>,
       Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Message-ID: <20070604205701.GD2711@elf.ucw.cz>
References: <20070604112426.GA2707@elf.ucw.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz> <200706041543.49071.ak@suse.de> <20070604135427.GA19466@elf.ucw.cz> <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com> <20070604163406.GA1120@khazad-dum.debian.net> <d120d5000706041046j1da16c6el350d9da1d74d508b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000706041046j1da16c6el350d9da1d74d508b@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-06-04 13:46:45, Dmitry Torokhov wrote:
> On 6/4/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> >On Mon, 04 Jun 2007, Dmitry Torokhov wrote:
> >> >...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
> >> >often. Launch the line above and try to do some typing...
> >>
> >> This used to work fine on my box last time I tried it (the switch
> >> itself is offloaded to a keventd and shoud not get in the way) but
> >> then they push all kind of ACPI/SMM crap together with KBC so who
> >> knows... I should try it again when I get home.
> >
> >Err... in laptops, almost *always* the KDC is emulated by the embedded
> >controller, so I bet you're right on the money, there.  It is not "a buggy
> >KDC", it is a buggy EC firmware and/or buggy SMBIOS which is a lot more
> >common.
> >
> >And DoS'ing the EC is very high on the Don't Do That list on a laptop.  If
> >the X60 is only losing keypresses and producing no bigger fireworks, that's
> >outstanding behavior (as far as I trust ThinkPad firmware, anyway).
> >
> >So please throttle anything that might access the KDC way too much (as
> >compared to normal keyboard operation by an user).
> 
> What would be reasonable throttling? Once every 100 ms?

Well... this thread began with me having problems with leds blinking
once per ten seconds. I do not think throttling is going to help.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
