Return-Path: <linux-kernel-owner+w=401wt.eu-S1031378AbXECRfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031378AbXECRfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031385AbXECRfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:35:43 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1354 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031378AbXECRfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:35:42 -0400
Date: Thu, 3 May 2007 19:33:33 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael Schmitz <schmitz@debian.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
In-Reply-To: <Pine.LNX.4.58.0705031832450.9408@xplor.biophys.uni-duesseldorf.de>
Message-ID: <Pine.LNX.4.64.0705031917150.2956@scrub.home>
References: <20070501195052.390551603@mail.of.borg>  <20070501195129.842338339@mail.of.borg>
 <d120d5000705011346h263bb5c4nb534692c11e7081b@mail.gmail.com>
 <Pine.LNX.4.58.0705031832450.9408@xplor.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 3 May 2007, Michael Schmitz wrote:

> > > +       for (i = 1; i < 0x72; i++) {
> > > +               atakbd_keycode[i] = i;
> > > +               set_bit(atakbd_keycode[i], atakbd_dev->keybit);
> >
> > It looks like this driver is not using standard input event codes.

Actually it does, it just sort of works because Atari generates mostly 
AT keycodes.

> > If
> > Roman does not want to adjust keymaps on Amiga and Atari that should
> > be handled in legacy keyboard driver (drivers/char/keyboard.c). As it
> > is programs using /dev/input/eventX have no chance of working.

I explained already at a earlier occasion, why this "generic" keycode 
thing is broken by design, which makes connecting multiple keyboards with 
different mappings impossible. 

bye, Roman
