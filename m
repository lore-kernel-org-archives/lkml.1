Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYLaN70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYLaN70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbYLaN7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:59:17 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50190 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbYLaN7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:59:17 -0500
Date: Wed, 31 Dec 2008 14:59:15 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Bob Copeland <me@bobcopeland.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Message-ID: <20081231135914.GA31780@rhlx01.hs-esslingen.de>
References: <1230641016.5770.5.camel@maxim-laptop> <20081231091845.GA2516@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231091845.GA2516@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 31, 2008 at 10:18:45AM +0100, Andreas Mohr wrote:
> Hi,
> 
> > Sure, will test, I am also sure that this will work.
> 
> A110L, 2.6.28, success (also inverted here, traffic blanks it).
> 
> Note that CONFIG_LEDS_TRIGGER_DEFAULT_ON=m, might be related
> (possibly ath5k is just mis-using LEDs API, in light of this setting?).

Nope, genuinely inverted,  modprobe ledtrig-default-on and
# echo default-on > /sys/class/leds/ath5k-phy0\:\:*x/trigger
actually blanks the LED.
ledtrig-heartbeat exhibits a weird inverted but actually heartbeat-like pattern,
too.

IOW, our hardware _is_ inverted for real I believe and the driver needs
to be fixed.

Oh, and what about the second LED on the left side? That one would be
available for driver implementation, too, right?
Or is that one hard-wired (via Embedded Controller?)
to rfkill mechanical switch?

(default use for those two would then be rfkill / Rx/Tx triggers, right?)

Andreas Mohr
