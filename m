Return-Path: <linux-kernel-owner+w=401wt.eu-S1030550AbXAZBGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030550AbXAZBGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 20:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030553AbXAZBGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 20:06:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:54749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030550AbXAZBGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 20:06:06 -0500
From: Andreas Schwab <schwab@suse.de>
To: Jim Gifford <maillist@jg555.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Powermac Sound Issue with Wallstreet PowerBook
References: <45B9466E.3020805@jg555.com>
X-Yow: There's a little picture of ED MCMAHON doing BAD THINGS to JOAN RIVERS
 in a $200,000 MALIBU BEACH HOUSE!!
Date: Fri, 26 Jan 2007 02:05:54 +0100
In-Reply-To: <45B9466E.3020805@jg555.com> (Jim Gifford's message of "Thu, 25
	Jan 2007 16:08:14 -0800")
Message-ID: <je1wli8uml.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Gifford <maillist@jg555.com> writes:

> For over the last few weeks, I've been trying to get sound working on my
> Powerbook G3. I've tried various different things with no luck. Anyone got
> any ideas??
>
> dmasound_pmac: Awacs/Screamer Codec Mfct: 2 Rev 3
> input: dmasound beeper as /class/input/input4
> PowerMac Screamer  DMA sound driver rev 016 installed
> Core driver edition 01.06 : PowerMac Built-in Sound driver edition 00.07
> Write will use    4 fragments of   32768 bytes as default
> Read  will use    4 fragments of   32768 bytes as default
> Advanced Linux Sound Architecture Driver Version 1.0.13 (Tue Nov 28
> 14:07:24 2006 UTC).
> PM: Adding info for platform:snd_powermac
> snd: can't request rsrc  0 (Sound Control:
> 0x00000000f3014000:00000000f3014fff)
> ALSA device list:
>  No soundcards found.

Looks like the problem is that you have both the OSS and the ALSA driver
built into your kernel.  Try removing one of them, preferably the OSS
driver (it's obsolete).

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
