Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZAEJia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZAEJia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbZAEJiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:38:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44269 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZAEJiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:38:19 -0500
Date: Mon, 5 Jan 2009 10:38:17 +0100
From: Pavel Machek <pavel@suse.cz>
To: david@lang.hm
Cc: Rob Landley <rob@landley.net>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090105093817.GA27199@atrey.karlin.mff.cuni.cz>
References: <20090103123813.GA1512@ucw.cz> <200901041349.49906.rob@landley.net> <20090104225545.GF1913@elf.ucw.cz> <alpine.DEB.1.10.0901041615560.25545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901041615560.25545@asgard.lang.hm>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >Sector writes are atomic (ATOMIC-SECTORS)
> >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> >Either whole sector is correctly written or nothing is written during
> >powerfail.
> >
> >       Unfortuantely, none of the cheap USB/SD flash cards I seen do
> >       behave like this, and are unsuitable for all linux filesystems
> >       I know.
> >
> >               An inherent problem with using flash as a normal block
> >               device is that the flash erase size is bigger than
> >               most filesystem sector sizes.  So when you request a
> >               write, it may erase and rewrite the next 64k, 128k, or
> >               even a couple megabytes on the really _big_ ones.
> >
> >               If you lose power in the middle of that, filesystem
> >               won't notice that data in the "sectors" _after_ the
> >               one your were trying to write to got trashed.
> 
> around, not after. the block you are reading could be in the middle or at 
> the end of an eraseblock.

Applied, thanks.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
