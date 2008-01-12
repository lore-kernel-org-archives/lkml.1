Return-Path: <linux-kernel-owner+w=401wt.eu-S1763154AbYALK5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154AbYALK5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 05:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761031AbYALK5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 05:57:17 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:46764 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760587AbYALK5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 05:57:16 -0500
Date: Sat, 12 Jan 2008 16:27:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Valdis.Kletnieks@vt.edu, righiandr@users.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] per-task I/O throttling
Message-ID: <20080112105702.GC25388@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Valdis.Kletnieks@vt.edu, righiandr@users.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
References: <47869FFE.1050000@users.sourceforge.net> <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com> <47879A32.8060508@users.sourceforge.net> <3777.1200113861@turing-police.cc.vt.edu> <1200131197.7999.14.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1200131197.7999.14.camel@lappy>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-01-12 10:46:37]:

> 
> On Fri, 2008-01-11 at 23:57 -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Fri, 11 Jan 2008 17:32:49 +0100, Andrea Righi said:
> > 
> > > The interesting feature is that it allows to set a priority for each
> > > process container, but AFAIK it doesn't allow to "partition" the
> > > bandwidth between different containers (that would be a nice feature
> > > IMHO). For example it would be great to be able to define per-container
> > > limits, like assign 10MB/s for processes in container A, 30MB/s to
> > > container B, 20MB/s to container C, etc.
> > 
> > Has anybody considered allocating based on *seeks* rather than bytes moved,
> > or counting seeks as "virtual bytes" for the purposes of accounting (if the
> > disk can do 50mbytes/sec, and a seek takes 5millisecs, then count it as 100K
> > of data)?
> 
> I was considering a time scheduler, you can fill your time slot with
> seeks or data, it might be what CFQ does, but I've never even read the
> code.
>

So far the definition of I/O bandwidth has been w.r.t time. Not all IO
devices have sectors; I'd prefer bytes over a period of time.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
