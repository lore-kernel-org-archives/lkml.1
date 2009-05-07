Return-Path: <linux-kernel-owner+w=401wt.eu-S1763197AbZEGUgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763197AbZEGUgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762761AbZEGUfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:35:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40451 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbZEGUfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:35:47 -0400
Date: Thu, 7 May 2009 22:35:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Rientjes <rientjes@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-ID: <20090507203518.GA1652@ucw.cz>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072133.48917.rjw@sisk.pl> <20090507130202.34cbe37a.akpm@linux-foundation.org> <200905072218.50782.rjw@sisk.pl> <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-07 13:25:06, David Rientjes wrote:
> On Thu, 7 May 2009, Rafael J. Wysocki wrote:
> 
> > OK, let's try with __GFP_NO_OOM_KILL first.  If there's too much disagreement,
> > I'll use the freezer-based approach instead.
> > 
> 
> Third time I'm going to suggest this, and I'd like a response on why it's 
> not possible instead of being ignored.
> 
> All of your tasks are in D state other than kthreads, right?  That means 
> they won't be in the oom killer (thus no zones are oom locked), so you can 
> easily do this

Well, OOM killer may be running on behalf of some kthread at that
point....? Quite unlikely, but possible AFAICT.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
