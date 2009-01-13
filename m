Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbZAMNV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbZAMNV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:21:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZAMNVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:21:19 -0500
Received: from styx.suse.cz ([82.119.242.94]:60289 "EHLO dhcp35"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753313AbZAMNVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:21:18 -0500
Date: Tue, 13 Jan 2009 14:21:17 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
Message-ID: <20090113132117.GA5571@dhcp35.suse.cz>
References: <20090113122455.GA24824@dhcp35.suse.cz> <20090113123425.GB29926@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113123425.GB29926@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13-01-09 13:34:25, Ingo Molnar wrote:
> 
> * Michal Hocko <mhocko@suse.cz> wrote:
> 
> > Hi,
> > I am not sure whether someone has already reported this, but 
> > I can see the following early boot WARNING with the 2.6.29-rc1 kernel in
> > the serial console output:
> > 
> > ------------[ cut here ]------------
> > WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
> 
> That one should be fixed in tip/master and it is in the to-Linus queue of 
> fixes:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> it's this commit:
> 
>   01e3eb8: Revert "sched: improve preempt debugging"
> 
> if you want to cherry-pick the fix.

Thanks that fixes the issue on my end.

> 
> 	Ingo

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
