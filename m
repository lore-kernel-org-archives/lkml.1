Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYDBMp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYDBMp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbYDBMpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:45:22 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:59909 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYDBMpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:45:22 -0400
From: Chr <chunkeey@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Wed, 2 Apr 2008 14:45:18 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200803302109.22219.chunkeey@web.de> <200804010130.17453.chunkeey@web.de> <200804012316.16371.rjw@sisk.pl>
In-Reply-To: <200804012316.16371.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021445.19021.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+cJgBD9Dj0vymVmg7AOYrd8aCyRqJxObdDXqln
	nM7+1Xzh2RS2sBxVua61VJV3a8bApA9/JOQgRive/D9WdL5Apb
	h0AUgOvgE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008 23:16:15 Rafael J. Wysocki wrote:
> On Tuesday, 1 of April 2008, Chr wrote:
> > On Tuesday 01 April 2008 01:14:24 Rafael J. Wysocki wrote:
> > > On Tuesday, 1 of April 2008, Chr wrote:
> > >
> > > Have you posted the .config already?
> >
> > Done!
>
> Hmm.  Can you please choose one RTC infrastructure and maybe disable
> CONFIG_HPET_EMULATE_RTC?
well... another hang... but I noticed something while filling a new bugreport.

2.6.25-rc8 /arch/x86/Kconfig

config HPET_TIMER
        def_bool X86_64
        prompt "HPET Timer Support" if X86_32

[...]

config HPET_EMULATE_RTC
        def_bool y

[...]

Geee... there's no way to disable it on x86_64 without messing with the 
Kconfig. So I try to disable the other RTC framework... 
(since there's no sign of any of those RTC mods in the clocksource/timerlist.
I guess it'll be worthless)

Regards,	
	Chr.
