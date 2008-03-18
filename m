Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYCSTet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYCSTet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYCST1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:27:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754080AbYCST1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:27:30 -0400
Date: Tue, 18 Mar 2008 09:47:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anders Eriksson <aeriksson@fastmail.fm>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4 
In-Reply-To: <20080318163004.018332DC044@tippex.mynet.homeunix.org>
Message-ID: <alpine.LFD.1.00.0803180943300.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <alpine.LFD.1.00.0803171548480.3020@woody.linux-foundation.org> <20080318001831.575D093C911@tippex.mynet.homeunix.org> <200803181403.37969.bzolnier@gmail.com>
 <20080318133259.E71EE2DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803180751200.3020@woody.linux-foundation.org> <20080318163004.018332DC044@tippex.mynet.homeunix.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Mar 2008, Anders Eriksson wrote:
> 
> Seems we got something here. For all I can tell, it's working!
> 
> I had to hand apply the last hunk of your patch, and the other patches are there as 
> well. Can you respin it vs. -rc6 and I'll try on a clean tree?

Actually, the patch I sent you should be against the current -git tree, 
and I don't think anything has changed since -rc6 in this area.

I suspect the reason you had to hand-apply it may be the other 
test-patches you had. Can you just undo those? Since it looks like it may 
be working for you, the debug patches are just adding tons of noise by 
now, and it would be good to hear whether the status with that last patch 
is just a simple "ok, it works now".

		Linus
