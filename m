Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZKCWOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZKCWOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZKCWOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:14:33 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:41105 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbZKCWOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:14:32 -0500
Date: Tue, 3 Nov 2009 23:15:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: John Kacur <jkacur@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH cleanup] Re: +
	mips-vpe-remove-leftover-unlock_kernel.patch added to -mm tree
Message-ID: <20091103221541.GA25401@linux-mips.org>
References: <200911030701.nA371cAP019835@imap1.linux-foundation.org> <20091103140953.GA23611@linux-mips.org> <20091103085613.373634ab.akpm@linux-foundation.org> <alpine.LFD.2.00.0911032243530.6542@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911032243530.6542@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 10:52:41PM +0100, John Kacur wrote:

> > > I already have an equivalent patch in the MIPS kernel - Linus only needs
> > > to finally pull ...
> > > 
> > 
> > I didn't see such a patch in yesterday's linux-next..

I only have stuff to be pulled for 2.6.33 on my -next tree.  Anything for
2.6.32 was in another tree.

> Linus picked-up Ralf's version of the patch for 2.6.32-rc6
> a22d621c80fb08f668ae3bfe62aeaae64b0b2b89
> 
> That has the important part that removes the stray unlock_kernel, but
> unfortunately doesn't remove the smp_lock.h header.
> 
> So, the last patch is just a clean-up. (no urgency).
> 
> >From ae20d9169893112daaad1dc3af9f8559003a2bfb Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Tue, 3 Nov 2009 22:15:55 +0100
> Subject: [PATCH] Remove BKL header.
> 
> Now that the bkl has been removed, also remove the smp_lock.h include

In fact every single use of <linux/smp_lock.h> in arch/mips/ is unnecessary;
see patch for 2.6.33 in

http://www.linux-mips.org/git?p=upstream-sfr.git;a=commit;h=defde8dd822ddbab4ea1f8d2f5831e693bc75ad4

  Ralf
