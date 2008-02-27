Return-Path: <linux-kernel-owner+w=401wt.eu-S1765221AbYB0CYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765221AbYB0CYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 21:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbYB0CYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 21:24:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:41034 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755062AbYB0CYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 21:24:39 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX188wrcGyBI8/lAIG0FgjnqZxexK7cRZbBOsLhwGUU
	OanGrB2/i5SSuq
Subject: Re: regression: CD burning (k3b) went broke
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <20080226150845.2196bc1a.akpm@linux-foundation.org>
References: <1203583379.6244.27.camel@homer.simson.net>
	 <20080222073228.GZ23197@kernel.dk>
	 <1203752563.5225.4.camel@homer.simson.net>
	 <1203839683.17463.9.camel@homer.simson.net>
	 <1204019283.8731.11.camel@homer.simson.net>
	 <1204033003.11828.22.camel@homer.simson.net>
	 <20080226150845.2196bc1a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 03:24:35 +0100
Message-Id: <1204079075.26640.8.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-26 at 15:08 -0800, Andrew Morton wrote:
> On Tue, 26 Feb 2008 14:36:43 +0100 Mike Galbraith <efault@gmx.de> wrote:

> > Seems the problem is data_len changes, but raw_data_len doesn't.  I've
> > not the foggiest IO-land clue, but k3b works again, so the below may
> > have some diagnostic value.
> 
> So this change fixes a bug?  Can we have a recap of how it does this?

Yeah, it fixes the problem.  (wrt recap, if I could write it, it would
be a changelog;)

	-Mike

