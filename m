Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYIJV3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYIJV3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYIJV27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:28:59 -0400
Received: from 1wt.eu ([62.212.114.60]:3777 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbYIJV26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:28:58 -0400
Date: Wed, 10 Sep 2008 23:28:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: Frans Pop <elendil@planet.nl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Time travel experiment?
Message-ID: <20080910212840.GA24654@1wt.eu>
References: <200809101658.06935.elendil@planet.nl> <20080910152917.634a03fc@the-village.bc.nu> <200809101755.19927.elendil@planet.nl> <200809101825.29276.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809101825.29276.elendil@planet.nl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 06:25:28PM +0200, Frans Pop wrote:
> On Wednesday 10 September 2008, Frans Pop wrote:
> > > > $ date
> > > > Wed Jul  3 23:09:23 CEST 2024
> > >
> > > Is this repeatable ?
> >
> > This wasn't the first suspend I've done today and I'd not seen it
> > before. I'll follow up if it does repeat, but I thought it was strange
> > and potentially important enough to at least report this occurrence. It
> > might ring a bell with someone.
> 
> Oops. Yes, it is repeatable. Just had the same occur again.
> Not sure if I can trigger it reliably though or if it will still happen
> after a reboot.
> 
> The jump occurs at the same point and to almost the same time/date:
> Sep 10 18:15:30 aragorn kernel: PM: Adding info for No Bus:vcs63
> Sep 10 18:15:30 aragorn kernel: PM: Adding info for No Bus:vcsa63
> Sep 10 18:15:30 aragorn kernel: wlan0: authenticate with AP 00:14:c1:38:e5:15
> Sep 10 18:15:30 aragorn kernel: wlan0: authenticated
> Sep 10 18:15:30 aragorn kernel: wlan0: associate with AP 00:14:c1:38:e5:15
> Sep 10 18:15:30 aragorn kernel: wlan0: RX ReassocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
> Sep 10 18:15:30 aragorn kernel: wlan0: associated
> Sep 10 18:15:30 aragorn kernel: PM: Removing info for No Bus:vcs63
> Sep 10 18:15:30 aragorn kernel: PM: Removing info for No Bus:vcsa63
> Jul  3 23:09:01 aragorn kernel: wlan0: disassociating by local choice (reason=3)
> Jul  3 23:09:03 aragorn kernel: wlan0: associate with AP 00:14:c1:38:e5:15
> Jul  3 23:09:03 aragorn kernel: wlan0: RX ReassocResp from 00:14:c1:38:e5:15 (capab=0x411 status=0 aid=1)
> 
> One other thing with this last one. I had the system on AC this time,
> which means the screensaver was active. It was running at a crazy speed
> (much too fast). If I start the screensaver again now it runs at normal
> speed.

Note that the time jump is 500 million seconds in the future (498977611
to be precise). I don't know if it is possible that some value running
one unit has mistakenly been used in place of another one (eg: internal
clock ticks instead of jiffies, etc...).

Willy

