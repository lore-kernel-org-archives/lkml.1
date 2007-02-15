Return-Path: <linux-kernel-owner+w=401wt.eu-S1946114AbXBPUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946114AbXBPUQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946120AbXBPUQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:16:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1409 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946114AbXBPUQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:16:12 -0500
Date: Thu, 15 Feb 2007 22:10:30 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
       arjan@infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Message-ID: <20070215221030.GA6602@ucw.cz>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <200702142135.40832.agruen@suse.de> <20070215054559.GD15654@redhat.com> <200702142214.53625.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702142214.53625.agruen@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > well, the situation for external modules is no worse than usual.
> > They still work, they just aren't signed. Which from a distributor point
> > of view, is actually a nice thing, as they stick out like a sore thumb
> > in oops reports with (U) markers :)
> 
> I agree, that's really what should happen. We solve this by marking modules as 
> supported, partner supported, or unsupported, but in an "insecure" way, so 
> partners and users could try to fake the support status of a module and/or 
> remove status flags from Oopses, and cryptography wouldn't save us. We could 
> try to sign Oopses which I guess you guys are doing. This whole issue hasn't 

I do not think any ammount of crypto can determine that I loaded
unsupported module, then edited oops. (TPM hw module may be able to do that, not
sure).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
