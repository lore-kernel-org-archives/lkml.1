Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbXLNNCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbXLNNCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 08:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765468AbXLNNCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 08:02:05 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:59917 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764715AbXLNNCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 08:02:04 -0500
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ingo Molnar <mingo@elte.hu>, Ray Lee <ray-lk@madrabbit.org>,
       bcm43xx-dev@lists.berlios.de, Daniel Walker <dwalker@mvista.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux@bohmer.net, jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, John Linville <linville@tuxdriver.com>
In-Reply-To: <200712141331.59410.mb@bu3sch.de>
References: <20071213003028.676998182@mvista.com>
	 <200712141239.51809.mb@bu3sch.de> <20071214121617.GE23964@elte.hu>
	 <200712141331.59410.mb@bu3sch.de>
Content-Type: text/plain; charset=utf-8
Date: Fri, 14 Dec 2007 13:59:54 +0100
Message-Id: <1197637194.7549.10.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fre, 14 12 2007 kl. 13:31 +0100, skrev Michael Buesch:
> On Friday 14 December 2007 13:16:17 Ingo Molnar wrote:
> > 
> > * Michael Buesch <mb@bu3sch.de> wrote:
> > 
> > > > The testers who did nothing but reported that the new driver did not 
> > > > work on their hardware.
> > > 
> > > Which testers?
> > 
> > right in this thread Ray Lee is reporting:
> > 
> > | | Digging a little farther into it, it looks like b43 is barfing 
> > | | partway through init as the firmware file it's looking for has 
> > | | changed names. Perhaps that's the issue. I'll take a longer look at
        ^^^^^^^^^^^^^^
Ray probably has version 3 of the firmware.

> > | | this all tomorrow.
> > 
> > you are really in denial of reality. Just re-read this thread. Upon 
> > re-reading this thread, try to imagine that you are in place of Ray Lee 
> > (might be hard), that you had a working bcm43xx driver and that now you 
> > try to get b43 to work. You are not a kernel hacker who knows this 
> > driver, just an advanced user who'd like to give you some more feedback 
> > about your shiny new code.
> 
> This user did get the following messages in dmesg:
> 
> b43err(dev->wl, "Firmware file \"%s\" not found "
>        "or load failed.\n", path);

So the question seems to be why b43 needs version 4, when b43legacy and
bcm43x uses version 3?


Simon Holm Thøgersen

