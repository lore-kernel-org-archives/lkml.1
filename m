Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbZDOU7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbZDOU7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 16:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbZDOU7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 16:59:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56615 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbZDOU7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 16:59:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [2.6.30-rc1-git2 regressions] Hibernation broken and (minor but annoying) audio problem
Date: Wed, 15 Apr 2009 22:59:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200904100057.43827.rjw@sisk.pl> <200904142312.33833.rjw@sisk.pl> <s5hbpqy12mh.wl%tiwai@suse.de>
In-Reply-To: <s5hbpqy12mh.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904152259.10473.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 April 2009, Takashi Iwai wrote:
> At Tue, 14 Apr 2009 23:12:33 +0200,
> Rafael J. Wysocki wrote:
> > 
> > On Tuesday 14 April 2009, Takashi Iwai wrote:
> > > At Fri, 10 Apr 2009 00:57:41 +0200,
> > > Rafael J. Wysocki wrote:
> > > > 
> > > > Second, KDE4 on openSUSE 11.1 sometimes fails to handle audio correctly after
> > > > a fresh boot.  Everything seems to work, but there's no sound at all.  It is
> > > > sufficient to close the X session and start the desktop environment again to
> > > > make it work, though (may that be async too? ;-)).  The hardware in question is
> > > > Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller
> > > > (rev 02) and the driver is snd_hda_intel.
> > > 
> > > Is this problem still there?
> > 
> > Just a few minutes ago sound stopped working (that was after a resume from S3,
> > but not immediately after it), without anything suspicious in dmesg etc.
> > Restarting X fixed that.
> > 
> > Still, that doesn't happen very often and it is not readily reproducible.
> > 
> > > If restarting the X session fixes the problem, it could be a
> > > pulseaudio problem.  But, then it doesn't sound like a kernel update
> > > issue.
> > 
> > Well, that may be a pulseaudio problem, but the very same pulsaudio apparently
> >  worked well with 2.6.29-git<something>.  That might be a coincidence, though.
> 
> 2.6.30-rc[12] have some patches regarding the DMA pointer handling,
> which may influence on PA.  More fix patches are pending.  Could you
> try sound git tree either master or for-next branch?  At least it
> seems working for some others.
>     git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git

I'm going to try 2.6.30-rc2-git in a while.  If I have the time, I'll also test
the sound git tree.

Thanks,
Rafael
