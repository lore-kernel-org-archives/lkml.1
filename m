Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXJaKl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXJaKl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbXJaKlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:41:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60082 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbXJaKlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:41:50 -0400
Date: Wed, 31 Oct 2007 11:41:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
Message-ID: <20071031104147.GA27084@one.firstfloor.org>
References: <1193788979.5623.43.camel@localhost.localdomain> <p73odeg2l9v.fsf@bingen.suse.de> <20071031081513.GB3810@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031081513.GB3810@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 08:15:13AM +0000, Christoph Hellwig wrote:
> On Wed, Oct 31, 2007 at 01:14:04AM +0100, Andi Kleen wrote:
> > One (mostly psychological, but still serious) problem is that stack
> > dumps make panics always look like kernel bugs.  But there are panics
> > which are definitely not kernel bugs: like the popular cannot mount
> > root or machine checks or a couple of others.
> 
> But that one really shouldn't be a panic anyway.  The panic alone
> is psycologically bad enough for users.  I think it would be best to
> have a simple scanf loop asking for another root device..

Then you couldn't recover with panic=30 from it.

Besides even if you fix that one there are others, like machine checks
where it is impossible to recover.

-andi

