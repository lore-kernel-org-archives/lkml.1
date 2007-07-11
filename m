Return-Path: <linux-kernel-owner+w=401wt.eu-S936258AbXGKXym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936258AbXGKXym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935150AbXGKXgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60907 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764607AbXGKXgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:20 -0400
Date: Thu, 12 Jul 2007 01:36:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711233618.GD25510@one.firstfloor.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org> <1184191488.12353.160.camel@chaos> <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org> <1184194219.12353.170.camel@chaos> <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707111558250.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The same is true of a lot of the APIC timer code. Sure, that patch has the 
> actual conversion in it, and you don't have the cross-architecture issues, 
> but more than 50% of the patch seems to be just cleanup that is 
> independent of the actual switch-over, no?

I don't think it's that much cleanup. One of my goals for x86-64 was always
to have it support modern x86 only; this means in particularly most of the
old bug workaround removed. With the APIC timer merging a lot of that crap
gets back in.

I would prefer to keep APIC code separate.

-Andi
