Return-Path: <linux-kernel-owner+w=401wt.eu-S1761966AbYEBKR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761966AbYEBKR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 06:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761185AbYEBKQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 06:16:59 -0400
Received: from ozlabs.org ([203.10.76.45]:58717 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760608AbYEBKQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 06:16:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18458.59921.485453.670242@cargo.ozlabs.ibm.com>
Date: Fri, 2 May 2008 20:16:49 +1000
From: Paul Mackerras <paulus@samba.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Josh Boyer <jwboyer@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
In-Reply-To: <20080502082936.GB2003@cs181133002.pp.htv.fi>
References: <20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080501003125.GM29330@cs181133002.pp.htv.fi>
	<20080430000338.50548884@infradead.org>
	<20080501113038.GW29330@cs181133002.pp.htv.fi>
	<20080430072013.7c3b30b1@infradead.org>
	<20080501132159.GC29330@cs181133002.pp.htv.fi>
	<18458.30641.838156.434563@cargo.ozlabs.ibm.com>
	<1209697815.2946.156.camel@vader.jdub.homelinux.org>
	<18458.37891.268060.691285@cargo.ozlabs.ibm.com>
	<20080502082936.GB2003@cs181133002.pp.htv.fi>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk writes:

> > That's right.  The bug has been there basically forever (i.e. since
> > before 2.6.12-rc2 ;) and no-one has been able to trigger it reliably
> > before.
> 
> But for users this is a recent regression since 2.6.24 worked
> and 2.6.25 does not.

I never actually saw a statement to that effect (i.e. that 2.6.24
worked) from Kamalesh.  I think people assumed that because he
reported it against version X that version X-1 worked, but we don't
actually know that.

> If this problem was on x86 Linus himself and some other core developers 
> would most likely have debugged this issue and Linus would have delayed 
> the release of 2.6.25 for getting it fixed there.

If I had been able to replicate it, or if it had been seen on more
than one machine, I would probably have asked Linus to wait while we
fixed it.  

There's a risk management thing happening here.  Delaying a release is
a negative thing in itself, since it means that users have to wait
longer for the improvements we have made.  That has to be balanced
against the negative of some users seeing a regression.  It's not an
absolute, black-and-white kind of thing.  In this case, for a bug
being seen on only one machine, of a somewhat unusual configuration, I
considered it wasn't worth asking to delay the release.

Paul.
