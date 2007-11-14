Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbXKNJGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbXKNJGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbXKNJG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:06:29 -0500
Received: from www.tglx.de ([62.245.132.106]:57982 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbXKNJG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:06:27 -0500
Date: Wed, 14 Nov 2007 10:06:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Jeff Garzik <jeff@garzik.org>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, david@lang.hm,
       Christoph Hellwig <hch@infradead.org>, Frans Pop <elendil@planet.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH revised] enable make ARCH=x86 (and stay backward
 compatible)
In-Reply-To: <20071113182812.GA740@uranus.ravnborg.org>
Message-ID: <alpine.LFD.0.9999.0711140958430.3265@localhost.localdomain>
References: <20071112205451.GA22528@uranus.ravnborg.org> <20071113182812.GA740@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

On Tue, 13 Nov 2007, Sam Ravnborg wrote:

> Thomas - what is way forward here?
> 
> I consider the patch serie ready to be applied and I
> leave it to you (x86 guys) to decide the way forward to mainline.
> cleanup -> mm -> linus or straight to linus.

I'd like to see this merged right away, so we can finalize the build
environment change in the .24 release rather than having two releases
with gradual changes.

Linus, I know it's late, but you really should consider to pull this
into .24 so we are done with it once and forever. The patchset is
straight forward and as far as I can tell Sam really worked out all
the corner cases and fixed the review comments so we can be pretty
sure that there is not hidden wreckage lurking round the corner.

Thanks,

	tglx
