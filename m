Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXJaLxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXJaLxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXJaLxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:53:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40769 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbXJaLxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:53:11 -0400
Date: Wed, 31 Oct 2007 12:53:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
Message-ID: <20071031115308.GC27084@one.firstfloor.org>
References: <1193788979.5623.43.camel@localhost.localdomain> <p73odeg2l9v.fsf@bingen.suse.de> <20071031081513.GB3810@infradead.org> <20071031104147.GA27084@one.firstfloor.org> <Pine.LNX.4.58.0710310653190.12724@gandalf.stny.rr.com> <20071031111724.GB27084@one.firstfloor.org> <Pine.LNX.4.58.0710310729130.13523@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0710310729130.13523@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I suspect most of the panics you cited are unnecessary and should
be revisited anyways. Linux should be far beyond the "we left out error
handling and put in panic instead" philosophy of classical Unix now
and those are mostly just some left overs.  But that's a different issue.

> IMHO I believe we should do the dump_stack now, and come up with another
> solution to the mount root panic.

You mean never. You want the change, you do it please properly the first
time. Doing stack dumps on no root or machine check is utterly wrong.

It is bad enough we always get them on OOM events where they are also
mostly pointless.

-Andi
