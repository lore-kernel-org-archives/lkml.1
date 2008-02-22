Return-Path: <linux-kernel-owner+w=401wt.eu-S933065AbYBVEi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbYBVEi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758191AbYBVEiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:38:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757694AbYBVEiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:38:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeff Dike <jdike@addtoit.com>
X-Fcc: ~/Mail/linus
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [bug] uml doesn't boot under 2.6.25-rc1 host (was Re: 2.6.24-mm1 bugs)
In-Reply-To: Jeff Dike's message of  Thursday, 21 February 2008 18:54:56 -0500 <20080221235456.GA11137@c2.user-mode-linux.org>
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu>
	<20080215184741.GB8810@c2.user-mode-linux.org>
	<E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu>
	<E1JRD9I-0004L9-6E@pomaz-ex.szeredi.hu>
	<E1JSF5r-0007vI-1v@pomaz-ex.szeredi.hu>
	<20080221235456.GA11137@c2.user-mode-linux.org>
Emacs: there's a reason it comes with a built-in psychotherapist.
Message-Id: <20080222043741.205AF2701D5@magilla.localdomain>
Date: Thu, 21 Feb 2008 20:37:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the pointers, guys.  It took a while for me to figure out what
got wrong to foul up UML, but the bug and fix are trivial (posting now).
Some of the testing I thought had got done clearly wasn't done, since
PTRACE_SETREGS was 100% busticated for 32-bit processes calling ptrace on
x86_64 kernels.


Thanks,
Roland
