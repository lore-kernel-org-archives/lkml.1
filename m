Return-Path: <linux-kernel-owner+w=401wt.eu-S1764653AbXJTJul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764653AbXJTJul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 05:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755026AbXJTJub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 05:50:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1679 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752707AbXJTJua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 05:50:30 -0400
Date: Sat, 20 Oct 2007 09:50:25 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Rob Landley <rob@landley.net>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: OOM killer gripe (was Re: What still uses the block layer?)
Message-ID: <20071020095025.GB7271@ucw.cz>
References: <200710112011.22000.rob@landley.net> <20071015014503.GF9715@thunk.org> <200710150304.00901.rob@landley.net> <200710152337.45252.nickpiggin@yahoo.com.au> <20071015114003.GB21216@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015114003.GB21216@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I suppose I should just configure suspending to a file instead of a
> swap partition, but I've just historically trusted suspend/resume to a
> swap partition much more than to a file.  Or maybe I should hack in a
> sysctl to prevent any swapping even though the swap partition is
> configured (so only suspend/resume will use it).

swapon -a; swsusp; swapoff -a?

							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
