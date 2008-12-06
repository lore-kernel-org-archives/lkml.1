Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYLFXWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYLFXWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 18:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYLFXWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 18:22:13 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:24115 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYLFXWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 18:22:12 -0500
Message-ID: <493B0922.2080606@msgid.tls.msk.ru>
Date: Sun, 07 Dec 2008 02:22:10 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com,
       smartmontools-support@lists.sourceforge.net
Subject: Re: Have the velociraptors in a test system now, checkout the errors.
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan> <493A5E62.1020508@msgid.tls.msk.ru> <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0812060709280.8516@p34.internal.lan>
X-Enigmail-Version: 0.95.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:

[big skip..]
> Very interesting story there, what OS(') were you using at the time?
> Windows? Linux? UNIX?

It is linux.  Since 2.2 or 2.0, I don't remember for sure.
With software raid since the day one (was an external patch
in a few first years).

> As far the PSU, just btw/FYI, Velociraptors consume ~4-5 watts a piece,
> my entire system used ~100-120watts with all 12 velociraptors on a 650
> watt PSU (now moved into a test system).

Well.  Others already commented on this, -- different rail can draw
different max power.  But it's a bit more complex still.  Those 4..5
watts is a sustained power consumption, not peak.  When moving heads,
starting/stopping the motor etc, the drive briefly consumes much more
power.  From my choice of cheap PSUs, not all of them can do the work
even when theoretical load is below the capacity.  I.e., the voltage
becomes.. unstable (insufficient filtering/capacitors, bad output
cirquits, too thin wires etc yadda).  And some parts of the system
may "translate" those instabilities into ones and zeros..

It's more: when the drives are in some RAID configuration (esp. raid1
and the like), usually more than one drive works in parallel, at exactly
the same moment (think writes to a raid1).  So it is more possible to
have bad results in raid config than without...

But again: I'm not at all suggesting your problem is in PSU.  It
*might* be here, but I hope your PSU can do the work fine.  And
in my case there were other failures too, more "mysterious".

And by the way, some modern PSUs, especially more powerful ones,
has more than one separate rails for 12v and sometimes 5v.  I.e.
two or more independent (to some extent anyway) 12v circuits.
With obvious advantages.

/mjt
