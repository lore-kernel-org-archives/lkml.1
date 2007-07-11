Return-Path: <linux-kernel-owner+w=401wt.eu-S935681AbXGLAGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935681AbXGLAGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935494AbXGKXsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:48:16 -0400
Received: from www.osadl.org ([213.239.205.134]:39826 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935254AbXGKXsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:48:14 -0400
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20070711233618.GD25510@one.firstfloor.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
	 <1184191488.12353.160.camel@chaos>
	 <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org>
	 <1184194219.12353.170.camel@chaos>
	 <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org>
	 <20070711233618.GD25510@one.firstfloor.org>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 01:48:12 +0200
Message-Id: <1184197692.12353.197.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Thu, 2007-07-12 at 01:36 +0200, Andi Kleen wrote:
> > The same is true of a lot of the APIC timer code. Sure, that patch has the 
> > actual conversion in it, and you don't have the cross-architecture issues, 
> > but more than 50% of the patch seems to be just cleanup that is 
> > independent of the actual switch-over, no?
> 
> I don't think it's that much cleanup. One of my goals for x86-64 was always
> to have it support modern x86 only; this means in particularly most of the
> old bug workaround removed. With the APIC timer merging a lot of that crap
> gets back in.
> 
> I would prefer to keep APIC code separate.

Care to look at the patch ? It _IS_ seperate.

Only HPET and PIT got shared.

	tglx


