Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbXLOC2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbXLOC2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 21:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXLOC2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 21:28:30 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60947 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbXLOC23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 21:28:29 -0500
Message-ID: <47633BAE.6040604@lwfinger.net>
Date: Fri, 14 Dec 2007 18:27:58 -0800
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
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
References: <20071213003028.676998182@mvista.com>	 <1197637194.7549.10.camel@odie.local>	 <200712141404.24275.mb@bu3sch.de> <200712150151.49025.rjw@sisk.pl>	 <476326A1.6090404@lwfinger.net> <520b60a90712141759h65f1e63ei65ba00887a930d06@mail.gmail.com>
In-Reply-To: <520b60a90712141759h65f1e63ei65ba00887a930d06@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mvtodevnull@gmail.com wrote:
> 
> Could this be the reason my BCM94311MCG rev 1 receives such terrible
> performance with b43 but works well with bcm43xx? The device is
> 802.11b/g but my router is 802.11b. I filed a report on this issue
> here: https://bugzilla.redhat.com/show_bug.cgi?id=413291

No. On my BCM4311/1, my transfer rate peaked at about 12 Mbs with bcm43xx, but increased to 20 Mbs 
with b43. These tests were done with iperf with a server running running on a second computer 
connected by wire to my router. These rates are for 802.11g. When my interface was locked at 11 Mbs, 
the transfer rate was the expected 5.3-5.5 Mbs with both drivers.

> I was told by Michael that I would have to fix it myself, and I am
> trying, but the learning curve is a little steep. If this is relevant,
> I might at least have some direction to go in.

I suspect that mac80211 is doing something that your router does not like. Do you have any chance to 
capture the traffic between your computer and the router by using a second wireless computer running 
kismet or wireshark? A look at the differences between b43 and bcm43xx should show the reason.

Larry



