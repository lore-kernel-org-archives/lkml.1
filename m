Return-Path: <linux-kernel-owner+w=401wt.eu-S1767826AbXECTn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767826AbXECTn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767827AbXECTn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:43:27 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1512 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767789AbXECTn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:43:26 -0400
Date: Thu, 3 May 2007 21:41:20 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael Schmitz <schmitz@debian.org>
Subject: Re: [patch 04/33] m68k: Atari keyboard and mouse support.
In-Reply-To: <d120d5000705031217h64db0644qb1e8bc8d8af6e78c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705032124020.1479@scrub.home>
References: <20070501195052.390551603@mail.of.borg>  <20070501195129.842338339@mail.of.borg>
  <d120d5000705011346h263bb5c4nb534692c11e7081b@mail.gmail.com> 
 <Pine.LNX.4.58.0705031832450.9408@xplor.biophys.uni-duesseldorf.de> 
 <Pine.LNX.4.64.0705031917150.2956@scrub.home>
 <d120d5000705031217h64db0644qb1e8bc8d8af6e78c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 3 May 2007, Dmitry Torokhov wrote:

> > I explained already at a earlier occasion, why this "generic" keycode
> > thing is broken by design, which makes connecting multiple keyboards with
> > different mappings impossible.
> > 
> 
> No, I don't think so. Your points were:
> 
> 1) You did not want to adjust your legacy keymap on Amiga

Adjusting wouldn't be really a problem, if it had some value...

> 2) You want userspace programs to know how to program scancodes for
> every type of keyboard and have different keymaps for different type
> of keyboards (So you need to have n_kbd_types *
> n_international_mappings keymaps).

I never said that. Many keyboard _types_ need a separate key mapping.
Localization is a completely different problem (and could be solved via 
separate localization tables).
Most of it can be solved in userspace and we wouldn't have to enumerate 
every possible single key the kernel never cares about in <linux/input.h>.

> As far as 2) goes I think it is better to have unified keyboard map
> across different types of keyboards and then overlay
> internatinalization/other settings. And you still have per-keyboard
> configurability as you can change scancode->keycode mapping on a
> per-device basis via evdev ioctl.

You still completely ignore the problem of how said application should 
properly support multiple keyboard mappings...

bye, Roman
