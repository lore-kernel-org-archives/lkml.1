Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZLODla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZLODla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZLODl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:41:29 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:10772 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbZLODl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:41:28 -0500
Date: Mon, 14 Dec 2009 20:41:27 -0700
From: Alex Chiang <achiang@hp.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, tiwai@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: synaptics touchpad doesn't click
Message-ID: <20091215034127.GC587@ldl.fc.hp.com>
References: <20091214014828.GA28402@ldl.fc.hp.com> <20091214173450.GB2373@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214173450.GB2373@core.coreip.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry, Takashi,

* Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> Hi Alex,
> 
> On Sun, Dec 13, 2009 at 06:48:28PM -0700, Alex Chiang wrote:
> > Hi Dmitry,
> > 
> > I just got a shiny new piece of hardware (HP Envy 15) with a
> > Synaptics touchpad, and I can't seem to make the touchpad work
> > correctly.  In this version of the touchpad, there are actually
> > two physical buttons underneath the pad. In essence, this is a
> > touchpad that you can click too.
> > 
> > I can't get the clicking to work. Of course, I can tap to click,
> > but lacking access to the physical buttons means that I can't
> > right-click.
> > 
> > Currently, I'm not sure if this is a driver issue or perhaps
> > something higher up the stack, perhaps in X or maybe pilot error.
> > ;)
> > 
> > Distro is Ubuntu Karmic, kernel is latest upstream last pulled on
> > 13 Dec.
> > 
> > Would like some pointers on how to get started debugging.
> > 
> > Thanks,
> > /ac
> > 
> > dmesg snip:
> >  Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> >  brd: module loaded
> >  loop: module loaded
> >  input: Macintosh mouse button emulation as /devices/virtual/input/input3
> >  [...]
> >  Synaptics Touchpad, model: 1, fw: 7.4, id: 0x1e0b1, caps: 0xd04771/0xe40000
> >  input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input10
> > 
> 
> Hmm, that's the new Synaptics "clickpad"... Takashi Iwai just posted a
> coupleof patches for it on the input mailing list.

I can't respond to that thread directly because I'm not a
subscriber and can't find the message-id, so just responding
here.

Thanks, I did grab Takashi's patches and verify that they work
for me. I tested the separated patches, not the v2 combined
patch, although it doesn't make any difference based on visual
inspection of v2.

If you want, you can add my:

Tested-by: Alex Chiang <achiang@hp.com>

Thanks!
/ac

