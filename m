Return-Path: <linux-kernel-owner+w=401wt.eu-S965889AbXCLOWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965889AbXCLOWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965893AbXCLOWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:22:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38973 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965889AbXCLOWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:22:19 -0400
Date: Mon, 12 Mar 2007 15:22:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, npiggin@suse.de, drepper@redhat.com,
       oleg@tv-sign.ru, sebastien.dugue@bull.net, linux-kernel@vger.kernel.org
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312142216.GA15357@one.firstfloor.org>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <p73bqiyaehp.fsf@bingen.suse.de> <1173697220.13341.84.camel@localhost.localdomain> <20070312105826.GB11864@one.firstfloor.org> <20070312141214.GG4372@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312141214.GG4372@thunk.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This becomes especially important if we want the tickless code to
> really shine as far as power management is concerned.  Unfortunately,
> the POSIX timer abstraction doesn't give this kind of flexibility
> easily, so it's going to be a while before we see significant
> userspace adoption of such a kernel feature, but I think it's
> something that would be still worthwhile to add.

I suspect it would be overkill to specify that on every sleep operation.
99% of applications won't care and for the 1% leftover a global per 
process setting should be fine.
I think a single prctl() and a global sysctl as default would be enough.

-Andi

