Return-Path: <linux-kernel-owner+w=401wt.eu-S1765136AbXLOHTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765136AbXLOHTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbXLOHTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:19:31 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53493 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109AbXLOHTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:19:30 -0500
Message-ID: <47637FDA.2030303@lwfinger.net>
Date: Fri, 14 Dec 2007 23:18:50 -0800
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
References: <20071213003028.676998182@mvista.com>	 <1197637194.7549.10.camel@odie.local>	 <200712141404.24275.mb@bu3sch.de> <200712150151.49025.rjw@sisk.pl>	 <476326A1.6090404@lwfinger.net>	 <520b60a90712141759h65f1e63ei65ba00887a930d06@mail.gmail.com>	 <47633BAE.6040604@lwfinger.net>	 <520b60a90712142037j14d54de5nf5657ab2927fb3f5@mail.gmail.com> <520b60a90712142039t539faeddo68e73816fe1b3237@mail.gmail.com>
In-Reply-To: <520b60a90712142039t539faeddo68e73816fe1b3237@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mvtodevnull@gmail.com wrote:
> On Dec 14, 2007 11:37 PM,  <mvtodevnull@gmail.com> wrote:
>> I'll attach these logs since I can't read much into them.
> 
> I should do what I say...
> 

It will take a while to finish looking over those logs, but are you using ipv6? If not, please 
blacklist the ipv6 module to prevent it from loading - add the line 'blacklist ipv6' to file 
/etc/modprobe.d/blacklist. In some cases, ipv6 can cause timeouts even though you do not have any 
ipv6 routers.

Larry

