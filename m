Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbZGVOz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbZGVOz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZGVOzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:55:55 -0400
Received: from d1.icnet.pl ([212.160.220.21]:34807 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZGVOzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:55:54 -0400
Message-ID: <4A672868.6040502@tis.icnet.pl>
Date: Wed, 22 Jul 2009 16:55:36 +0200
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System
User-Agent: IceDove 1.5.0.14pre (X11/20080304)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
       Jonathan McDowell <noodles@earth.li>, Tony Lindgren <tony@atomide.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       e3-hacking@earth.li, Arun KS <arunks@mistralsolutions.com>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [alsa-devel] [RFC] [PATCH 3/3] ASoC: add support for Amstrad
 E3 (Delta) machine
References: <200907220523.01107.jkrzyszt@tis.icnet.pl> <20090722110328.GB7622@sirena.org.uk> <s5hhbx50wwl.wl%tiwai@suse.de> <20090722121925.GE21171@rakim.wolfsonmicro.main>
In-Reply-To: <20090722121925.GE21171@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Jul 22, 2009 at 01:39:22PM +0200, Takashi Iwai wrote:
>> Mark Brown wrote:
> 
>>>> +	/* Setup pins after corresponding bits if changed */
>>>> +	if ((bool)snd_soc_dapm_get_pin_status(codec, "Speaker") !=
>>>> +			(bool)(function & (1 << AMS_DELTA_SPEAKER))) {
> 
>>> Don't like these casts...  why are they needed?
> 
>> Because the right side is the bit operation?
> 
> Ick, yes.
> 
>> The cast doesn't look nice, though...
> 
> Indeed.  I'd suggest rewriting to try to do less in the if statement - a
> helper function seems to be in order here since the same code is
> repeated several times with different pins and bitmasks.

Thanks, I'll rewrite as you suggest.

Janusz
