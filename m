Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYC3VKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYC3VKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYC3VJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:09:55 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:44077 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYC3VJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:09:54 -0400
From: Chr <chunkeey@web.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with 2.6.25-rc7
Date: Sun, 30 Mar 2008 23:09:52 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200803302109.22219.chunkeey@web.de> <200803302218.52549.chunkeey@web.de> <alpine.LFD.1.10.0803302236180.3219@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0803302236180.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803302309.52493.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+czcmYn07nO9507hqzNtqJlGG5tYjJIyAQ9F3U
	yeTjhZwbn2Bj98gDxvxx1/C5Yp9uUaBo6NWjDs55bRT4TZ/0MS
	5LcJoNpRg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 March 2008 22:37:29 Thomas Gleixner wrote:
> On Sun, 30 Mar 2008, Chr wrote:
> > On Sunday 30 March 2008 21:59:51 Thomas Gleixner wrote:
> > > On Sun, 30 Mar 2008, Rafael J. Wysocki wrote:
> > > > > So. take a look at stuck_task... that's best backtrace I could
> > > > > get... (I have other logs too. (Task-list / Lockdep / ... ) but
> > > > > it's too much and I hope the _logs_ are already enough.
> > >
> > > The cores of those AMD beasts are never in sync. That's a chip feature
> > > :)
> > >
> > > Can you please provide the output of:
> > >   /sys/devices/system/clocksource/clocksource0/current_clocksource
> > >
> > > for both 2.6.24 and 2.6.25-rc7
> >
> > it's "hpet" (in both cases...)
>
> Hmm. That should be stable. Which clock is jumping back and forth ?
> The one in the logs or the system clock ?
The one in the logs... (but it's because of the TSC, right?)

Regards,
	Chr
