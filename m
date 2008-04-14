Return-Path: <linux-kernel-owner+w=401wt.eu-S1761722AbYDNPMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722AbYDNPMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbYDNPMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:12:15 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:48868 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbYDNPMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:12:14 -0400
From: Chr <chunkeey@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #10369] The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Mon, 14 Apr 2008 17:12:08 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <200804132237.10401.chunkeey@web.de> <alpine.LFD.1.10.0804140940200.3261@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0804140940200.3261@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141712.08086.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+8ThP0i4j15q7BamvPKSdnyWaILOW7sE9Lotfa
	H9W+QJm4yxsSRAoo8t0NWtsr146kcdHqSyeX8D5xSWypd0vdvo
	oOJzXzz0Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008 14:51:50 Thomas Gleixner wrote:
> On Sun, 13 Apr 2008, Chr wrote:
> > On Sunday 13 April 2008 22:02:08 Thomas Gleixner wrote:
> > > The problem still persists and I have no clue at all what's the root
> > > cause. The symptom is a stuck local apic timer interrupt as we have
> > > seen it on those AMD X2 systems with C1E enabled. This box does not
> > > advertise C1E, but the behaviour is the same.
> > >
> > But, on the other hand... does ANYBODY know a way how I can see if the
> > apictimer drifts/(getting slower and slower)?
>
> Well, it does not drift. It's stopped by some magic, but I do not
> understand why we do not see that behaviour in 2.6.24. The code logic
> in this area is really unchanged.
>
> Can you disable CPUIDLE for a test please ?

Yep, I will disable CPUIDLE and report back on friday night/saturday afternoon 
CEST.

(maybe, bisect too... with a bit of luck, I can do it better than log(n) ;-) )

Regards,
	Christian
