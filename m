Return-Path: <linux-kernel-owner+w=401wt.eu-S1765754AbZDHNxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765754AbZDHNxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765562AbZDHNx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:53:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35368 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758608AbZDHNx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:53:27 -0400
Date: Wed, 8 Apr 2009 15:53:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       axboe@kernel.dk
Subject: Re: Multiple Tracers
Message-ID: <20090408135312.GR18581@elte.hu>
References: <1239197703.3359.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239197703.3359.25.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Whitehouse <swhiteho@redhat.com> wrote:

> Hi,
> 
> A little while back I posted a RFC patch which added gfs2 glock 
> tracing to blktrace. There was a suggestion that I should look 
> instead at the generic tracing code and add a new tracer, but I've 
> come up with a couple of issues along the way.
> 
> I think from what I can see that its only possible to run a single 
> tracer at once, so running blktrace (for example) would preclude 
> me from also tracing gfs2's glocks at the same time. Also, I can 
> see no mechanism by which I could ensure the sequencing between 
> the blktrace and glock traces other than exporting the blktrace 
> sequence number, even if running multiple tracers at the same time 
> was possible.

There's a recent addition: the EVENT_TRACE() facility. Would that 
suit your purposes?

	Ingo
