Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZAEJpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZAEJpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZAEJpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:45:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50944 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbZAEJpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:45:06 -0500
Date: Mon, 5 Jan 2009 10:45:04 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Rob Landley <rob@landley.net>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090105094504.GB27199@atrey.karlin.mff.cuni.cz>
References: <20090103123813.GA1512@ucw.cz> <200901041349.49906.rob@landley.net> <20090104225545.GF1913@elf.ucw.cz> <yq1r63i30bv.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1r63i30bv.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>> "Pavel" == Pavel Machek <pavel@suse.cz> writes:
> 
> Pavel> Does this sound like a fair summary?
> 
> Pavel> Sector writes are atomic (ATOMIC-SECTORS)
> Pavel> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> I'd just like to point out that the all-or-nothing hardware sector
> atomity thing is -- to a large extent -- a myth.

It is a myth that linux filesystems depend on for safe operation :-(.

> It is mostly true on SCSI class devices because various UNIX, RAID array
> and database vendors have spent many years leaning very hard on the
> drive manufacturers to make it so.
> 
> But it's not a hard guarantee, you can't get it in writing, and it's not
> in any of the standards.  Hybrid drives with flash had potential to
> close that particular loophole but those appear to be dead in the water.

So "in practice it works but vendors will not guarantee that"?

How much true is it for normal SATA drives? Are there some tests I can
just run on a machine, powercycle it few times, and it tells me if my
disk is non-ATOMIC-SECTORS?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
