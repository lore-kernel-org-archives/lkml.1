Return-Path: <linux-kernel-owner+w=401wt.eu-S2993276AbXDTQNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993276AbXDTQNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993275AbXDTQNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:13:16 -0400
Received: from usul.saidi.cx ([204.11.33.34]:53071 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993276AbXDTQNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:13:15 -0400
Message-ID: <4628E68A.9000809@overt.org>
Date: Fri, 20 Apr 2007 09:12:58 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Madhusudhan c <cr.madhusudhan@gmail.com>
CC: Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org
References: <ff1613620704162359w62df9e0ao6c43215a767bd706@mail.gmail.com>	 <4625DAFC.4000208@drzeus.cx>	 <ff1613620704180453t69585e21h5c31a4fe908d0aac@mail.gmail.com>	 <46262953.3040801@drzeus.cx>	 <ff1613620704190704n2cf37c9dv43536bb8fc0d4c79@mail.gmail.com>	 <462797EE.2050808@drzeus.cx> <ff1613620704200421w1e1aeea5r5acc3a7c0c548b96@mail.gmail.com>
In-Reply-To: <ff1613620704200421w1e1aeea5r5acc3a7c0c548b96@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-I-Got-Here: Yes
X-I-Got-Here: Yes3
Subject: Re: MMCv4 support (8-bit support missing)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Madhusudhan c wrote:
> 
> Suppose a host controller is capable of suporting 8-bit and it tells
> the core that it can support 8-bit. Now the card that is plugged in
> might or might not support 8-bit based on the type of the card. There
> is no field in the ext_csd which will tell you what bus width the card
> can support.

My understanding is that 8-bit support on the card is not optional. ie:
the card is not mmc 4 compliant if it doesn't support 8-bit and this
is why there's no ext_csd field. The only case I could think of where
bus testing would be needed would be if a controller was placed into
a configuration where some pins were deliberately left unconnected
(perhaps because space constraints prevented the extra 4 pins from being
placed on a pcb) and there was no way to change the capabilities reported
by the controller.

But in any case - this is all hypothetical right now - one can't find
a controller in the wild for love or money (well - Arasan will sell you
a validation controller for $5000 but still...). As neither Pierre or
myself is in a position to do any sort of tests on an 8-bit controller,
we can't investigate or verify any of this.

It certainly seems that you have access to an 8-bit controller. If you
can help one or both of us get access to one, I'm sure we could work out
the right thing to do.

--phil
