Return-Path: <linux-kernel-owner+w=401wt.eu-S935160AbXKQAP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935160AbXKQAP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 19:15:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbXKQAPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 19:15:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41497
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbXKQAPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 19:15:48 -0500
Date: Fri, 16 Nov 2007 16:15:43 -0800 (PST)
Message-Id: <20071116.161543.181413865.davem@davemloft.net>
To: andi@firstfloor.org
Cc: mucci@cs.utk.edu, akpm@linux-foundation.org, gregkh@suse.de,
       eranian@hpl.hp.com, wcohen@redhat.com, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, ptools-perfapi@cs.utk.edu
Subject: Re: perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <p737ikicjbn.fsf@bingen.suse.de>
References: <20071114015210.GA20365@one.firstfloor.org>
	<A42C2398-2EAB-460C-95C7-686A34A76F82@cs.utk.edu>
	<p737ikicjbn.fsf@bingen.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Fri, 16 Nov 2007 16:15:56 +0100

> Philip Mucci <mucci@cs.utk.edu> writes:
> > - A feature which was dropped earlier by Stefane (only to satiate
> > LKML), we consider
> > very important. Allowing one tomapping of the kernels view of the
> > PMD's, allowing
> > user-space access to full 64-bit counts, if the architecture
> > supports a user-level read instruction.
> 
> You mean returning the register number for RDPMC or equivalent
> and a way to enable it for ring 3 access? 
> 
> I'm considering that an essential feature too. I wasn't aware
> it was dropped.
> 
> > Getting the counts in a
> > couple of dozen cycles
> > is ALWAYS a win for us.
> 
> Yes it is for everybody. I've been rather questioning if the slow
> ways (complicated syscalls) to get the counter information are really 
> needed.

I would like to add sparc64 support to perfmon2 as well
and therefore I've been considering this angle of the
API issues as well.

The counters on sparc64 can be configured to be readable by userspace,
so for the self-monitoring cases I really would like to make sure the
perfmon2 library interface could use direct reads for sampling instead
of system calls or specialized traps.

If I get some spare time I'll look at the current perfmon2 patches
and see if I can toss together sparc64 support to get a feel for
how things stand currently.
