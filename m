Return-Path: <linux-kernel-owner+w=401wt.eu-S1765611AbXLPCaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765611AbXLPCaw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 21:30:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbXLPCaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 21:30:46 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:55202 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbXLPCap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 21:30:45 -0500
Message-ID: <47648DB8.1080205@lwfinger.net>
Date: Sat, 15 Dec 2007 18:30:16 -0800
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, Ray Lee <ray-lk@madrabbit.org>,
       =?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?= <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       jonathan@jonmasters.org, Ingo Molnar <mingo@elte.hu>,
       kjwinchester@gmail.com, linux@bohmer.net
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
 to	mutex
References: <20071213003028.676998182@mvista.com>	<200712151157.44278.mb@bu3sch.de> <200712160018.45613.rjw@sisk.pl> <200712160027.19950.mb@bu3sch.de>
In-Reply-To: <200712160027.19950.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch wrote:
> On Sunday 16 December 2007 00:18:43 Rafael J. Wysocki wrote:
>> Well, the only problem with that is I suspect there are some "newer" cards that
>> work better with v3 firmware, although they are supposed to support both.
> 
> And I suspect that you are wrong until you show me one. :)

The BCM4311/1 card used to work better with bcm43xx than it did with b43; however, since the power 
control problem was "solved" in b43, there is very little difference. When I built my special system 
to use the BCM4311 with b43legacy, there was no difference.

I don't know of any cards that work better with bcm43xx than with b43. Of course, that is comparing 
SoftMAC with mac80211. There is, of course, no comparison.

Larry


