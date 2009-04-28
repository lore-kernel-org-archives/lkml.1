Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZD1AXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZD1AXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 20:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZD1AXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 20:23:12 -0400
Received: from eazy.amigager.de ([213.239.192.238]:54760 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbZD1AXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 20:23:11 -0400
Date: Tue, 28 Apr 2009 02:23:09 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
	suspend with Intel HDA
Message-ID: <20090428002309.GA29572@x61>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
References: <20090420184024.GA10155@dose.home.local> <s5hmyab15bh.wl%tiwai@suse.de> <20090420194659.GA11399@dose.home.local> <s5h8wluinon.wl%tiwai@suse.de> <20090421073219.GA5866@dose.home.local> <s5hfxg2cv6m.wl%tiwai@suse.de> <20090421183936.GA21935@dose.home.local> <s5hws9a5ewr.wl%tiwai@suse.de> <20090424142113.GA18668@dose.home.local> <s5hskjy5d2t.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hskjy5d2t.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 16:41:14 +0200, Takashi Iwai wrote:
> At Fri, 24 Apr 2009 16:21:13 +0200,
> Tino Keitel wrote:
> > 
> > On Fri, Apr 24, 2009 at 16:01:40 +0200, Takashi Iwai wrote:
> > 
> > [...]
> > 
> > > The codec communication looks a bit unstable on this device...
> > > Does this still happen on the latest 2.6.30 version?
> > 
> > Yes, at least with 2.6.30-rc3. I reloaded snd-hda-intel a few times,
> > and at some point /etc/init.d/alsa-utils start complained, I guess
> > because some index numbers in  the mixer changed.
> 
> And this happens because the codec doesn't respond properly any more.
> So, something triggers to screw up the communication with the codec.
> I have no idea right now.  Possibly you can bisect the changes against
> sound/pci/hda/patch_sigmatel.c...

The problem is that I don't have a reliable way to trigger this bug. It
just happens sometimes.

I just saw another, major problem: line in doesn't work anymore with
2.6.29 and also 2.6.30-rc3 (no usable input level). It works with
2.6.27.20.

So it seems that all newer kernels are pretty broken on this hardware
regarding sound.

Regards,
Tino
