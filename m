Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXLVKxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXLVKxa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 05:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXLVKxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 05:53:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbXLVKxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 05:53:20 -0500
Date: Sat, 22 Dec 2007 02:52:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Jon Masters <jcm@redhat.com>, Michal Schmidt <mschmidt@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: [PATCH] kthread: run kthreadd with max priority SCHED_FIFO
Message-Id: <20071222025228.02905a01.akpm@linux-foundation.org>
In-Reply-To: <1198319970.5509.10.camel@homer.simson.net>
References: <20071217234314.540b59bd@hammerfall>
	<20071222013021.db2528cb.akpm@linux-foundation.org>
	<1198317171.24423.47.camel@perihelion>
	<1198319970.5509.10.camel@homer.simson.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007 11:39:30 +0100 Mike Galbraith <efault@gmx.de> wrote:

> 
> On Sat, 2007-12-22 at 04:52 -0500, Jon Masters wrote:
> 
> > So, user tasks running with SCHED_FIFO should be able to lock a system?
> > I guess I see both sides of this argument - yes, it's userspace at
> > fault, but in other cases when userspace is at fault, we take action
> > (OOM, segfault, others). Isn't this situation just another case where
> > the kernel needs to avoid the evils of userland going awry?
> 
> FYI, Ingo queued the below.
> 
> http://lkml.org/lkml/2007/10/31/344
> 

That's pretty different of course, but rlimit might be a suitable interface
for implementing RLIMIT_MAX_CONTINUOUS_RT_MILLISECONDS.

