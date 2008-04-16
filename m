Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbYDPLv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbYDPLv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 07:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbYDPLvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 07:51:19 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:38880 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602AbYDPLvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 07:51:18 -0400
Message-ID: <4805E59E.1020607@aitel.hist.no>
Date: Wed, 16 Apr 2008 13:40:14 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Western Digital GreenPower drives and Linux
References: <200804092118.35501.tvrtko@ursulin.net>
In-Reply-To: <200804092118.35501.tvrtko@ursulin.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko A. Ursulin wrote:
> Hi all,
>
> The subject may be a bit misleading since I haven't investigated the whole 
> issue under other OS-es (nor do I plan to), but this is how the story goes..
>
> Those fancy new WD GreenPower drives seem to be heavily suffering from the 
> rapidly increasing head load/unload problem. And the bad thing is they don't 
> respond to 'hdparm -B', which would mean (I think) their power management 
> behaviour is solely up to their firmware.
>
> I got one of them (WD5000AACS) recently and to my horror after less than three 
> days of being power on this is what I saw:
>
> 9 Power_On_Hours       0x0032 100 100 000 Old_age Always  - 66
> 193 Load_Cycle_Count 0x0032 197 197 000 Old_age  Always  - 10233
>
> At this rate the disk would reach it's design limit for load/unload cycles in 
> around 80 days. Not good - so I implemented a lame workaround of keeping disk 
> busy every couple of seconds - hopefully that won't kill it sooner that 
> unloads would..
>   
Yuck, how stupid!
But the solution is simple. Make sure to get a warranty of much more
than 80 days. Use RAID-1 (or backup often).
Just let those disks destroy themselves (they _are_ faulty) and
get new ones all the time.  As long as they make them this stupid, you won't
have to buy new disks again. Free warranty replacements forever.

To be a bit more constructive, tell them about this strategy. Perhaps 
they get
busy fixing the firmware?

Helge Hafting
