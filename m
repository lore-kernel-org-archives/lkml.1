Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbXFYPSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbXFYPSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbXFYPSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:18:43 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:50351 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757277AbXFYPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:18:42 -0400
Date: Mon, 25 Jun 2007 11:18:41 -0400
To: Carlo Wood <carlo@alinoe.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
Message-ID: <20070625151841.GK10008@csclub.uwaterloo.ca>
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <1182397012.2863.0.camel@laptopd505.fenrus.org> <20070622162142.GA603@alinoe.com> <20070622211746.GB21769@khazad-dum.debian.net> <20070622212758.GA6970@alinoe.com> <20070623013132.GA1702@khazad-dum.debian.net> <20070623025906.GA24336@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070623025906.GA24336@alinoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 04:59:06AM +0200, Carlo Wood wrote:
> Just one kernel version? The problem here is in every
> kernel revision after 551c012d7eea3dc5ec063c7ff9c718d39e77634f
> 
> 2.6.20-rc2,rc3,rc4,rc5,rc6,rc7 ... 2.6.20 ... 2.6.21 ... 2.6.22-rc5
> 
> noop:
>  Timing buffered disk reads:  254 MB in  3.00 seconds =  84.66 MB/sec
> 
> anticipatory:
>  Timing buffered disk reads:  252 MB in  3.02 seconds =  83.43 MB/sec
> 
> deadline:
>  Timing buffered disk reads:  258 MB in  3.02 seconds =  85.41 MB/sec
> 
> cfq:
>  Timing buffered disk reads:  194 MB in  3.03 seconds =  64.06 MB/sec
> 
> The normal value is cfq. So, all other schedulars are somewhat faster,
> but still far from the correct 165 MB/s.

How do you know 165MB/s is correct?

As for 10k rpm being faster, well remember rotation speed _and_ areal
density is what gives transfer rate.  a 750GB 7200rpm is likely able to
have a higher throughput than a 73GB 10k rpm drive since more bits pass
by the head in any given unit of time on the larger drive.  The 7200 rpm
has a slower average access time though.

--
Len Sorensen
