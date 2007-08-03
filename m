Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbXHCMyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbXHCMyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 08:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbXHCMyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 08:54:12 -0400
Received: from mailout08.sul.t-online.de ([194.25.134.20]:54901 "EHLO
	mailout08.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756287AbXHCMyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 08:54:11 -0400
Message-ID: <46B32561.5070703@t-online.de>
Date: Fri, 03 Aug 2007 14:53:53 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>, trenn@suse.de,
       pavel@ucw.cz, mjg59@srcf.ucam.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.22 regression: thermal trip points
References: <46B1988C.3090302@t-online.de> <200708021756.30776.lenb@kernel.org>
In-Reply-To: <200708021756.30776.lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-ID: bdi2PQZOgevNddpIqULiRwFExsDpDYG2+zPxu5yv9yRB2GB-z+KIsg
X-TOI-MSGID: 0a6a8117-c84d-4313-a2eb-9e9d17dadcb8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown :
>  
>
> Thanks for the sighting, Knut!
> This regression is dramatic when put in the terms of 50% performance hit!
> I guess the good news is that thermal throttling is doing the job
> we are asking it to:-)
>
>
>   
Thermal management by cpufreq is working really fine ;-)

My problems are definitely not related to a linux bug. All trip_points
are fixed, hardcoded in the system BIOS at address 0x000FF810.

Yes, I could hack  and flash a custom BIOS.

After reading a lot I think I even could fix the DSDT.

But all that would only be a solution for my system. The principal
question is, if that hook that allowed to override unreasonable
trip point definitions is too dangerous to be a part of the linux kernel.

You and some others believed it should not be part of the kernel,
and so it was eliminated a while ago. Some people want it back,
either because
- they need it desperately to allow their machines healthy operation,
- they need it to restore performance of their machines, or
- they want a really quiet system.

Root should be allowed to smoke his system - ask him if he really
wants to do so, ask him to echo "Yes, it´s me who is guilty" to
some file prior to allow trip point changes, but do not eliminate
hooks useful for the management of buggy machines from our
kernel.

We do need writable trip points again. And, Thomas, some people
also need to raise the defaults.

cu,
 Knut
