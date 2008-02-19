Return-Path: <linux-kernel-owner+w=401wt.eu-S1760990AbYBSL3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760990AbYBSL3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbYBSL3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:29:32 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60279 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753305AbYBSL3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:29:31 -0500
Date: Tue, 19 Feb 2008 12:29:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, jbohac@suse.cz,
       kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: Re: notsc is ignored on common configurations
Message-ID: <20080219112952.GA2885@elf.ucw.cz>
References: <20080218133852.GA1573@elf.ucw.cz> <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de> <20080218143757.GB1960@elf.ucw.cz> <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de> <20080219100230.GA1688@elf.ucw.cz> <20080219112632.GA10798@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219112632.GA10798@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-19 12:26:32, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
> > notsc is ignored in 32-bit kernels if CONFIG_X86_TSC is on.. which is 
> > bad, fix it.
> 
> thanks, applied.
> 
> > -static unsigned int ref_freq = 0;
> > -static unsigned long loops_per_jiffy_ref = 0;
> > -static unsigned long cpu_khz_ref = 0;
> > +static unsigned int ref_freq;
> > +static unsigned long loops_per_jiffy_ref;
> > +static unsigned long cpu_khz_ref;
> 
> i have split these changes into the separate patch below.

Yep, thanks.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
