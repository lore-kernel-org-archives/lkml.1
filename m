Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbYDNMwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbYDNMwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYDNMwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:52:00 -0400
Received: from www.tglx.de ([62.245.132.106]:55731 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbYDNMv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:51:59 -0400
Date: Mon, 14 Apr 2008 14:51:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chr <chunkeey@web.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10369] The never ending BEEEEP/__smp_call_function_mask
 with 2.6.25-rc7
In-Reply-To: <200804132237.10401.chunkeey@web.de>
Message-ID: <alpine.LFD.1.10.0804140940200.3261@apollo.tec.linutronix.de>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <oq66hWjeF4N.A.ch.w3lAIB@albercik> <alpine.LFD.1.10.0804132156570.3261@apollo.tec.linutronix.de> <200804132237.10401.chunkeey@web.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008, Chr wrote:
> On Sunday 13 April 2008 22:02:08 Thomas Gleixner wrote:
> >
> > The problem still persists and I have no clue at all what's the root
> > cause. The symptom is a stuck local apic timer interrupt as we have
> > seen it on those AMD X2 systems with C1E enabled. This box does not
> > advertise C1E, but the behaviour is the same.
> >
> > Christian, it would be great if you could bisect the git tree so we
> > get an idea which patch is exposing this problem. My feeling is that
> > the problem itself is there with 2.6.24 as well but not
> > exposed. That's just a gut feeling and I could be wrong as usual.
> 
> Ok! The biggest problem however is: I can only run bisects on weekends. :-(
> And even then: it takes up to 2 hours until the timer gets stuck... and the 
> system freezes...

Oh well, that's a bad idea then.

> But, on the other hand... does ANYBODY know a way how I can see if the 
> apictimer drifts/(getting slower and slower)?

Well, it does not drift. It's stopped by some magic, but I do not
understand why we do not see that behaviour in 2.6.24. The code logic
in this area is really unchanged.

Can you disable CPUIDLE for a test please ?

Thanks,
	tglx


