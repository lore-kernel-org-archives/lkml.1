Return-Path: <linux-kernel-owner+w=401wt.eu-S934504AbXGKWWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504AbXGKWWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765740AbXGKWWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:22:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59400 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763721AbXGKWWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:22:15 -0400
Date: Wed, 11 Jul 2007 15:20:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <1184191488.12353.160.camel@chaos>
Message-ID: <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> 
 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> 
 <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
 <1184191488.12353.160.camel@chaos>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Jul 2007, Thomas Gleixner wrote:
> 
> Can you please shed some light on me, how exactly you switch an
> architecture gradually to clock events.

For example, we can make sure that the code in question that actually 
touches the hardware stays exactly the same, and then just move the 
interfaces around - and basically guarantee that _zero_ hardware-specific 
issues pop up when you switch over, for example.

That way there is a gradual change-over.

The other approach (which would be nice _too_) is to actually try to 
convert one clock source at a time. Why is that not an option? 

		Linus

