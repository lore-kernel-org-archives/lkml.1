Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbYCLVy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbYCLVy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbYCLVyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:54:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbYCLVyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:54:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/6] signals: send_signal: factor out SIGNAL_GROUP_EXIT checks
In-Reply-To: Oleg Nesterov's message of  Wednesday, 12 March 2008 08:49:09 +0300 <20080312054909.GA163@tv-sign.ru>
References: <20080309185926.GA5649@tv-sign.ru>
	<20080311021633.BF1B326F991@magilla.localdomain>
	<20080311175122.GA586@tv-sign.ru>
	<20080311203206.2DAC526F991@magilla.localdomain>
	<20080312054909.GA163@tv-sign.ru>
Emacs: featuring the world's first municipal garbage collector!
Message-Id: <20080312215406.A786526F992@magilla.localdomain>
Date: Wed, 12 Mar 2008 14:54:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course, since I personally don't agree, I'd like to discuss it more
> if possible.

Certainly, but let's do it under separate cover, and after some of
these cleanups settle.  (I'd rather not try to get into it this week.)

> "[PATCH 3/6] signals: use __group_complete_signal() for the specific signals too"
> adds a behaviour change too.

Your log entry was explicit about the semantics change there.  You
explained it up front and justified it.  I also happened to agree
with it, but that's a separate issue.

I am certainly not opposed to semantics changes a priori.
I happen to have reservations about this particular one.  

> Surely, I don't want to change the behaviour quietly, that is why I am
> cc'ing maintainers.

The point is that, whenever possible, a semantics change should be
isolated into a patch separate from any related cleanups.  More
important than that, no semantics change should go unmentioned so
it's only documented as a result of someone's careful review of
the change.  (Of course when a change is inadvertent, then only
review is going to notice it--that's what review is for.)

Your new pair of patches dated 2008-3-12 look like they are doing
exactly this (just the cleanup first).  After those are in, the
semantics change you want is a one-liner and easy to review and
discuss on its own.

> (note also these patches are 8/6, 9/6. Originally I was going to send
>  them in a separate series).

I had noticed that your wholes sometimes go up to 1.5; I just
figured it's because you're 50% more thorough than the rest of us.
;-)


Thanks,
Roland
