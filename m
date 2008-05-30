Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbYE3GwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbYE3GwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 02:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYE3GwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 02:52:07 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52141 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753694AbYE3GwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 02:52:06 -0400
Date: Fri, 30 May 2008 01:52:00 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: Give cpusets exclusive control over sched
 domains (ie remove cpu_isolated_map)
Message-Id: <20080530015200.f299afed.pj@sgi.com>
In-Reply-To: <483F8178.7040300@qualcomm.com>
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-2-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-3-git-send-email-maxk@qualcomm.com>
	<20080529173759.ccbaf8ef.pj@sgi.com>
	<483F3559.1030806@qualcomm.com>
	<20080529191211.080ec5cf.pj@sgi.com>
	<483F8178.7040300@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max replied:
> > I did not see your reply.  Did you send it to me or lkml?
> http://marc.info/?l=linux-kernel&m=121207910616332&w=2

Ah - ok - I got that reply, and then lost track of it.  My bad.

Max wrote, in that earlier reply:
> Since we do not plan on supporting it I'd say lets get rid of it.

This doesn't make sense to me.  We don't just decree that we aren't
planning on supporting something that's already out there and being
used, and then remove it, on the grounds we aren't supporting it.

Faceless beauracracies can get away with that ... we can do better.

> > My concern is removing user visible features, without
> > good reason and careful consideration and some planning.
> I understand. How would you plan for this ?

I don't plan for removing it yet, because I haven't seen a good
reason to remove it.

> Did you get a chance to look at patch that addresses hotplug/domain issues ?

Not yet.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
