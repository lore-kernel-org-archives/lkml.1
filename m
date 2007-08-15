Return-Path: <linux-kernel-owner+w=401wt.eu-S933908AbXHORaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbXHORaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 13:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759308AbXHOR36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 13:29:58 -0400
Received: from mylar.outflux.net ([69.93.193.226]:59397 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297AbXHOR34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 13:29:56 -0400
X-Greylist: delayed 2413 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 13:29:56 EDT
Date: Wed, 15 Aug 2007 09:48:34 -0700
From: Kees Cook <kees@outflux.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jakub Jelinek <jakub@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ulrich Kunitz <kune@deine-taler.de>, Bret Towe <magnade@gmail.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [RESEND] PIE executable randomization
Message-ID: <20070815164834.GB7677@outflux.net>
References: <Pine.LNX.4.64.0708081552010.11054@jikos.suse.cz> <20070814200647.GN2063@devserv.devel.redhat.com> <Pine.LNX.4.64.0708142224540.29843@jikos.suse.cz> <Pine.LNX.4.64.0708150112120.29843@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708150112120.29843@jikos.suse.cz>
Organization: Outflux
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 15, 2007 at 01:21:37AM +0200, Jiri Kosina wrote:
> The following patch fixes the brk-allocation problems on x86_64 with code 
> randomization patch on PIE-compiled binaries. Is anyone aware of any 
> potential disaster it might cause somewhere please?

(Adding myself to this thread...)

I've tested this on x86_64 now (the prior patch failed on brk, as
mentioned).  This version passes my regression tests.  I'd like to
double-check this on i386 with unlimited stack (the situation that ran
into problems back with 2.6.20's version of text ASLR).

For anyone interested, I have a few ASLR and VM checking tools here:
http://outflux.net/aslr/

Thanks,

-Kees

-- 
Kees Cook                                            @outflux.net
