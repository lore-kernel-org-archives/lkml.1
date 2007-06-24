Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbXFXRLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbXFXRLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 13:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbXFXRLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 13:11:23 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36359 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbXFXRLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 13:11:22 -0400
Date: Sun, 24 Jun 2007 19:10:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: FW : airo suspend problem
Message-ID: <20070624171032.GB21757@elf.ucw.cz>
References: <1181985273.4673a9f9e9a4e@imp.free.fr> <20070622205817.GA3885@ucw.cz> <467CDDEB.2090602@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467CDDEB.2090602@free.fr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>PS : after the failed suspend to ram due to airo driver, I tried to 
> >>unload airo
> >>driver and it hanged. After a reset, I got my ext3 root fs corrupted :(
> >
> >Corrupted or 'just needed journal replay'?
> Really corrupted :
> on reboot, there was no journal replay, but boot hanged. After some 
> investigation some symbolic links were pointing to garbage (lot's of 
> /etc/rcx.d/ ones). After a fsck (partial log attached) and some manual 
> fix for symbolic links, the system was operational.

Hmm, that's strange and bad, because we do sync before s2ram... and
s2ram being _so_ broken that it corrupts memory would be bad, too.

Is it reproducible? (Yep, asking someone to corrupt his machine is
unnince, but... suspend to ram does not really deal with disks...)
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
