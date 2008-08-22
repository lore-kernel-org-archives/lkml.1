Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbYHVKDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbYHVKDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYHVKDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:03:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56092 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbYHVKDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:03:45 -0400
Date: Fri, 22 Aug 2008 12:03:44 +0200
From: Pavel Machek <pavel@suse.cz>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ALSA pisses me off
Message-ID: <20080822100344.GG6542@atrey.karlin.mff.cuni.cz>
References: <787b0d920808201939k6b6a4707n73ede33d96df9e74@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <787b0d920808201939k6b6a4707n73ede33d96df9e74@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As the ALSA asoundrc documentation (not available as a man page, grrr...)
> tells me:
> 
> : Warning
> :
> : Neither .asoundrc or /etc/asound.conf is normally required. You should
> : be able to play and record sound without either (assuming your mic and
> : speakers are hooked up properly). If your system won't work without one,
> : and you are running the most current version of ALSA, you probably
> : should file a bug report.
> 
> Well, OK, here you go.
> 
> All I want to do is play some damn audio. All I have is a pair of
> USB speakers. This should be trivial; OSS sound worked perfectly.
> 
> It hasn't been reliable since the "upgrade" to ALSA. It seems I can
> go edit a complicated config file (alsa.conf, w/o man page) if I
> want to make sound work. Of course, this gets overwritten with any
> OS upgrade and, as noted above and obviously expected, sound should
> "just work" without any config file hacking.
> 
> I gather that somebody decided that USB audio should never be selected
> as the default. There are two obvious problems with this. The first is
> that there exist systems that ONLY have USB audio. The second is
> that,

That shoudl work.

> if a user adds USB audio, they probably want to use it! Plugging in a
> USB audio device should take over the audio, much like plugging in a
> set of headphones normally will. The use case may be very similar,
> such

New machines are able to use headphones & internal speakers at the
same time. WIth USB audio, you should be able to play different songs
to both... so no, I don't think kernel should make a decision to just
take over internal sound...

...that said, yes, I believe ALSA is one of most problematic
subsystems. (The next one is 3d graphics)... and yes, it should be
fixed. Going to regular devices (and not alsa card names) would be
welcome first step.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
