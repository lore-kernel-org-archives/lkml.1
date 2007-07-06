Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbXGFFQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbXGFFQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 01:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbXGFFQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 01:16:11 -0400
Received: from www.osadl.org ([213.239.205.134]:46016 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752834AbXGFFQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 01:16:11 -0400
Subject: Re: 2.6.21.5 june 30th to july 1st date hang?
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ernie Petrides <petrides@redhat.com>,
       Clemens Koller <clemens.koller@anagramm.de>,
       Chris Wright <chrisw@sous-sol.org>, Uli Luckas <u.luckas@road.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <468D828B.4060008@nortel.com>
References: <200707052312.l65NCjfb025915@pasta.boston.redhat.com>
	 <468D828B.4060008@nortel.com>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 07:16:08 +0200
Message-Id: <1183698968.3289.48.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 17:45 -0600, Chris Friesen wrote:
> Ernie Petrides wrote:
> 
> > That's odd, because Thomas's patch removed two calls to clock_was_set(),
> > which is a no-op when CONFIG_HIGH_RES_TIMERS is not enabled (at least in
> > the 2.6.21 source tree).
> 
> I'm using a modified 2.6.10 tree...I expect the timer code is different.

Way different and you have extra patches on top.

	tglx


