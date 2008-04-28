Return-Path: <linux-kernel-owner+w=401wt.eu-S937018AbYD1Qz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937018AbYD1Qz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965295AbYD1Qzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:55:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965284AbYD1Qzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:55:31 -0400
Date: Mon, 28 Apr 2008 09:54:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <alpine.LFD.1.10.0804281845250.3261@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0804280953570.3119@woody.linux-foundation.org>
References: <1209327591.14173.74.camel@brick> <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804280924270.3119@woody.linux-foundation.org>
 <alpine.LFD.1.10.0804281845250.3261@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Apr 2008, Thomas Gleixner wrote:

> On Mon, 28 Apr 2008, Linus Torvalds wrote:
> > >
> > > How about making the optimization controlled by a config switch so
> > > arch maintainers can decide whether they want to enable the constant
> > > optimization or unconditionally call the lib function ?
> > 
> > No.
> > 
> > This is just making that damn header line look worse and worse.
> > 
> > Is there a _reason_ to optimize this stupid function this way?
> 
> On architectures which have a find bit instruction we can replace the
> call to the library function by a single instruction when the size of
> the bitmap is less/equal bits per long and when the bitnr is a
> constant.

That's not what I asked.

I asked whether there is a *reason* to optimize this and cause all these 
stupid problems.

Is there a real hot path anywhere that actually uses this and depends on 
it?

		Linus
