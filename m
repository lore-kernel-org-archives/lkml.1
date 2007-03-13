Return-Path: <linux-kernel-owner+w=401wt.eu-S1753273AbXCMPrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbXCMPrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbXCMPra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:47:30 -0400
Received: from mail05.syd.optusnet.com.au ([211.29.132.186]:43050 "EHLO
	mail05.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273AbXCMPr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:47:29 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ash Milsted <thatistosayiseenem@gawab.com>
Subject: Re: [ck] RSDL v0.30 cpu scheduler for mainline kernels
Date: Wed, 14 Mar 2007 02:46:26 +1100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
References: <200703121058.11966.kernel@kolivas.org> <20070313153514.428dc3e1.thatistosayiseenem@gawab.com>
In-Reply-To: <20070313153514.428dc3e1.thatistosayiseenem@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703140246.26522.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007 02:35, Ash Milsted wrote:
> Here's my experience with RSDL 0.30 on 2.6.21-rc3-git6 under my normal
> usage scenarios...
>
> Plain desktop use (web browsing, music, etc): no noticeable change
>
> Desktop use during kernel compile (no -j): The compile impacts desktop
> use more with RSDL, but this is easily solved by nice-ing the compile
> (default nice of 10 seems enough). The kind of impact I am talking about
> is e.g. occasional delays in scrolling in the browser etc.
>
> Desktop use whilst talking on Wengophone (run at nice -5): Under RSDL
> some GUI use e.g. opening a new folder in nautilus causes pops (buffer
> underruns) which do not occur with mainline. I suppose the changes in
> RSDL might require a lower nice value for equivalent performance, but
> (as a user) I am limited to -5.
>
> Low-latency audio with JACK and Ardour2: Rock-solid performance with
> either scheduler.. realtime works nicely.
>
> Playing Quake3 (proprietary nvidia driver): Plays smoothly for both
> schedulers.
>
> So, I suppose I'd like to know what to do about the Wengophone issue,
> because that really is a problem for me. I guess your re-worked -ive
> nice values might help?

Well the change to -nice values was to minimise the harm they do to everything 
else. They will still get the lowest latencies and the most cpu but no more 
than previously. The difference will be to more niced tasks. I'm not sure 
just how much cpu you require for wengophone because at -5 it would be 
getting a fair chunk of cpu with the RSDL 0.30. Anyway, by sheer coincidence 
I just emailed out that patch I was planning so feel free to try it.

-- 
-ck
