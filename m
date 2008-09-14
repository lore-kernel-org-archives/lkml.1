Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYINTTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYINTTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 15:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbYINTQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 15:16:15 -0400
Received: from www.tglx.de ([62.245.132.106]:58461 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425AbYINTQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 15:16:14 -0400
Date: Sun, 14 Sep 2008 12:15:04 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@suse.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
In-Reply-To: <20080914181228.GA18934@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0809141214110.5283@apollo.tec.linutronix.de>
References: <20080912083113.GA1625@elf.ucw.cz> <alpine.LFD.1.10.0809140455470.5283@apollo.tec.linutronix.de> <20080914100913.GB7909@elf.ucw.cz> <20080914101406.GA1625@elf.ucw.cz> <20080914173536.GA1687@elf.ucw.cz> <alpine.LFD.1.10.0809141049570.5283@apollo.tec.linutronix.de>
 <20080914181228.GA18934@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Sep 2008, Pavel Machek wrote:
> On Sun 2008-09-14 10:51:04, Thomas Gleixner wrote:
> > On Sun, 14 Sep 2008, Pavel Machek wrote:
> > > > It _does_ happen with mainline 2.6.27-rc6.
> > > 
> > > s2ram hs problem in mainline 2.6.26, too. (Different problem: no
> > > ammount pressing shift helps there.) nohz=off cures it, too.
> > 
> > Ok, so it's not a regression.
> > 
> > Is the problem in the suspend path or in the resume ?
> 
> During resume, on both 2.6.26 and 2.6.27-rc6. (27-rc6 actually resumes
> if I keep hitting shift, and I get "sleepy" system after that --
> cursor does not blink, but machine can be used -- as long as I keep
> hitting keys).

Hmm. Can you please provide the output of /proc/timer_list when the
system is in that "sleepy" state.

Thanks,

	tglx
