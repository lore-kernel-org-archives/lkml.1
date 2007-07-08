Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbXGHMCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbXGHMCB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbXGHL5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:57:36 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:31485 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757126AbXGHL5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:57:34 -0400
Date: Sun, 8 Jul 2007 13:58:14 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Tim Hull <thully@umich.edu>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Gerald Britton <gbritton@doomcom.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: MacBook makes whining noise when usb-uhci active
Message-ID: <20070708115814.GA17462@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Tim Hull <thully@umich.edu>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Gerald Britton <gbritton@doomcom.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org
References: <9a7c669e0707071551v2705320dn876ad208fa60a537@mail.gmail.com> <Pine.LNX.4.44L0.0707072210470.10912-100000@netrider.rowland.org> <20070708025457.GA2822@zante.sekrit.org> <20070708042712.GC12052@khazad-dum.debian.net> <9a7c669e0707072141i7d0f6f65r8cdeee908202620d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a7c669e0707072141i7d0f6f65r8cdeee908202620d@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 12:41:55AM -0400, Tim Hull wrote:
> After reading the ThinkPad wiki link, I've found that the problem has
> to do with the C3 and C4 ACPI states.  I'm guessing that the 2.6.18
> kernel I was using on Debian Etch just happened to not support full
> power management on my MacBook - hence, the problem didn't occur.
> 
> Sorry for all of this - I guess I'll pass this info on to Apple and
> see if they may be able to fix this with a firmware update (it occurs
> on OS X too).

The most likely source of a noise as you seem to describe is a
ceramic capacitor. An alternative is some coil, but that you
usually only hear in cases where a high frequency is used inside
a voltage convertor (in order to reduce transformator or coil
sizes) and I doubt that anything like that is possible in a
laptop... I'd have the hear the actual sound to know what it is.
99% chance it's a ceramic capacitor that has to absorb some
pulsed current.

If you'd replace the capacitor with another one of a different
type (same capacity, of course), for example a styroflex one,
then the noise would go away. It's very difficult to find out
which it is however ;). The only method that I know is by
touching each capacitor (ie with pliers) while it is making noise,
which will cause the sound to change a little if you have the
right one.

-- 
Carlo Wood <carlo@alinoe.com>
