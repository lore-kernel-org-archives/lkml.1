Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbXFZLsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbXFZLsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 07:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbXFZLsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 07:48:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58657 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbXFZLsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 07:48:15 -0400
Message-ID: <4680FCF8.4090403@garzik.org>
Date: Tue, 26 Jun 2007 07:48:08 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Hannu Savolainen <hannu@opensound.com>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <s5h4pkwi9u0.wl%tiwai@suse.de> <4680310D.6060206@opensound.com>
In-Reply-To: <4680310D.6060206@opensound.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hannu Savolainen wrote:
> Also we would like to stop the silly OSS vs ALSA war. OSS and ALSA are 
> rather different. Both of them have some good points and bad points. For 
> ordinary users it doesn't matter which API is used by the applications 
> as long as they work. Just the application developers can see the real 
> difference. Some of them prefer OSS while some other prefer ALSA and 
> this should be their "freedom of choice".
> 
> I think the ideal solution would be that both ALSA and OSS APIs can 
> co-exist by sharing the same low level drivers (which has already been 
> demonstrated). The low level driver interfaces in both systems are 
> practically identical. This means that ALSA's core can work with OSS' 
> drivers and vice versa.
> 
> Today both OSS and ALSA teams have to spend significant amounts of time 
> in emulating the "alien" APIs. Making OSS and ALSA to co-exist will 
> require some work in both sides but that should be nothing when compared 
> to the effort required for emulation.

Speaking as another OSS driver author and maintainer, who ACK'd the move 
to ALSA...

In Linux we typically do not do two APIs and codebases for the same 
purpose.  If we do, like sys_mmap and sys_mmap2, it's an older legacy 
interface that never changes, that we are moving people AWAY from, and a 
newer interface.

I see no reason to change from the path at which upstream has arrived: 
OSS is a legacy API that's frozen in time, and ALSA provides the new stuff.

If you have ALSA criticisms, the right thing to do is fix ALSA. 
Upstream OSS was a dead-end code duplication & maintenance nightmare.  I 
know.  I was doing some of that maintenance and driver writing.

	Jeff


