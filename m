Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbXFDQU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbXFDQU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbXFDQUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:20:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:41328 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757746AbXFDQUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:20:09 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18XyJoWQsQXsPKk2pbquLUZsvFOX6WrLwhJHvNqWW
	n2IYJmbPYj3U29
Date: Mon, 4 Jun 2007 18:20:08 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andi Kleen <ak@suse.de>,
       Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: thinkpad testers wanted (was Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?)
Message-ID: <20070604162008.GA16530@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andi Kleen <ak@suse.de>, Jiri Kosina <jikos@jikos.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20070604112426.GA2707@elf.ucw.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz> <200706041543.49071.ak@suse.de> <20070604135427.GA19466@elf.ucw.cz> <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com> <20070604141345.GB2059@elf.ucw.cz> <20070604150613.GC3363@atjola.homenet> <20070604151025.GD2059@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070604151025.GD2059@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.04 17:10:25 +0200, Pavel Machek wrote:
> Hi!
> 
> > > > >pavel@amd:~$ while true; do setleds +num; setleds -num; done
> > > > >Hm,m so thiis  iis  a teest of fkeyboarad behaviour  under lloadd.
> > > > >
> > > > >pavel@amd:~$
> > > > >
> > > > >...but I'm not quite sure it is a buggy keyboard. It happens _way_ too
> > > > >often. Launch the line above and try to do some typing...
> > > > 
> > > > This used to work fine on my box last time I tried it (the switch
> > > > itself is offloaded to a keventd and shoud not get in the way) but
> > > > then they push all kind of ACPI/SMM crap together with KBC so who
> > > > knows... I should try it again when I get home.
> > > 
> > > Hmm, this needs to be ran from console (not X). Can someone with
> > > thinkpad try this?
> > 
> > The version that doesn't sleep totally messes up keyboard input on my
> > T43. Some keypresses are totally ignored and the keys that are part of
> > the "numpad" sometimes generate crap, e.g. holding down "j"
> > results in j, 1 or ^[[4~
> 
> Ok, I did not want to focus on "numpad" keys. Even normal keys
> misbehave for me, like being lost or duplicated. Strange.

That also happens here. The numpad keys were a special case, sorry if I
didn't make that clear enough.

Björn
