Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbXLBUWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbXLBUWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 15:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbXLBUV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 15:21:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34237 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754265AbXLBUV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 15:21:56 -0500
Date: Sun, 2 Dec 2007 21:22:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Valdis.Kletnieks@vt.edu
Cc: tvrtko.ursulin@sophos.com, Andi Kleen <andi@firstfloor.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071202202240.GB1625@elf.ucw.cz>
References: <p738x4i9nyd.fsf@crumb.suse.de> <OFFB86F10D.D565B603-ON802573A2.005A558C-802573A2.005B85B0@sophos.com> <20071201084332.GB4446@ucw.cz> <17957.1196624688@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17957.1196624688@turing-police.cc.vt.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So what you are trying to do is 'application may never read bad
> > sequence of bits from disk', right?
> 
> No, in many of the use cases, we're trying to do "if application reads certain
> specified sequences of bits from disk we know about it", which is subtly
> different.  Often, *absolute* prevention isn't required, as long as we can
> generate audit trails and/or alerts...
> 
> > Now, how do you propose to solve mmap(MAP_SHARED)? The app on the other cpu may
> > see the bad bits before kernel has chance to see them.
> 
> For many usage cases (such as virus scanners), mmap() isn't really an issue,
> because if another process is *already* trying to mmap() the file before it's
> even finished downloading from the network interface, you have other
> problems.

Well, if you only want to detect viruses _sometimes_, you can just
LD_PRELOAD your scanner.

I guess the A/V people should describe what they are trying to do, as
in

"forbidden sequences of bits should never hit disk" or "forbidden
sequences of bits should be never read from disk"  or something...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
