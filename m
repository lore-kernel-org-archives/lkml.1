Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYAOTAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYAOTAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYAOTAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:00:14 -0500
Received: from keil-draco.com ([216.193.185.50]:50574 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYAOTAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:00:12 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.24-rc7, intel audio: alsa doesn't say a beep
Date: Tue, 15 Jan 2008 14:00:06 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
References: <4782833D.3010600@t-online.de> <200801141603.22983.dhazelton@enter.net> <s5htzlf2yfm.wl%tiwai@suse.de>
In-Reply-To: <s5htzlf2yfm.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151400.07422.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008 05:08:45 Takashi Iwai wrote:
> At Mon, 14 Jan 2008 16:03:22 -0500,
>
> Daniel Hazelton wrote:
> > On Monday 14 January 2008 06:04:20 Takashi Iwai wrote:
> > <snip>
> >
> > > > Could this have anything to do with the following messages I've seen
> > > > when trying -rc7 ?
> > > >
> > > > [    7.760269] pnpacpi: exceeded the max number of mem resources: 12
> > >
> > > Judging from Harald's report, it looks like a different problem.
> > > The buggy patch (regarding HDA-intel) was, at least, already reverted
> > > on Linus git tree.  Could you give it a try?
> > >
> > >
> > > Takashi
> >
> > Sorry, still no sound. Config, lspci and dmesg attached to help. System
> > is, as stated, Dell Inspiron 1420n running a 64bit kernel and userland.
>
> Hm, has the sound on ever 2.6.24-rc kernel worked with your machine?
>
> Anyway, try to change HZ=300.  I got a report that HZ=1000 causes the
> similar problem but HZ=300 not.
>
>
> Takashi

That did it. Looks like the hardware really is that sensitive to the timing. 
Strange, but I've seen worse.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
