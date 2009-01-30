Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbZA3GwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbZA3GwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZA3GwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:52:09 -0500
Received: from mout.perfora.net ([74.208.4.194]:64469 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZA3GwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:52:08 -0500
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Nathanael Hoyle <nhoyle@hoyletech.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1233296647.6071.15.camel@marge.simson.net>
References: <1233294584.28741.2.camel@localhost>
	 <1233296647.6071.15.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 01:52:01 -0500
Message-Id: <1233298321.17301.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19zFR7J3pdVMzs8wa0ZgoJ3bMRl144Y+Cx5LLz
 vWVhcAWgIVNCSNFU+opvEpHc0fAP83OOiDX9b9UUmBhhCRORcq
 cRfUtbZ//X7kYTMgf8PDcuebZRQJ6Ip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 07:24 +0100, Mike Galbraith wrote:
> On Fri, 2009-01-30 at 00:49 -0500, Nathanael Hoyle wrote:
> 
> > Recently I installed the Folding@Home client, which many of you may be
> > familiar with, intended to utilize spare CPU cycles to perform protein
> > folding simulations in order to further medical research.  It is not a
> > multi-threaded client at this point, so it simply runs four instances on
> > my system, since it has four cores.  It is configured to run at
> > nice-level 19.
> > 
> > Because it is heavily optimized, and needs little external data to
> > perform its work, it spends almost all of its time cpu-bound, with
> > little to no io-wait or blocking on network calls, etc.  I had been
> > using it for about a week with no real difficulty until I went to watch
> > another DVD and found that the video was slightly stuttery/jerky so long
> > as foldingathome was running in the background.  Once I shut it down,
> > the video playback resumed its normal smooth form.
> 
> Sounds like a problem was recently fixed.  Can you try 2.6.29-rc3 or
> 2.6.28.2?
> 
> 	-Mike
> 

I will try to do so as soon as I get the chance.  Do you have any
specific info on the problem that you believe was fixed and/or the fix
applied?

Thanks,
-Nathanael

