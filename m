Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbYCZXUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbYCZXUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYCZXUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:20:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:57086 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbYCZXUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:20:31 -0400
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Gary Hade <garyhade@us.ibm.com>, Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
In-Reply-To: <1206572084.6926.34.camel@pasglop>
References: <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
	 <20080326101450.GA9060@jurassic.park.msu.ru>
	 <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>
	 <20080326203012.GB6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
	 <20080326205828.GA15225@jurassic.park.msu.ru>
	 <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
	 <1206568675.6926.7.camel@pasglop>  <20080326221027.GA7959@elte.hu>
	 <1206570546.6926.30.camel@pasglop>
	 <alpine.LFD.1.00.0803261544210.2775@woody.linux-foundation.org>
	 <1206572084.6926.34.camel@pasglop>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 10:18:53 +1100
Message-Id: <1206573533.6926.45.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Anyway, doesn't matter much at this stage I suppose, but it would be
> nice to not use 0 as meaning invalid when sizing bridge windows and I'm
> not sure at all about using "start" as an alignment indicator neither...
> It will be much over-aligned in some cases, adding constraints to the
> allocator where we didn't have any before no ?

Hrm... we use "start" today already and it hasn't choked on me so far so
I suppose that's fine. I overlooked that ...

Ben.


