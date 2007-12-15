Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbXLOMjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbXLOMjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 07:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbXLOMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 07:38:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:9049 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXLOMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 07:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ROwtawnJgrVqfbfClWZZBir0sZRIK7ohOCdTcl/SUgVYuO6D28UTE3OG6oaAFHSnJX8v9ln3L9vyaGDeEJlztLbbEVfB/tex41Va5P4l03ZwfIPcQK8K1E3TCPa54zfTKfTpswrzoPrQ2kmxGwl8/9DBFkv2RjdomckxPyOubnM=
Message-ID: <520b60a90712150438p1f0ae40bt5975b494ab75203c@mail.gmail.com>
Date: Sat, 15 Dec 2007 07:38:51 -0500
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
In-Reply-To: <47637FDA.2030303@lwfinger.net>
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
	 <520b60a90712142037j14d54de5nf5657ab2927fb3f5@mail.gmail.com>
	 <520b60a90712142039t539faeddo68e73816fe1b3237@mail.gmail.com>
	 <47637FDA.2030303@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 15, 2007 2:18 AM, Larry Finger <larry.finger@lwfinger.net> wrote:
>
> It will take a while to finish looking over those logs, but are you using ipv6? If not, please
> blacklist the ipv6 module to prevent it from loading - add the line 'blacklist ipv6' to file
> /etc/modprobe.d/blacklist. In some cases, ipv6 can cause timeouts even though you do not have any
> ipv6 routers.

I'll be gone all day today, so it may take me awhile to test. I tried
real quick to blacklist it, but fedora isn't making it easy,
apparently it's depended on by quite a few things and I can't even
force unload them. I'll build latest wireless git without ipv6 late
tonight. Also, the logs may be incomplete, they're probably missing
when the device first associates with the router. Not sure if I should
include that.

I'm thankful that at least we're moving in some direction to solve
this bug, thanks again.
