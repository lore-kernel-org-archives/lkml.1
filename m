Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbXEDMNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbXEDMNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbXEDMNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:13:11 -0400
Received: from ozlabs.org ([203.10.76.45]:49300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXEDMNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:13:09 -0400
Subject: Re: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure
	for paravirtualization"
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 22:12:50 +1000
Message-Id: <1178280770.23670.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 05:56 -0600, Eric W. Biederman wrote:
> This reverts commit c9ccf30d77f04064fe5436027ab9d2230c7cdd94.
> 
> Entering the kernel at startup_32 without passing our real mode data
> in %esi, and without guaranteeing that physical and virtual addresses
> are identity mapped makes head.S impossible to maintain.

Your assertion that these #ifdef-contained lines of code are "impossible
to maintain" is theatrical.  I'd prefer to wait until we actually have a
replacement before we go ripping out working code.  

Fortunately, I'm working on such code right now.  But as lguest
currently boots with V = P + PAGE_OFFSET, it's not entirely a trivial
matter to change.

Thanks,
Rusty.

