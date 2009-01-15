Return-Path: <linux-kernel-owner+w=401wt.eu-S934791AbZAOVD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934791AbZAOVD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933402AbZAOUco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:32:44 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:43839 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932354AbZAOUcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:32:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAIksb0lMQWt2/2dsb2JhbACBbM0nhXE
Date: Thu, 15 Jan 2009 15:32:28 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Gaurav Singh <gausinghnsit@gmail.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: PMC support for ARMv6
Message-ID: <20090115203228.GA4284@Krystal>
References: <3cc7a0df0901132148r1a3c0fa8q4c8d5912655eccc2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <3cc7a0df0901132148r1a3c0fa8q4c8d5912655eccc2@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:27:06 up 14 days, 20:25,  3 users,  load average: 0.46, 0.52,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gaurav Singh (gausinghnsit@gmail.com) wrote:
> Hi Mathieu / all,
> I have integrated PMC in ARMv6 primarily for 2 aims:
> 1. CPI calculations - this trace_mark is triggered triggered after X no. of
> clock cycles. The number of instructions executed and the no. of clock
> cycles is noted.
> 2. Cache Hit rate calculation - Here I have not used the PMC registers in
> the ARM processor - rather have used L2 Cache controller  registers to find
> out this information - but this does not provide information about the L1
> cache hit/miss behaviour.
> 
> Any other suggestions on what else can be done in PMC?
> 

I'd like to see this trace_mark turned into a tracepoint probe. Having a
periodical interrupt which saves this information is good, but I would
also like to have a tracepoint probe that we could attach at important
execution sites, like sched change, irq, softirq, nmi entry/exit where
we would read the performance counter.


> Also have ported LTTng to 2.6.24 for two Nomadik Boards - NDK15 and
> NDK20. Doing some tests and will send it over to you guys soon for your
> comments.
> 

I'd be interested in merging your patchesfor 2.6.28 into the LTTng tree.
Please keep us posted.

Mathieu

> Cheers!
> Have a Nice Day!
> Gaurav

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
