Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbYC3UTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbYC3UTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYC3USz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:18:55 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:57038 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYC3USz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:18:55 -0400
From: Chr <chunkeey@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Sun, 30 Mar 2008 22:18:51 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200803302109.22219.chunkeey@web.de> <200803302125.10817.rjw@sisk.pl> <alpine.LFD.1.10.0803302156210.3219@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0803302156210.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803302218.52549.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/kNM40BqLsDPcQd1+Os5JJjniupo1YOS/qSKq/
	cJUVq6s/bUczOWjp1JxQbHmWZ2iJa5T33X2tqbuEYV0ZEuFR4q
	hcmSwv+8I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 March 2008 21:59:51 Thomas Gleixner wrote:
> On Sun, 30 Mar 2008, Rafael J. Wysocki wrote:
> > > So. take a look at stuck_task... that's best backtrace I could get...
> > > (I have other logs too. (Task-list / Lockdep / ... ) but it's too much
> > > and I hope the _logs_ are already enough.
> > >
> > > BTW: I noticed that the clock seems to jump forward and backwards.
> > > Is this because the CPU-Cores aren't syncronized? (And why are they
> > > out of sync?)
>
> The cores of those AMD beasts are never in sync. That's a chip feature :)
>
> Can you please provide the output of:
>   /sys/devices/system/clocksource/clocksource0/current_clocksource
>
> for both 2.6.24 and 2.6.25-rc7
it's "hpet" (in both cases...)

Regards,
	Chr

