Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbXCNSV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbXCNSV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXCNSV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:21:56 -0400
Received: from www.osadl.org ([213.239.205.134]:40262 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752763AbXCNSV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:21:56 -0400
Subject: Re: [6/6] 2.6.21-rc3: known regressions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Florian Lohoff <flo@rfc822.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070314180209.GA15640@paradigm.rfc822.org>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org>
	 <20070313125025.GW18731@stusta.de>
	 <1173818777.13341.128.camel@localhost.localdomain>
	 <20070314114417.GB18731@stusta.de>
	 <20070314180209.GA15640@paradigm.rfc822.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 19:28:36 +0100
Message-Id: <1173896916.13341.167.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 19:02 +0100, Florian Lohoff wrote:
> On Wed, Mar 14, 2007 at 12:44:17PM +0100, Adrian Bunk wrote:
> > > > Due to the huge amount of recipients, please trim the Cc when answering.
> > > > Subject    : Clocksource tsc unstable (delta = -154983451 ns)
> > > > References : http://lkml.org/lkml/2007/3/9/271
> > > > Submitter  : Jiri Slaby <jirislaby@gmail.com>
> > > > Status     : unknown
> > > 
> > > That's not a regression. That's an informal message, when the TSC
> > > watchdog detects that the TSC is unreliable. 
> > 
> > Looking at [1], there's also be a probably related "doesn't boot" 
> > problem.
> > My first guess would be commit 6bb74df481223731af6c7e0ff3adb31f6442cfcd
> > "clocksource init adjustments (fix bug #7426)".
> > 
> > Jiri, is the message also present with 2.6.21-rc2 (at a different place 
> > of the dmesg) for you?
> 
> With the current git of today the halt on boot is gone. I am running 
> it now ...

I'm really curious what made it go away.

	tglx


