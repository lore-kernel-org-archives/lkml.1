Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbYEENBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbYEENBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYEENA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:00:56 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47115 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbYEENAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:00:55 -0400
Date: Mon, 5 May 2008 09:00:55 -0400
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       jamal <hadi@cyberus.ca>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
Message-ID: <20080505130055.GB6957@csclub.uwaterloo.ca>
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <1209834123.6972.48.camel@localhost> <20080503173402.GA5292@elte.hu> <alpine.LFD.1.10.0805031936510.6003@apollo.tec.linutronix.de> <alpine.LNX.1.10.0805042326340.11757@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0805042326340.11757@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 11:31:00PM +0200, Jan Engelhardt wrote:
> Guess that Intel named it Pentium II either because Hexium
> ("5"86:Pentium, "6"86:Hexium) would have been a strange name, or the
> successor to the Pentium/586 was not that great an improvement.
> Or something else? Always kept me wondering.

Well the brand was well recognized, so they called the P6 "Pentium Pro".
Then when they went to make a cheaper version for regular consumers,
they made the Pentium II based on the PPro, by making the L2 cache half
speed (the PPro ran L2 cache at full speed) and put the L2 cache on a
PCB with the core in a cartridge.  After a while they added SSE and
called it the Pentium !!! (check the logo, they really used exclamation
marks) and a while later they managed to shrink their process enough
that they could integrate the L2 cache on die, so they made the cache
full speed again but on the same die as the cpu core, and soon after
started offering plain CPUs again rather than cartridges.  The Pentium 4
is of course a totally unrelated design.  The Pentium M followed up on
the P3 but aiming for lower power consumption rather than maximum
performance, and later evolved into the Core and then Core 2 (where
again they focused on maximum performance).  I think the Pentium 4 may
have tarnished the Pentium brand enough that they needed a new name, and
hence "Core" came about.

-- 
Len Sorensen
