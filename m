Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbZCRWKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbZCRWKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbZCRWKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:10:36 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:58310 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752718AbZCRWKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:10:35 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Wed, 18 Mar 2009 22:07:53 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] sched: Clean unused fields from struct rq
Message-ID: <20090318220753.GA8375@hades.domain.com>
References: <20090318202824.GA5025@hades.domain.com> <49C160D6.6010409@novell.com> <20090318215224.GA8030@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318215224.GA8030@hades.domain.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 09:52:24PM +0000, Luis Henriques wrote:
> Hi,
> On Wed, Mar 18, 2009 at 05:00:06PM -0400, Gregory Haskins wrote:
> > I actually key off the SCHEDSTAT_VERSION (currently 14) at the top of
> > kernel/sched_stats.h.  Cursory inspection of the existing code and your
> > patch says that this should actually be the value that needs updating
> > (vs. vSched-Debug).  However, note that I am not sure if there are also
> > users of sched-debug that need to see that version bump as well in order
> > to remain compatible.
> 
> Just realised something while taking a look at you're schedtop: you are
> referring to sched_stats, which shows data in /proc/schedstat, while my patch
> actually targets sched_debug, which shows data in /proc/sched_debug.  And I
> guess this is why we have 2 different versioning mechanisms:  they refer to
> different things :-)
> 
> So, if this is correct, my last patch actually updates the correct version,
> right?

Gah!  Wrong again!

My patch touches both sched_debug and sched_stats, so I believe I need to change
both versions.

-- 
Luis Henriques
