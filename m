Return-Path: <linux-kernel-owner+w=401wt.eu-S1760330AbYGQRA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330AbYGQRA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbYGQRAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:00:16 -0400
Received: from www.tglx.de ([62.245.132.106]:41997 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779AbYGQRAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:00:15 -0400
Date: Thu, 17 Jul 2008 18:59:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard <tuxbox.guru@gmail.com>
cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
In-Reply-To: <487F85C6.9@gmail.com>
Message-ID: <alpine.LFD.1.10.0807171856010.4316@apollo.tec.linutronix.de>
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807162156.00983.trenn@suse.de> <487EECDF.1040401@gmail.com> <alpine.LFD.1.10.0807171211310.4316@apollo.tec.linutronix.de>
 <487F33F2.2060202@gmail.com> <alpine.LFD.1.10.0807171306110.4316@apollo.tec.linutronix.de> <487F39AC.3060805@gmail.com> <alpine.LFD.1.10.0807171400090.4316@apollo.tec.linutronix.de> <487F85C6.9@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Richard wrote:
> 
> Here you go.. a 2.6.26-tip dmesg  (the top seems to be missing for some
> reason!) .. just shout if you need the bits on the top.

Those are the interesting ones :)

Questions: 

Are CONFIG_HIGHRES_TIMERS and CONFIG_NO_HZ enabled ?
Is it still necessary to add any command line option ?
Is the system stable ?

Also please provide the output of

# cat /sys/devices/system/clocksource/clocksource0/current_clocksource

and

# cat /proc/timer_list

Thanks,

	tglx
