Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYFFMH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYFFMH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 08:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYFFMHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 08:07:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3174 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbYFFMHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:07:49 -0400
Date: Fri, 6 Jun 2008 13:07:35 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Geoffrey Wossum <geoffrey@pager.net>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Message-ID: <20080606120733.GB24872@sirena.org.uk>
Mail-Followup-To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
	Geoffrey Wossum <geoffrey@pager.net>, kernel@avr32linux.org,
	linux-kernel@vger.kernel.org
References: <200806050851.47319.geoffrey@pager.net> <200806051000.56969.geoffrey@pager.net> <20080605182409.6285ee4b@hskinnemo-gx745.norway.atmel.com> <200806051210.47986.geoffrey@pager.net> <20080606112915.4b1d5d42@hskinnemo-gx745.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606112915.4b1d5d42@hskinnemo-gx745.norway.atmel.com>
X-Cookie: Non-sequiturs make me eat lampshades.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 11:29:15AM +0200, Haavard Skinnemoen wrote:

> But I would have thought that if you have a PC sound card with an
> on-board i2s bus and a standard codec, you could create a board driver
> by simply hooking the different parts together, possibly with a custom
> i2s bus driver?

If the card has been built in that way then yes, you could do that.

> Geoffrey Wossum <geoffrey@pager.net> wrote:

> >  - I think PC sound cards tend to be black boxes regarding power consumption, 
> > especially those white box cards you can get at Fry's and similar places.   

> Right...so it's a matter of documentation. I suspect those white box
> cards still use cheap, standard hardware under the hood, though maybe
> that fact is pretty well hidden.

There may just not be the control exposed - there's quite a lot of parts
intended for simple applications which may only offer a few bits of
control for things like mute done via setting levels on pins.

> away. For example, a particular AC97 codec chip may be used with a
> different driver depending on whether it's soldered on a PC motherboard
> or some embedded board. That feels wrong to me.

That should really only be required if you're using features which go
substantially outside the AC97 spec (modulo perhaps needing to make
ac97.c glue more stuff together).
