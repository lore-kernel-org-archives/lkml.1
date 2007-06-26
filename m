Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbXFZVLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbXFZVLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 17:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbXFZVLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 17:11:31 -0400
Received: from main.gmane.org ([80.91.229.2]:44847 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbXFZVLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 17:11:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Date: Tue, 26 Jun 2007 22:10:24 +0100
Message-ID: <yw1xy7i6v2v3.fsf@thrashbarg.mansr.com>
References: <200706262239.05070.ahartmetz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: agrajag.inprovide.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (Double Solitaire, linux)
Cancel-Lock: sha1:HQLjtlkZ8fNR/o5+Tgevx3hJCnU=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Hartmetz <ahartmetz@gmail.com> writes:

> The track record of ALSA for me goes like this:
>
> - dmix finally started working automatically (at least on my Kubuntu system) 
> about one year ago, about five years after everybody could see that this was 
> badly needed. I couldn't get it to work before. The howtos somehow didn't 
> work and ALSA's documentation isn't all that helpful.

I don't remember when it happened, but I do remember that I suddenly
had to manually disable dmix to stop it messing around with my sound.
I don't need it, and I certainly don't like libraries doing random IPC
behind my back.

> - Different desktop environments have different sound daemons to
> paper over the weaknesses of ALSA (no dmix by default / unfriendly
> API), which creates new problems. Yes there are other reasons for
> sound daemons, but I doubt anybody would have come up with the idea
> if it wasn't for ALSA.

Those sound daemons were around long before ALSA was even conceived.

> - I have an Envy24HT based soundcard in my desktop PC, which also
> goes to show that I'm really interested in sound issues. I have to
> run alsamixer after every bootup to unmute the left channel because
> restoring volume only works for the right channel. The left channel
> starts working after changing its volume.

That sounds like a minor glitch that should be easily remedied if you
file a proper bug report.  Have you tried?

> - On my IBM/Lenovo R50e notebook with Intel chipset sound didn't
> work before I "muted" the "headphone jack sense" control in
> alsamixer. That took two hours or so. When both the master volume
> and the PCM volume control are set to 100% I get really bad clipping
> problems.

Shoddy hardware.  Don't blame the drivers for that.

> - Some time ago ALSA reported that my soundcard supports sampling
> rates it doesn't in fact support. This was fixed by Takashi Iwai
> after a week and two mails or so. Thumbs up.

Yes, API and configuration file syntax aside, the ALSA developers are
always friendly and responsive.

> (*) I am not representing KDE in an official way at all, but I can
> say that KDE developers generally put *much* effort into making APIs
> as logical and friendly as they possibly can.

I've still not, after all these years, managed to figure out what KDE
(or Gnome) is supposed to be good for.  I'm not missing anything from
my window manager, xterm and xemacs setup.

-- 
Måns Rullgård
mans@mansr.com

