Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbYAIBFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbYAIBFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757769AbYAIA7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:59:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35431 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758005AbYAIA7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:59:24 -0500
Message-ID: <47841C41.4060401@zytor.com>
Date: Tue, 08 Jan 2008 16:58:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew <jackdachef@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fwd: Fwd: laptop / computer hardlocks during execution of 32bit
 applications(binaries) on 64bit system (Gentoo)
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com>	 <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com>	 <200712300128.35476.mboton@gmail.com> <20080102084002.GA13636@elte.hu>	 <e85b9d30801080333y3d6668ccgf20f9666d0326884@mail.gmail.com> <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>
In-Reply-To: <e85b9d30801080340y43fbd4c0sa9b6c9811c7391a1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew wrote:
> Hi everyone,
> 
> sorry for the long delay
> 
> - I first had to get home & set up my rig to reproduce this hardlock
> (repeatedly hardlocking / shutting down the laptop doesn't do too good
> to the new hdd ;) )
> 
> and fortunately I was successful :)
> 
> sorry for the bad quality of the pics (they were taken with my phone):
> 
> http://omploader.org/vYWU1/moto_0025.jpg
> http://omploader.org/vYWU2/moto_0026.jpg
> 
> steps to reproduce:
> 1.) log on
> 2.) startx
> 3.) opening some pure 64bit apps == working, no locks
> 4.) opening 32bit-apps (such as firefox-bin, thunderbird-bin) == hard
> lock, only pulling power cord (on laptop) or reset button (rig) works,
> magic sysrq key doesn't (keyboard & mouse == dead)
> 
> I'm currently writing from my "rescue system" (winxp ;) )
> so if you need my kernel-config or some more info of the system please tell
> 

I have been unable to reproduce your problem here, and I notice you have
the proprietary, highly invasive and closed-source Nvidia driver
installed in your kernel.

Can you try using the "nv" or "vesa" (unaccelerated) Xorg drivers and
reproduce the problem that way?

If you *do* reproduce the problem that way, it would be extremely 
helpful if you could enable CONFIG_DEBUG_INFO and provide the vmlinux 
(not vmlinuz/bzImage) file that goes with the crash dump screenshot.

Thanks!

         -hpa
