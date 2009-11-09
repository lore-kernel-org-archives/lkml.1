Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZKIQTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZKIQTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZKIQTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:19:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:33950 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750851AbZKIQTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:19:11 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+/wkIt/lK/NqVy0CojV0eGZTE/ILaB5iDKjk0Tky
	h33N+rTDJ/xTCt
Subject: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to
 preempt_count leakage in keventd
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <200911091647.54171.rjw@sisk.pl>
References: <200911091250.31626.rjw@sisk.pl>
	 <200911091527.12249.rjw@sisk.pl>
	 <1257777040.6365.15.camel@marge.simson.net>
	 <200911091647.54171.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 17:19:13 +0100
Message-Id: <1257783553.6408.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 16:47 +0100, Rafael J. Wysocki wrote:
> On Monday 09 November 2009, Mike Galbraith wrote:

> > > Very likely.  What did you do to fix it?
> > 
> > You don't really wanna know.  In 31 with newidle enabled, the below
> > fixed it.  It won't fix 32, though it might cure the resume problem.
> 
> OK, I'll give it a try.

I just tried to trigger badness via high speed online/offline combined
with taskset with CONFIG_PREEMPT enabled, and couldn't make it explode.

(damn, wish i could s2ram this box)

	-Mike

