Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZERHws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZERHws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZERHwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:52:37 -0400
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:34115 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbZERHwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:52:37 -0400
Subject: Re: regression in 2.6.30-rc6 -- via82xx sound very quiet
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <s5h4ovjeykr.wl%tiwai@suse.de>
References: <1242578874.2748.11.camel@localhost.localdomain>
	 <s5h7i0f7iqo.wl%tiwai@suse.de>
	 <1242592683.2748.24.camel@localhost.localdomain>
	 <s5h4ovjeykr.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Mon, 18 May 2009 08:52:34 +0100
Message-Id: <1242633154.2709.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 08:04 +0200, Takashi Iwai wrote:
> At Sun, 17 May 2009 21:38:03 +0100,
> Richard Kennedy wrote:
> > 
> > On Sun, 2009-05-17 at 19:16 +0200, Takashi Iwai wrote:
> > > At Sun, 17 May 2009 17:47:54 +0100,
> > > Richard Kennedy wrote:
> > > > 
> > > > In the current git 2.6.30-rc6 the sound from my motherboard has become
> > > > extremely quiet, I have to turn my speakers up all the way to hear
> > > > anything at all.
> > > > I'm not too sure when the problem first started but I've just tested
> > > > 2.6.30-rc4 and it works correctly.  
> > > 
> > > Try to correct "DXS Playback Volume" mixer elements.
> > > The dB range of these volumes were fixed recently to the correct
> > > values.  If the old mixer value is restored using the dB value,
> > > it would be restored to a much lower value, which explains your
> > > symptom.
> > > 
> > > Simply set these volumes to the max (i.e. 0dB) and never change unless
> > > you really need them.
> > > 
> > > 
> > > thanks,
> > > 
> > > Takashi
> > 
> > Hi Takashi,
> > 
> > thanks for that. Yes that works.
> 
> Thanks for checking.
> 
> > I didn't even know I had that control, so I guess this could be a common
> > problem.
> 
> Yes, unfortunately, it would hit to many via82xx ac97 chips.
> As the original value was wrong, it can't be corrected so easily from
> the driver side.  Manual corrections seem needed, but just only once.
> 
> 
> Takashi

Yes it's easy to do.
But it would be nice if we could give the users a hint as to what's gone
wrong. Would it be ok to add a log message at startup ? 

something like "your DXS volume control may need reseting".

I'm not sure how much of this hardware is out there, but it may help
reduce the number of bug reports.
 
regards
Richard


