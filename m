Return-Path: <linux-kernel-owner+w=401wt.eu-S937824AbXGLAoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937824AbXGLAoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765912AbXGLAoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:44:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbXGLAoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:44:05 -0400
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: generic clockevents/ (hr)time(r) patches was Re: -mm merge plans for 2.6.23
Date: Thu, 12 Jul 2007 02:43:09 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Stable Team <stable@kernel.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070711165751.b703f003.akpm@linux-foundation.org> <1184198662.12353.201.camel@chaos>
In-Reply-To: <1184198662.12353.201.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707120243.09999.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007 02:04, Thomas Gleixner wrote:
> Andrew,
>
> On Wed, 2007-07-11 at 16:57 -0700, Andrew Morton wrote:
> > They all look pretty innocuous to me.
> >
> > Could you please take a second look, decide if any of them should also be
> > in 2.6.22.x and let me know?
>
> i386-hpet-check-if-the-counter-works.patch
> pcspkr-use-the-global-pit-lock.patch

Ok by me, although I suspect a lot of the cases where the hpet one
was needed got resolved with the PCI HPET resource fix But it's still
safer to check.

However I don't think patches should go into stable before they 
hit Linus' tree.

-Andi
