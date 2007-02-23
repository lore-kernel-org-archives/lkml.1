Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXBWLmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXBWLmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbXBWLmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:42:05 -0500
Received: from www.osadl.org ([213.239.205.134]:57237 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932162AbXBWLmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:42:03 -0500
Subject: Re: Linux 2.6.21-rc1
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, dwalker@mvista.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070223113500.GB1177@elte.hu>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
	 <20070223020829.40e5fac3.akpm@linux-foundation.org>
	 <20070223113500.GB1177@elte.hu>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 12:47:14 +0100
Message-Id: <1172231235.25076.251.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 12:35 +0100, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I already bisected this on my old pIII, which has the same problem: 
> > clockevents-i386-drivers.patch
> 
> yes - we know what the problem is (and will fix it): the stopping of the 
> PIT - nmi_watchdog=1 is hack to use the IO-APIC's PIT pin to also signal 
> NMIs.
> 
> Just to clarify, this problem does not occur if HIGH_RES_TIMERS is off, 
> correct?

It does, as we switch off PIT when lapic is available in any case.

	tglx


