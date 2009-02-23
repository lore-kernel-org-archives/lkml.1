Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZBWVjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZBWVjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZBWVje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:39:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41913 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbZBWVjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:39:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Mon, 23 Feb 2009 22:39:04 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902231203.09082.rjw@sisk.pl> <m18wnx41h5.fsf@fess.ebiederm.org>
In-Reply-To: <m18wnx41h5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902232239.05926.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Eric W. Biederman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> >> I don't know where in the state machine this is getting called but
> >> I would suggest doing this before we shutdown cpus.
> >
> > This is the plan.  In fact, I'm going to do this in the next patch after the
> > $subject one has been tested and found acceptable.
> 
> Good to hear.  Then let's please get a version of the irq disable that calls
> shutdown, so we can be certain we don't have hardware irqs in flight.
> 
> For the drivers it should not matter for clean cpu shutdown it will.

OK, I will.

Thanks,
Rafael
