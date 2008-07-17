Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYGQKwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYGQKwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 06:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbYGQKwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 06:52:15 -0400
Received: from www.tglx.de ([62.245.132.106]:39907 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbYGQKwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 06:52:14 -0400
Date: Thu, 17 Jul 2008 12:51:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard <tuxbox.guru@gmail.com>
cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
In-Reply-To: <487EECDF.1040401@gmail.com>
Message-ID: <alpine.LFD.1.10.0807171211310.4316@apollo.tec.linutronix.de>
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807162156.00983.trenn@suse.de> <487EECDF.1040401@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Richard wrote:
> Thomas Renninger wrote:
> > I have no idea.
> > Richard's last message:
> > "I can help out as needed, just a work deadline I have to meet so I haven't
> > been able to dig further.  Just point me in the direction and I'll gladly be
> > someones hands on the beastly machine"
> > 
> > has silently be ignored.

Sorry, was not on my radar.

> > > Which chipset is involved here ? SB400/600 perhaps ?
> > >     
> > No, it is probably much older and I am pretty sure that it is not chipset
> > related, but related to the "Mobile" in the Mobile Sempron as this exactly
> > seem to hit 3500 and 3600 Mobile Sempron CPUs.
> > 
> > I can't help much further because:
> >   - I have not such a machine
> >   - I don't know these parts. I hoped to get some hints to help these guys
> > 
> >        Thomas
> > 
> >   
> Hi All,
> 
> I am still available to hack away :-) I would also like to get this bug
> resolved but I feel I am out of my depth with this problem. (Embedded
> PowerPC's are my toys)
>
> As a quick test, I grabbed the 2.6.26 kernel and built it... but
> alas, it broke... well, from my ill-educated guess, it looked like
> acpid done something and the machine shut down.

ouch.

I read the whole thread and also checked the suse bugzilla, which
confuses the hell out of me as there is reported that kubuntu with
2.6.24 works and everything suse > 2.6.20 does not.

Can you please tell me the symptoms of vanilla 2.6.25 without nohz=off
on the kernel command line ?

Thanks,

	tglx
