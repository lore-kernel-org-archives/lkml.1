Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZCRJF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZCRJF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 05:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZCRJFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 05:05:10 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33351 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZCRJFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 05:05:09 -0400
Date: Wed, 18 Mar 2009 10:05:07 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090318090507.GA30453@rhlx01.hs-esslingen.de>
References: <20090316180638.GB25647@rhlx01.hs-esslingen.de> <s5htz5tyzyg.wl%tiwai@suse.de> <20090316212227.GA29471@rhlx01.hs-esslingen.de> <s5hfxhczinh.wl%tiwai@suse.de> <20090317100500.GA16029@rhlx01.hs-esslingen.de> <20090317103845.GA26007@rhlx01.hs-esslingen.de> <20090317104755.GA1446@rhlx01.hs-esslingen.de> <s5h3adcpf1i.wl%tiwai@suse.de> <20090317161828.GA32756@rhlx01.hs-esslingen.de> <s5h3adbhovj.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h3adbhovj.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 17, 2009 at 09:32:16PM +0100, Takashi Iwai wrote:
> At Tue, 17 Mar 2009 17:18:28 +0100,
> Andreas Mohr wrote:
> > I had the same thoughts later. Since they use an extensive SAM handling
> > library, there probably isn't such a chip, otherwise they probably
> > wouldn't need it ;)
> > Could you thus implement a nice beam-forming sound evaluation SAM
> > library for ALSA pretty pretty please? ;)
> 
> A patch please :)

Not at the moment at least, sorry. But that would make for a nice
little (student?) project (or not so little).

> Don't use -Dplughw:0.  Then the default setup will be used.
> 
> 	% arecord -fdat -c1 test.wav

Tried that, didn't help. /usr/share/alsa/cards/HDA-Intel.conf still
contains the patch, but equal Capture Volume sliders still silenced
audio input, whereas non-equal worked. Hmm.

Andreas
