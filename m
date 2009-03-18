Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbZCRVWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbZCRVWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZCRVWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:22:36 -0400
Received: from relay6.ptmail.sapo.pt ([212.55.154.26]:59574 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751604AbZCRVWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:22:36 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Wed, 18 Mar 2009 21:20:15 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] sched: Clean unused fields from struct rq
Message-ID: <20090318212015.GA6183@hades.domain.com>
References: <20090318202824.GA5025@hades.domain.com> <49C160D6.6010409@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C160D6.6010409@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Wed, Mar 18, 2009 at 05:00:06PM -0400, Gregory Haskins wrote:
> I actually key off the SCHEDSTAT_VERSION (currently 14) at the top of
> kernel/sched_stats.h.  Cursory inspection of the existing code and your
> patch says that this should actually be the value that needs updating
> (vs. vSched-Debug).  However, note that I am not sure if there are also
> users of sched-debug that need to see that version bump as well in order
> to remain compatible.

Hmm... so, what's the relation between SCHEDSTAT_VERSION and the "Sched Debug"
version I update in my patch?  Assuming there is a relation... :-)

I believe that I actually need to update both versioning mechanims but I think
this is something odd -- either there is one mechanism to handle version or a
comment should clarify why there are two.

> If you are really motivated, you can test your patches against my
> schedtop tool to verify sane behavior (for bumping SCHEDSTAT_VERSION to
> 15, I would expect it to gracefully report that it cannot handle this
> version and exit).  You can find both source and rpms here:

Sure I will give it a try -- I'll let you know about the result.

Thanks!
-- 
Luis Henriques
