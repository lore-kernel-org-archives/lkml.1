Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbYIJTh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbYIJTh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYIJTg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:36:59 -0400
Received: from www.tglx.de ([62.245.132.106]:53466 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbYIJTg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:36:58 -0400
Date: Wed, 10 Sep 2008 21:36:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, gregkh@novell.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Oops/Warning report for the week of September 10th, 2008
In-Reply-To: <48C81D20.9040302@linux.intel.com>
Message-ID: <alpine.LFD.1.10.0809102133210.13819@apollo.tec.linutronix.de>
References: <48C81D20.9040302@linux.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Rank 6: tick_dev_program_event (warning)
> 	Reported 110 times
> 	[debug] temporary WARN_ON() inserted in -rc5 for diagnostics purposes,
> removed for -rc6
> 	This warning was last seen in version 2.6.27-rc5-git10, and first seen
> in 2.6.27-rc5.
> 	More info:
> http://www.kerneloops.org/searchweek.php?search=tick_dev_program_event

WARN_ON() is removed in 2.6.27-rc6. It served it's purpose.
 
> Rank 10: tick_broadcast_oneshot_control (oops)
> 	Reported 58 times (1331 total reports)
> 	Some interaction betwee tickless and system with an AMD CPU and an ATI
> chipset
> 	This oops was last seen in version 2.6.25.14, and first seen in
> 2.6.24-rc4.
> 	More info:
> http://www.kerneloops.org/searchweek.php?search=tick_broadcast_oneshot_control

Fixed by the latest updates/fixes to clock events core and hpet
code. Working on a backport to 25/26 right now.

Thanks,

	tglx
