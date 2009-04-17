Return-Path: <linux-kernel-owner+w=401wt.eu-S1760369AbZDQJeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369AbZDQJeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760206AbZDQJeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:34:03 -0400
Received: from brick.kernel.dk ([93.163.65.50]:59570 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760156AbZDQJeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:34:01 -0400
Date: Fri, 17 Apr 2009 11:34:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
Message-ID: <20090417093359.GQ4593@kernel.dk>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090417063007.GB4593@kernel.dk> <49E83DC4.8040207@tuffmail.co.uk> <20090417091321.GP4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417091321.GP4593@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17 2009, Jens Axboe wrote:
> On Fri, Apr 17 2009, Alan Jenkins wrote:
> > Jens Axboe wrote:
> > > On Thu, Apr 16 2009, Rafael J. Wysocki wrote:
> > >   
> > >> This message has been generated automatically as a part of a report
> > >> of recent regressions.
> > >>
> > >> The following bug entry is on the current list of known regressions
> > >> from 2.6.29.  Please verify if it still should be listed and let me know
> > >> (either way).
> > >>
> > >>
> > >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13058
> > >> Subject		: First hibernation attempt fails
> > >> Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > >> Date		: 2009-04-10 10:58 (7 days old)
> > >> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1faa16d22877f4839bd433547d770c676d1d964c
> > >> References	: http://marc.info/?l=linux-kernel&m=123928022321917&w=2
> > >>     
> > >
> > > Alan, is this still a problem?
> > >   
> > 
> > Yup.  Still present in v2.6.30-rc2-195-g9f76208.
> 
> Given the somewhat odd nature of the bug and the requirements to trigger
> it, how confident are you in the bisection results?
> 
> I'll try and reproduce it here.

I can't reproduce it here. It seems very odd that an ENOMEM would happen
as a consequence of the rq allocation change, it doesn't really change
the allocation at all (and it'll never return -ENOMEM).

Can you please recheck the git bisect results. It'd be nice if the
hibernation failure would actually log where the problem occured...

-- 
Jens Axboe

