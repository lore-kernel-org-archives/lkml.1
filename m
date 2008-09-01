Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYIAPg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYIAPg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYIAPgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:36:48 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:44202 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719AbYIAPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:36:48 -0400
Message-ID: <48BC0C1C.9050205@lwfinger.net>
Date: Mon, 01 Sep 2008 10:37:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> 
>> +Clocksource tsc unstable (delta = 500037272 ns)
> 
>> -Clocksource tsc unstable (delta = 83950402 ns)
> 
> In both cases the TSC is ahead of the pm_timer, which looks like the
> pm_timer is behaving strange.
> 
> Can you please disable the pm_timer (in the kernel config,
> unfortunately there is no command line option for that) for a test and
> provide the relevant output of demsg ?

I manually deleted CONFIG_X86_PM_TIMER from .config, but it returns 
silently. The only way I see to turn off the pm_timer is to disable 
power management. Is that what I need to do?

Larry
