Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZANKOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZANKOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZANKOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:14:09 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:37394 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZANKOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:14:08 -0500
Date: Wed, 14 Jan 2009 11:14:43 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel HD audio in 2.6.28
Message-ID: <20090114101443.GC2847@ics.muni.cz>
References: <20090113191743.GA2847@ics.muni.cz> <s5hiqoifdo4.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hiqoifdo4.wl%tiwai@suse.de>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 14 Jan 2009 11:14:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:19:07AM +0100, Takashi Iwai wrote:
> "Mic Playback Switch" doesn't control the internal mic.  It's only for
> the mic jack.  You should be able to mute "Internal Mic Playback
> Switch", and this should be irrelevant from the capture path.
> 
> Make sure that your mixer app does anything strange...

I figured it out. I can choose input source as Internal, Dock, Mic, Mix. If
I choose Mix, the Internal Mic in playback cannot be mute otherwise nothing is
captured by an application. If I choose Internal, the Internal Mic in playback
can be mute and applications still record from sound from the internal
microphone.

Is this expected?

So: Input source = Internal = muting Internal Mic (in playback) works fine.
    Input source = Mix = muting Internal Mic (in playback) stops recording
                        from the internal mic for applications.

If this is not expected, I send those alsa-info files. Thanks.

-- 
Luká¹ Hejtmánek
