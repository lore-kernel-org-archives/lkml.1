Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYAAQtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYAAQtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYAAQtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:49:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41750 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYAAQta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:49:30 -0500
Date: Tue, 1 Jan 2008 17:48:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20080101164855.GA3488@elte.hu>
References: <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl> <20071230160751.GB26221@elte.hu> <4777C6E8.7060202@keyaccess.nl> <20071230170612.GA16502@elte.hu> <20071230182937.40f2adcf@the-village.bc.nu> <20071230204650.GA26120@elte.hu> <20071231131107.GA26339@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231131107.GA26339@ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > well, using io_delay=udelay is not 'blindly disabling'. 
> > io_delay=none would be the end goal, once all _p() API uses are 
> > eliminated by transformation. In drivers/ alone that's more than 
> > 1000 callsites, so it's quite frequently used, and wont go away 
> > overnight.
> 
> IOW elimination of broken inb_p()/outb_p() interfaces is the ultimate 
> goal. Agreed.

yeah - although i'd not call it "broken", it's simply historic, and due 
to the side-effects of the _implementation_, a few non-standard uses 
(such as reliance on PCI posting/flushing effects) grew.

	Ingo
