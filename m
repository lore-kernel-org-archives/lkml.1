Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbZA0JPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbZA0JPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 04:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbZA0JO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 04:14:58 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53368 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZA0JO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 04:14:57 -0500
Date: Tue, 27 Jan 2009 10:14:56 +0100
From: Pavel Machek <pavel@suse.cz>
To: MartinG <gronslet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend/resume works in 2.6.29-0.19.rc0.git9.fc11.i686, but fails in later versions
Message-ID: <20090127091455.GB8543@atrey.karlin.mff.cuni.cz>
References: <bcb3ef430901150110nc4ced93w50c662ac512f8552@mail.gmail.com> <20090116085326.GC4795@atrey.karlin.mff.cuni.cz> <bcb3ef430901161443y5843d951m1cdee28dd588d006@mail.gmail.com> <20090119191720.GB6463@ucw.cz> <bcb3ef430901200035y33cea7e6hcf78ac1df01c99d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcb3ef430901200035y33cea7e6hcf78ac1df01c99d2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok, that is not going to work on single core. Can you try if
> > suspending works in init=/bin/bash mode?
> 
> Hi, I forgot to mention that I'm running on a crypted disk. So
> "init=/bin/bash" fails. But I booted kernel-2.6.29-0.41.rc2.fc11.i686
> using "1" as a kernel parameter, and put the laptop to suspend by
> # echo -n mem > /sys/power/state

Hmm, ok.

> But still, I was not able to resume it - black screen, keyboard dead.
> 
> Could it be related to my disk encryption? I though "everybody"
> encrypted their laptop these days?

Not me...

> I'd be happy to test further - please let me know what info I can provide.
> Thanks.

Well, git bisect is always an option...? Or getting disk encryption
out of place? Trying minimal config?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
