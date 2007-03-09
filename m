Return-Path: <linux-kernel-owner+w=401wt.eu-S2993141AbXCIVLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993141AbXCIVLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993140AbXCIVLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:11:53 -0500
Received: from rune.pobox.com ([208.210.124.79]:47367 "EHLO rune.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993141AbXCIVLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:11:52 -0500
From: Rodney Gordon II <meff@pobox.com>
To: ck@vds.kolivas.org
Subject: Re: [ck] [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Fri, 9 Mar 2007 15:11:45 -0600
User-Agent: KMail/1.9.5
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <200703041800.53360.kernel@kolivas.org>
In-Reply-To: <200703041800.53360.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091511.46111.meff@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007 01:00, Con Kolivas wrote:
> This message is to announce the first general public release of the
> "Rotating Staircase DeadLine" cpu scheduler.
>
> Based on previous work from the staircase cpu scheduler I set out to
> design, from scratch, a new scheduling policy design which satisfies every
> requirement for SCHED_NORMAL (otherwise known as SCHED_OTHER) task
> management.
>

Con, you've really outdone yourself this time ! :D

As a long time user of the -ck patchset, RSDL is a welcome change, and a great 
piece of code to play around with, and USE!

Booted up on my system perfectly, Pentium-D 830 3GHz, 1.5GB RAM.

No problems whatsoever so far, using 0.26. I can launch up a bunch of encode 
jobs, in SCHED_NORMAL even, and still have low latency on my desktop (I know 
it's not low latency _specific_ code, but it works very well).

I guess all I can say is.. wow. This code isn't "prime time" ready, yet.. But 
it can be, and would be a great addition to mainline.

Hell, a little tuning and merging this with a few current ck patches could 
make a damn fine kernel, and probably beat out the original staircase in 
desktops. :)

Keep up the good work !
-r

-- 
Rodney "meff" Gordon II -*- meff@pobox.com
Systems Administrator / Coder Geek -*- Open yourself to OpenSource
