Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbZF3WrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbZF3WrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbZF3WrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:47:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53299 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227AbZF3WrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:47:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: Problems with snd-hda-intel on hp 6930p (2.6.30)
Date: Wed, 1 Jul 2009 00:47:38 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
References: <200906292037.09597.rjw@sisk.pl> <200906301615.38244.rjw@sisk.pl> <s5h8wj994do.wl%tiwai@suse.de>
In-Reply-To: <s5h8wj994do.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907010047.39525.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 June 2009, Takashi Iwai wrote:
> At Tue, 30 Jun 2009 16:15:37 +0200,
> Rafael J. Wysocki wrote:
> > 
> > On Tuesday 30 June 2009, Rafael J. Wysocki wrote:
> > > On Tuesday 30 June 2009, Takashi Iwai wrote:
> > > > At Mon, 29 Jun 2009 20:37:09 +0200,
> > > > Rafael J. Wysocki wrote:
> > > > > 
> > > > > Hi Takashi,
> > > > > 
> > > > > I have a problem with snd-hda-intel from 2.6.30 on an hp EliteBook 6930p, which
> > > > > is that the sound is not audible, although everything appears to work just
> > > > > fine.  Except maybe that when the box is rebooted and KDE (3.5) is started,
> > > > > the master control is "muted" and the led indicator next to the keyboard shows
> > > > > "no sound".  Then, changing the "muted" status of the master control doesn't
> > > > > change the state of the led indicator and vice versa (the two things appear to
> > > > > be totally independent of each other).
> > > > > 
> > > > > Can you please tell me what I can do to debug this issue?
> > > > 
> > > > Could you run alsa-info.sh with --no-upload option on both "muted"
> > > > and "not muted" states, and attach the generated files?
> > > 
> > > Sure.  In the meantime it turned out that after a power off and cold boot the
> > > status of the master control is 'on', but the led indicator shows 'no sound', so
> > > there are 5 outputs:
> > > * alsa-info-postboot.txt - after power off and cold boot
> > > * alsa-info-led.txt - led indicator switched to 'on' when it was in the
> > >   alsa-info-postboot.txt state
> > > Now I switched to AC power and rebooted the box without powering off:
> > > * alsa-info-muted.txt - initial state with the 'muted' master control
> > > * alsa-info-on.txt - master control switched to 'on' when it was in the
> > >   alsa-info-muted.txt state
> > > * alsa-info.txt - led indicator switched to 'on' when it was in the
> > >   alsa-info-on.txt state
> > > 
> > > > If it's a regression (heh :), please give alsa-info.sh output on
> > > > older kernels.
> > > 
> > > No, it's not a regression.  At least not from 2.6.27.
> > > 
> > > Please let me know if you need more information.
> > 
> > One more thing.  The headphones output actually works regardless of the
> > led indicator status, so only the built-in speakers output seems to be
> > affected.
> 
> How can you turn on/off LED?

There's a button switch attached to it (basically, you press the led and the
status changes :-)).

> From your explanation, it seems not directly bound with the audio mute.

That's correct, it seems independent.

> Anyway, try model=mobile or model=laptop for snd-hda-intel module
> option.  Does the speaker work?

I'll check tomorrow, the box is at my university office.

Thanks,
Rafael
