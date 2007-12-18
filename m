Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbXLRBQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbXLRBQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbXLRBQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:16:36 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:52976 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbXLRBQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:16:35 -0500
Message-ID: <47671F5F.5020400@lwfinger.net>
Date: Mon, 17 Dec 2007 17:16:15 -0800
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: mvtodevnull@gmail.com
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Daniel Walker <dwalker@mvista.com>, Ray Lee <ray-lk@madrabbit.org>,
       =?ISO-8859-1?Q?Simon_Holm_Th=F8gerse?= =?ISO-8859-1?Q?n?= 
	<odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, Ingo Molnar <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
 to mutex
References: <20071213003028.676998182@mvista.com>	 <476326A1.6090404@lwfinger.net>	 <520b60a90712141759h65f1e63ei65ba00887a930d06@mail.gmail.com>	 <47633BAE.6040604@lwfinger.net>	 <520b60a90712142037j14d54de5nf5657ab2927fb3f5@mail.gmail.com>	 <520b60a90712142039t539faeddo68e73816fe1b3237@mail.gmail.com>	 <47637FDA.2030303@lwfinger.net>	 <520b60a90712150438p1f0ae40bt5975b494ab75203c@mail.gmail.com>	 <520b60a90712161817uaa2d1a8y5dfb13b586ca30ad@mail.gmail.com>	 <47661CA1.3080808@lwfinger.net> <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>
In-Reply-To: <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mvtodevnull@gmail.com wrote:
> 
> I don't know what happened before, but after a reboot, I can't repeat
> the 200 kB/s speed. It's back down to 40 kB/s, just like originally. I
> didn't move the laptop, or the ap, the only thing I can think of that
> might have changed is the noise level. FWIW, link quality is
> consistently the same or better with b43.
> 
> Anyway, I'd noticed before that the bit rate starts at 1 Mb/s and
> quickly scales to 11 Mb/s, but I tried setting it manually anyway and
> didn't see any change. In fact, I set the rate to 5.5 Mb/s as well as
> 1 Mb/s and the download speed was the same with all three (around
> 30-40 kB/s).

I hope that you have now convinced yourself that you should be using b43 and not messing around
forcing b43legacy to use a device for which it was not intended. I left that back door in the code
because I wanted to test b43legacy on a computer that could build a kernel in 20 minutes, as
compared to the 12 hours that my old laptop with the device that needs b43legacy. I forgot to clean
up the code as I should have.

You should concentrate on what in your environment changed when you rebooted. If you can get the 200
kBs rate back, please note the noise and signal levels as compared to the values when you are
restricted to 40 kBs.

Is it possible for you to test your laptop on another AP?

Larry


