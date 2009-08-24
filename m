Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbZHXDUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbZHXDUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 23:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZHXDUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 23:20:54 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:41921 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZHXDUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 23:20:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19090.1800.521794.839576@cargo.ozlabs.ibm.com>
Date: Mon, 24 Aug 2009 13:20:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
In-Reply-To: <20090823084740.GA7651@elte.hu>
References: <20090814134811.013873340@de.ibm.com>
	<tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org>
	<20090822103252.GA32369@elte.hu>
	<20090822171540.1220f50d@skybase>
	<20090822153346.GA3313@elte.hu>
	<19088.47213.327897.703458@cargo.ozlabs.ibm.com>
	<20090823084740.GA7651@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Do you ask Linus to rebase the upstream kernel as well, if the 
> powerpc or x86 build happens to break? There's more than a dozen 
> such cases per development cycle triggering on my tests alone. If 
> not, why not?

I see you pulling commits out of the tip tree quite often, when they
have testing failures of various kinds.  I presume that, like other
maintainers, you have some branches that you try hard not to rebase
and other testing branches that are quite volatile and get
reconstructed frequently (though I don't know what branch names you
use for them).

I presumed that you wouldn't have put a commit that hadn't even passed
basic build testing into one of your non-rebasing branches.  That's
why I assumed you could fold the fix into the original patch without
difficulty.

> The thing is, we'll probably redo this portion of the timer tree as 
> i found other problems in testing, but generally the disadvantages 
> of a build breakage with a very small non-bisectability window has 
> to be weighed against the disadvantages of a rebase (which are 
> significant).
> 
> The equation does not automatically flip in favor of a rebase as you 
> seem to suggest - in fact it generally goes _against_ a rebase.

In a stable, non-rebasing branch, sure.  But putting untested patches
into such a branch would be a bit silly, so I assumed you hadn't done
that. :)

Paul.
