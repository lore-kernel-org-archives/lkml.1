Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbYKIUJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbYKIUJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbYKIUJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:09:34 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52505 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897AbYKIUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:09:31 -0500
Date: Sun, 9 Nov 2008 21:09:29 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20081109200929.GA29333@rhlx01.hs-esslingen.de>
References: <s5h3ai11dpt.wl%tiwai@suse.de> <20081109151323.GA18705@rhlx01.hs-esslingen.de> <s5h7i7c916e.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h7i7c916e.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 07:58:17PM +0100, Takashi Iwai wrote:
> At Sun, 9 Nov 2008 16:13:23 +0100,
> Andreas Mohr wrote:
> > OK, _THIS_ time I actually did get the correct model (last time I tried
> > modprobe with model=acer-aspire, but apparently it then used the
> > /etc/modprobe.d/ model=toshiba setting, since this time gamix showed
> > entirely different controls with i-Mic etc.) - all the more reason to
> > log the model name chosen/selected by the driver!!
> 
> Build with the debug option (why turned off even if you *are*
> debugging?).  Then the driver will show you details.

Hmm, right, that would have been an (very useful) option, but not for the
majority of users OTOH.
Especially since this is a user-visible module parameter which should thus
be confirmed in mainstream user code, via logging.
Admittedly not many modules log their settings during startup,
but for snd_hda_intel with its two myriads of codec/machine variants
and a resulting quarter myriad of issues that would be very useful.

> > --> I have to admit that usability sucks^Hcould be a lot better.
> 
> One would call it rather debuggability than usability.
> These are completely different things.

See above ;)

> > i-Mic on Ekiga with lotsa mixer fiddling didn't work either this time.
> 
> OK, then something is missing.  But you should test by arecord first
> than any complicated applications as a primary test.

Good point, will do.

Oh, and is there a way to manually alter codec registers?

> Anyway, the acer-aspire support code was written by Realtek guys, so
> it'd be best to ask them...

Indeed, and far too late (they have submitted it in September I think)
for guaranteeing non-problematic hardware behaviour...
(I'd guesstimate the Realtek submission to be based on Acer activity)
Anyway, still very nice to see that companies do submit patches after all.

Thanks,

Andreas
