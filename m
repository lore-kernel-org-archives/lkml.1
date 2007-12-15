Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbXLOEhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbXLOEhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 23:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbXLOEhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 23:37:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:24014 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbXLOEhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 23:37:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iSZF9dmVVrqfnli1lndLZRlMsmvmyE0hfONvD0Rqn1WGYhMFWFgxs3x2RP89ks76u5Yu/pfEIQnAw7hkLBTW0tg+lxLmrhmY2EXGbWFCAgR3JaozxVRiHMUeL56ghxTsuq947spi775C4jAHOD30/vF7TbvxJLDk1J8Wshk7C2k=
Message-ID: <520b60a90712142037j14d54de5nf5657ab2927fb3f5@mail.gmail.com>
Date: Fri, 14 Dec 2007 23:37:44 -0500
From: mvtodevnull@gmail.com
To: "Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Michael Buesch" <mb@bu3sch.de>,
       "Daniel Walker" <dwalker@mvista.com>, "Ray Lee" <ray-lk@madrabbit.org>,
       "=?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
In-Reply-To: <47633BAE.6040604@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <1197637194.7549.10.camel@odie.local>
	 <200712141404.24275.mb@bu3sch.de> <200712150151.49025.rjw@sisk.pl>
	 <476326A1.6090404@lwfinger.net>
	 <520b60a90712141759h65f1e63ei65ba00887a930d06@mail.gmail.com>
	 <47633BAE.6040604@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2007 9:27 PM, Larry Finger <larry.finger@lwfinger.net> wrote:
>
> I suspect that mac80211 is doing something that your router does not like. Do you have any chance to
> capture the traffic between your computer and the router by using a second wireless computer running
> kismet or wireshark? A look at the differences between b43 and bcm43xx should show the reason.
>

Hi Larry, thanks for replying.

I have to admit, I've never used either of these before, so I'm not
sure if I did this correctly.

I created two different packet dumps using kismet, one when my laptop
was using b43 and the other when it was using bcm43xx. While my
desktop was logging, I used my laptop to go to kernel.org and download
patch-2.6.23.11.bz2 (both times the browser started at
http://www.kernel.org/pub/linux/kernel/). Then I used tshark to parse
the dump files and create two new readable logs.

I'll attach these logs since I can't read much into them. The only
strange difference I noticed is that with b43, I got messages like
ICMP Destination unreachable (Host administratively prohibited), which
I didn't get with bcm43xx.

There's about 5 machines connected to this network -- the laptop with
the broadcom card has internal ip 192.168.0.3.
