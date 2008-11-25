Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYKYHDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYKYHDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYKYHDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:03:15 -0500
Received: from eazy.amigager.de ([213.239.192.238]:58958 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYKYHDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:03:14 -0500
Date: Tue, 25 Nov 2008 08:03:12 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc regression: digital audio inactive after resume from
	suspend
Message-ID: <20081125070312.GA6533@dose.home.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	linux-kernel@vger.kernel.org
References: <20081124212225.GA5872@dose.home.local> <s5hiqqcra95.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hiqqcra95.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 00:10:14 +0100, Takashi Iwai wrote:
> At Mon, 24 Nov 2008 22:22:25 +0100,
> Tino Keitel wrote:
> > 
> > Hi,
> > 
> > the digital audio out (optical) is inactive (no red light, and
> > therefore silent) after resume from suspend on my Mac mini Core Duo.
> > When I disable and enable the IEC958 toggle, it works again.
> > 
> > This didn't happen with 2.6.27. Currently, I use 2.6.28-rc6 as of
> > commit ged31348.
> > 
> > This is the hardware in lspci:
> > 
> > 00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family)
> > High Definition Audio Controller [8086:27d8] (rev 02)
> > 	Subsystem: Sigmatel Device [8384:7680]
> > 	Flags: bus master, fast devsel, latency 0, IRQ 22
> > 	Memory at 90440000 (64-bit, non-prefetchable) [size=16K]
> > 	Capabilities: <access denied>
> > 	Kernel driver in use: HDA Intel
> > 	Kernel modules: snd-hda-intel
> > 
> > The dmesg output with 2.6.27 and 2.6.28-rc are here:
> > 
> > http://tikei.de/dmesg_2.6.27.5
> > http://tikei.de/dmesg_2.6.28-rc6
> 
> Could you run alsa-info.sh with --no-upload option on both kernels
> and attach the generated files?  The script is found at
>     http://www.alsa-project.org/alsa-info.sh

http://tikei.de/alsa-info-2.6.27.5.txt
http://tikei.de/alsa-info-2.6.28-broken.txt
http://tikei.de/alsa-info-2.6.28-fixed.txt (here I unchecked/rechecked
the IEC958 toggle)

Regards,
Tino
