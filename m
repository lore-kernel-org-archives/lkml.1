Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbXGHMyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbXGHMyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 08:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXGHMyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 08:54:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51098 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbXGHMyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 08:54:35 -0400
X-Sasl-enc: JpUMSLTt69vV1XfAJeOPTQtTBvn+xRpfjnavNjSSxk/B 1183899274
Date: Sun, 8 Jul 2007 09:54:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Carlo Wood <carlo@alinoe.com>, Tim Hull <thully@umich.edu>,
       Gerald Britton <gbritton@doomcom.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: MacBook makes whining noise when usb-uhci active
Message-ID: <20070708125431.GC30276@khazad-dum.debian.net>
References: <9a7c669e0707071551v2705320dn876ad208fa60a537@mail.gmail.com> <Pine.LNX.4.44L0.0707072210470.10912-100000@netrider.rowland.org> <20070708025457.GA2822@zante.sekrit.org> <20070708042712.GC12052@khazad-dum.debian.net> <9a7c669e0707072141i7d0f6f65r8cdeee908202620d@mail.gmail.com> <20070708115814.GA17462@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070708115814.GA17462@alinoe.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Jul 2007, Carlo Wood wrote:
> The most likely source of a noise as you seem to describe is a
> ceramic capacitor. An alternative is some coil, but that you
> usually only hear in cases where a high frequency is used inside
> a voltage convertor (in order to reduce transformator or coil
> sizes) and I doubt that anything like that is possible in a
> laptop... I'd have the hear the actual sound to know what it is.
> 99% chance it's a ceramic capacitor that has to absorb some
> pulsed current.

Yeah, that looks like the reason behind almost all noises a thinkpad makes
(there are very few reports of noise making it to the audio signal, most of
them really are from the board components).

> If you'd replace the capacitor with another one of a different
> type (same capacity, of course), for example a styroflex one,
> then the noise would go away. It's very difficult to find out
> which it is however ;). The only method that I know is by
> touching each capacitor (ie with pliers) while it is making noise,
> which will cause the sound to change a little if you have the
> right one.

High frequencies are tricky, and they have the nasty side-effect of wearing
down solder joints with time if the joints are not very perfect to begin
with (which IS something to be worried about in ThinkPads, there are
documented issues with bad soldering breaking thinkpads after a few years of
use).  And they can be very difficult to dampen.

Would some sealing non-conductive, non-acid glue work?  Maybe clear epoxy
glue, like the one Microsoft uses in the Xbox to protect against
modchipping?  Or would the high frequency just travel down the solders (and
glue!) to the board, and continue doing its damage and annoying noise?

Replacing SMD components in the thinkpad system board ain't even remotely
easy to do if one needs to change to another type of capacitor...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
