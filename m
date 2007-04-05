Return-Path: <linux-kernel-owner+w=401wt.eu-S1161223AbXDEGCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161223AbXDEGCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161224AbXDEGCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:02:20 -0400
Received: from www.osadl.org ([213.239.205.134]:49361 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161223AbXDEGCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:02:19 -0400
Subject: Re: + clocksource-driver-initialize-list-value.patch added to -mm
	tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, johnstul@us.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, heiko.carstens@de.ibm.com
In-Reply-To: <1175733279.15973.116.camel@imap.mvista.com>
References: <200704010523.l315NXJP004063@shell0.pdx.osdl.net>
	 <1175417035.28263.42.camel@localhost.localdomain>
	 <1175704712.15973.35.camel@imap.mvista.com>
	 <20070404125853.1cf9b7b7.akpm@linux-foundation.org>
	 <1175717425.15973.61.camel@imap.mvista.com>
	 <20070404203647.GA12563@elte.hu>
	 <1175719489.15973.66.camel@imap.mvista.com>
	 <20070404211514.GA18600@elte.hu>
	 <1175722246.15973.78.camel@imap.mvista.com>
	 <20070404213404.GA21742@elte.hu>
	 <1175723954.15973.96.camel@imap.mvista.com>  <46143941.7050702@goop.org>
	 <1175731253.15973.106.camel@imap.mvista.com>  <461440C9.8040902@goop.org>
	 <1175733279.15973.116.camel@imap.mvista.com>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 08:02:33 +0200
Message-Id: <1175752953.28263.374.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 17:34 -0700, Daniel Walker wrote:
> > The fact that a list is used to string together clocksource structures
> > is an internal detail of the clock subsystem.  It's annoying that there
> > has to be a list head in the clocksource structure, but at least as a
> > clocksource implementer I can ignore it, and if it ever gets changed to
> > something else I can keep ignoring it.  Your change makes it something
> > that gets pointlessly replicated all over the kernel.
> 
> It's already been discussed in the past, but the clocksource structure
> is already very simple.. Adding a list initializer doesn't change
> anything..

And it does not gain anything. 

So what's the gain of this ? Nine useless entries in the changelog.

	tglx


