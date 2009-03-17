Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbZCQQSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbZCQQSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbZCQQSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:18:32 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:49379 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbZCQQSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:18:31 -0400
Date: Tue, 17 Mar 2009 17:18:28 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090317161828.GA32756@rhlx01.hs-esslingen.de>
References: <20090316173000.GA25647@rhlx01.hs-esslingen.de> <s5hiqm9pe1g.wl%tiwai@suse.de> <20090316180638.GB25647@rhlx01.hs-esslingen.de> <s5htz5tyzyg.wl%tiwai@suse.de> <20090316212227.GA29471@rhlx01.hs-esslingen.de> <s5hfxhczinh.wl%tiwai@suse.de> <20090317100500.GA16029@rhlx01.hs-esslingen.de> <20090317103845.GA26007@rhlx01.hs-esslingen.de> <20090317104755.GA1446@rhlx01.hs-esslingen.de> <s5h3adcpf1i.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h3adcpf1i.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 17, 2009 at 12:25:13PM +0100, Takashi Iwai wrote:
> At Tue, 17 Mar 2009 11:47:55 +0100,
> Andreas Mohr wrote:
> > > Fortemedia device names include FM2018-380, not sure yet which one is in
> > > Aspire One.
> > > 
> > > http://www.fortemedia.com/products/index.htm
> > > ( especially http://www.fortemedia.com/products/fm1182.htm )
> > 
> > http://www.wpgholdings.com/event/S/SACg_04_ForteMedia_SAM.pdf
> > mentions "FM201x" and www.sacg.com.tw (this one could be useful!).
> > Searching Google "FM201[0-9] Fortemedia" comes up with FM2010 and
> > FM2018 and thus
> > http://www.hengdasheng.com.cn/uploadfile/391/cfile/2008102414057847.pdf
> > which is a relatively informative datasheet.
> 
> I'm not sure whether FM2018 is on a netbook.  Rather my guess is it's
> a digital-mic component by FortMedia together with their software
> library for SAM handling.

I had the same thoughts later. Since they use an extensive SAM handling
library, there probably isn't such a chip, otherwise they probably
wouldn't need it ;)
Could you thus implement a nice beam-forming sound evaluation SAM
library for ALSA pretty pretty please? ;)
...or, is that SAM library available to us given that it exists in the
factory install? If so, then one should probably make good use of it...

> BTW, a simple "fix" for the mono capture problem, you can patch
> the config file for HD-audio in alsa-lib like below.  Then the first
> channel will be used for mono capture instead of averages.
> Give it a try.
> 
> (But, this won't fix programs that prefer "hw" access such as
>  pulseaudio, of course.)

I'm not *quite* sure whether this is really what you meant,
but I patched /usr/share/alsa/cards/HDA-Intel.conf (libasound2
1.0.18-1ubuntu7) in exactly this way and then did
arecord -Dplughw:0 -fdat -c1 test.wav; aplay test.wav
but well, with equal slider positions there was no audio again.

Andreas
