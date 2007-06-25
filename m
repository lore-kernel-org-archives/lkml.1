Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbXFYNtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbXFYNtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbXFYNto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:49:44 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:44326 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796AbXFYNtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:49:43 -0400
Message-ID: <467FC71D.2020706@gmail.com>
Date: Mon, 25 Jun 2007 15:46:05 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: =?UTF-8?B?VG9tYXN6IEvFgm9jemtv?= <kloczek@rudy.mif.pg.gda.pl>
CC: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2007 01:36 PM, Tomasz Kłoczko wrote:

> Please recall history of (for example) esound.
>> From esound README:
> 
> "Esound is an audio mixing server that allows multiple
> applications to output sound to the same audio device."
> 
> It was started in time when most cheap sound cards was without hw mixer.

The same situation as today, that is.

> And .. when today you use ALSA on sound card without hw mixer still all 
> this (past ?) problems are actual.

ALSA mixes by default since something like 1.0.10 (november 2005).

> Look on main reasons developing arts ..

Which started at a time there was no ALSA, has been basically dead for 6 
years now and has at the moment finally been dropped by its last user.

> In documentation many other user space APIs you can find the same or 
> similar reasons. Look .. I'm talkimg about real facts. Your disagreement
> completly ommits *reasons* spending some time on preapare this soud
> APIs.

The "linux audio jungle" picture you posted a link to:

http://blogs.adobe.com/penguin.swf/linuxaudio.png

shows more arrows pointing to OSS than it does to ALSA and with a number of 
those coming from things that existed before there even was an ALSA and yet 
somehow you maintain this userspace audio jungle is ALSA's fault?

The Linux userspace audio situation is improving; since software mixing, 
plain vanilla ALSA is a good, single solution to a majority of uses and 
something like Phonon which is going to arrive later this year seems poised 
to provide a nice high level API, including for people who believe that 
audio is about playing you-got-mail jingles.

The reason we're not there yet is in part _due_ to people maintaining that 
OSS is somehow a valid choice on Linux. Ie:

> ALSA still does not provides good soud devices virtualization for more 
> then one application. Each day I'm using bludy words when I'm try to use
> skype which oppens /dev/mixer after run galeon [ ... ]

/dev/mixer is an OSS device. Recent versions of skype should (as far as I've 
been told) be able to use native ALSA but if you're using an older version 
you get what you asked for. Should the ALSA OSS emulation try its damndest 
to support proprietary, bugridden closed source junk such as skype? Opinions 
probably vary but I'd say yes. Let's not make it, old versions of it at 
that, into the reference application though.

Video is a much more significant problem for desktop Linux than audio is and 
solutions are going to arrive combined as they are both userspace (ie, not 
kernel, not DRI, not ALSA, not OSS) multimedia problems. I have high hopes 
especially for the new technologies that went into KDE4. Haven't payed much 
attention to GNOME though so not sure what they're upto. Non-stellar 
cooperation between those two large desktop initiatives in the field of 
multimedia is another reason for things not being there yet. Go bark up 
those trees instead.

Rene.

