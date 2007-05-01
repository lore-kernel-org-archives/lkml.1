Return-Path: <linux-kernel-owner+w=401wt.eu-S1030844AbXEAEdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030844AbXEAEdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031585AbXEAEdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:33:53 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:57925 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030844AbXEAEdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:33:51 -0400
Subject: Re: [BUG] 2.6.21: Kernel won't boot with either/both
	of	CONFIG_NO_HZ, CONFIG_HIGH_RES_TIMERS
From: Daniel Walker <dwalker@mvista.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Linus Torvalds <torvalds@osdl.org>
In-Reply-To: <4636B4F9.6040406@rtr.ca>
References: <46364EBC.5050804@rtr.ca> <46364F5A.2030208@rtr.ca>
	 <463653A3.5040606@rtr.ca> <46367D7E.6060502@rtr.ca>
	 <1177976798.12796.286.camel@imap.mvista.com> <463683A6.4010505@rtr.ca>
	 <6bffcb0e0704301707w7287f1bdk32be8bc8ce7cda80@mail.gmail.com>
	 <463685BD.8010604@rtr.ca> <1177978391.12796.301.camel@imap.mvista.com>
	 <4636B4F9.6040406@rtr.ca>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 21:32:13 -0700
Message-Id: <1177993933.12796.314.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 23:33 -0400, Mark Lord wrote:
> Daniel Walker wrote:
> > 
> > I'm interested in which clocksource is getting used, which is in the
> > boot log.
> 
> Well then, send me a patch that dumps that information out just before it locks up.
> We know (first post in this thread) that the lockup occurs just after
> these two messages:
> 
>   "switched to high resolution mode on cpu 1"
>   "switched to high resolution mode on cpu 0"
> 
> So just dump out anything else you need to see at the same time,
> and it'll still be on my screen when the darned thing locks up.
> 
> Simple, eh.  We both get to run around a treadmill this way.  ;)

I guess I could make due with the successful boot (less running for us
both).. It's using the hpet clocksource .. You could try adding
clocksource=acpi_pm to the boot args , in the off chance it's an hpet
clock issue.

Daniel

