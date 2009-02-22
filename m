Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZBVS0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZBVS0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 13:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZBVSZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 13:25:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46168 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbZBVSZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 13:25:56 -0500
Date: Sun, 22 Feb 2009 10:25:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 0/2] Rework disabling of interrupts during
 suspend-resume
In-Reply-To: <20090222181841.GA17895@elte.hu>
Message-ID: <alpine.LFD.2.00.0902221024500.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0902221007150.3111@localhost.localdomain> <20090222181841.GA17895@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Feb 2009, Ingo Molnar wrote:

> 
> > +	.flags 		= IRQF_DISABLED | IRQF_NOBALANCING, IRQF_TIMER,
> > +	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL, IRQF_TIMER,
> > +	.flags = IRQF_DISABLED | IRQF_NOBALANCING | IRQF_IRQPOLL, IRQF_TIMER,
> 
> s/, IRQF_TIMER/ | IRQF_TIMER
> 
> i guess.

Oops yes. I got one of them right. I guess that's the same one I happened 
to compile in my config. Duh.

		Linus
