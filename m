Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYKECJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYKECJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 21:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYKECJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 21:09:49 -0500
Received: from rtr.ca ([76.10.145.34]:34079 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbYKECJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 21:09:48 -0500
Message-ID: <49110093.5090506@rtr.ca>
Date: Tue, 04 Nov 2008 21:10:27 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Robert Hancock <rwh461@mail.usask.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata hibernation fixes
References: <fa.Ast7pgG6P20u1PcyOsfgzoaX5YA@ifi.uio.no> <fa.1+JQHm7yjIiZJxAzR0eBPn39a9M@ifi.uio.no> <fa.8GbzH83c2CAI53n9dyzVOFugmoc@ifi.uio.no> <fa.hGdpNHQGmXAR19JiGuHxSr9N9CA@ifi.uio.no> <4910E6CD.9090605@mail.usask.ca>
In-Reply-To: <4910E6CD.9090605@mail.usask.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>
> IDLE IMMEDIATE just transitions the device to the Idle state, which is 
> normally parked/unloaded and spun down.
..

No, you're confusing "IDLE" with "STANDBY".  IDLE just puts the drive
electronics into a lower-power state than "ACTIVE", but normally leaves
the platters spinning.

The "UNLOAD" enhancement causes it to also "unload" or "park" (drive's option)
the heads as part of this action.

"STANDBY" is the command set which parks heads and spins down the platters.

Cheers
