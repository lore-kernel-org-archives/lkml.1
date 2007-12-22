Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbXLVKjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbXLVKjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 05:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbXLVKj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 05:39:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:37639 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750700AbXLVKj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 05:39:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19QhBAa67VQFIx+rKdaUufZqwO4WBIi98kMfqOJCv
	zxB5Ena7brBFb8
Subject: Re: [PATCH] kthread: run kthreadd with max priority SCHED_FIFO
From: Mike Galbraith <efault@gmx.de>
To: Jon Masters <jcm@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <1198317171.24423.47.camel@perihelion>
References: <20071217234314.540b59bd@hammerfall>
	 <20071222013021.db2528cb.akpm@linux-foundation.org>
	 <1198317171.24423.47.camel@perihelion>
Content-Type: text/plain
Date: Sat, 22 Dec 2007 11:39:30 +0100
Message-Id: <1198319970.5509.10.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-22 at 04:52 -0500, Jon Masters wrote:

> So, user tasks running with SCHED_FIFO should be able to lock a system?
> I guess I see both sides of this argument - yes, it's userspace at
> fault, but in other cases when userspace is at fault, we take action
> (OOM, segfault, others). Isn't this situation just another case where
> the kernel needs to avoid the evils of userland going awry?

FYI, Ingo queued the below.

http://lkml.org/lkml/2007/10/31/344

	-Mike




