Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbXLOA6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbXLOA6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 19:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbXLOA6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 19:58:37 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:39751 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbXLOA6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 19:58:37 -0500
Message-ID: <476326A1.6090404@lwfinger.net>
Date: Fri, 14 Dec 2007 16:58:09 -0800
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Michael Buesch <mb@bu3sch.de>, Daniel Walker <dwalker@mvista.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       =?UTF-8?B?U2ltb24gSG9sbSBUaMO4Z2Vyc2Vu?= <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, Ingo Molnar <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
 to	mutex
References: <20071213003028.676998182@mvista.com>	<1197637194.7549.10.camel@odie.local>	<200712141404.24275.mb@bu3sch.de> <200712150151.49025.rjw@sisk.pl>
In-Reply-To: <200712150151.49025.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> Actually, can you explain why, from the technical point of view, the version 4
> firware is better than version 3, please?

I will be very interested in Michael's answer to this question; however, my experience is that it 
doesn't make much difference if your device is supported by both V3 and V4 firmware. This impression 
was obtained by comparing BCM4318 and BCM4311/1 devices with b43 and b43legacy.

Note that 802.11b and early BCM4306 devices are not supported by V4 firmware. Similarly, with 
BCM4311/2 and newer devices V3 firmware fails. As Michael said "newer drivers supporting newer 
hardware need newer firmware".

Larry
