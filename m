Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXAXT5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXAXT5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 14:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbXAXT5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 14:57:39 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46952 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXAXT5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 14:57:38 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: john stultz <johnstul@us.ibm.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <1169631016.19471.175.camel@imap.mvista.com>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070124070701.GA17654@elte.hu>
	 <1169631016.19471.175.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 11:57:33 -0800
Message-Id: <1169668653.6905.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 01:30 -0800, Daniel Walker wrote:
> 
> My patch set has been stable for months, and reviewed and tested by
> John and I constantly (With you and Thomas on the CC list each
> release).. It's a completely safe bet, IMO . 

Oh, I really wanted to stay out of this, but just a small clarification:
I've reviewed your patches on a number of occasions, but I can't recall
actually having the time to run them.

Personally, I'm a little paranoid, so I'd be wary of counting any
testing outside of -mm for much, as there are an amazing number of
strange systems out there.

Ok, so my take: While I've looked over both patch sets, and have noticed
(and mentioned to tglx) the similarity in some of the changes, I don't
see any big conflict in intent. They're both cleanups that make the
clocksource code more flexible for uses other them just system
timekeeping.

Thomas' changes are more obviously purpose driven, and Daniel's appear
more like just cleanups. So given that, if it were me, I'd put Thomas
changes in first, and re-diff Daniel's non-redundant changes on top.

Although, to be fair, I do know that Daniel has future sched_clock
related patches that need his cleanups (so the cleanups are not just
shuffling code). However, I'm not as psyched about those changes as I am
about HRT, so again I'd rank HRT higher on the priority list.

So I'm bummed this has collided like it has. I do like a number of
Daniel's cleanups, and Thomas (and myself as well, really) could have
communicated better. So the duplicate code is unfortunate, but its not
really a stop-everything deal breaker, is it?

Anyway, just my take.
-john

