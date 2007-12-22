Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbXLVLVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbXLVLVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 06:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXLVLVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 06:21:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbXLVLVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 06:21:33 -0500
Subject: Re: [PATCH] kthread: run kthreadd with max priority SCHED_FIFO
From: Jon Masters <jcm@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Michal Schmidt <mschmidt@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <20071222025228.02905a01.akpm@linux-foundation.org>
References: <20071217234314.540b59bd@hammerfall>
	 <20071222013021.db2528cb.akpm@linux-foundation.org>
	 <1198317171.24423.47.camel@perihelion>
	 <1198319970.5509.10.camel@homer.simson.net>
	 <20071222025228.02905a01.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Sat, 22 Dec 2007 06:21:18 -0500
Message-Id: <1198322478.24423.75.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-22 at 02:52 -0800, Andrew Morton wrote:
> On Sat, 22 Dec 2007 11:39:30 +0100 Mike Galbraith <efault@gmx.de> wrote:
> 
> > 
> > On Sat, 2007-12-22 at 04:52 -0500, Jon Masters wrote:
> > 
> > > So, user tasks running with SCHED_FIFO should be able to lock a system?
> > > I guess I see both sides of this argument - yes, it's userspace at
> > > fault, but in other cases when userspace is at fault, we take action
> > > (OOM, segfault, others). Isn't this situation just another case where
> > > the kernel needs to avoid the evils of userland going awry?
> > 
> > FYI, Ingo queued the below.
> > 
> > http://lkml.org/lkml/2007/10/31/344
> > 
> 
> That's pretty different of course, but rlimit might be a suitable interface
> for implementing RLIMIT_MAX_CONTINUOUS_RT_MILLISECONDS.

Right. Just when I thought there was no point in continuing (Ingo having
invented everything already, as usual), this specific problem remains.

I'll try bouncing some ideas off Ingo later.

Jon.


