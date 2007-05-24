Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbXEXUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbXEXUrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXEXUrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:47:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbXEXUrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:47:23 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 8533] New: Panic on boot with early exception rip ffffffff8150a240 error 0 cr2 2260
Date: Thu, 24 May 2007 22:47:15 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, mjw99@ic.ac.uk,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
References: <200705241523.l4OFN4OZ025419@fire-2.osdl.org> <20070524103249.3e0b87d8.akpm@linux-foundation.org>
In-Reply-To: <20070524103249.3e0b87d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705242247.15790.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> > Kernel alive
> > kernel direct mapping tables up to 840000000 @ 8000-2a000
> > PANIC: early exception rip ffffffff8150a240 error 0 cr2 2260
> > 
> > 
> > 
> > Steps to reproduce:
> > 
> > 1) Boot the kernel with flags
> > kernel /vmlinuz-2.6.21.2 ro root=LABEL=/ selinux=0 console=ttyS0,57600 console=tty0
> > 
> > 2) Observe the above problem
> > 
> 
> erk, -stable just went unstable.

Multiple reports? Sometimes things seem to get "miscompiled" for random
reasons, so for really weird crashes I would suggest a make clean and try
again. 

> hm, it occurred sometime between 2.6.18.3 and 2.6.21.2.  That's a huge
> leap.  I don't suppose you'd have the time and inclination to run a
> git-bisect search?

And looking up ffffffff8150a240 in the System.map

-Andi



