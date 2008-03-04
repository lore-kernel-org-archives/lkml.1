Return-Path: <linux-kernel-owner+w=401wt.eu-S933126AbYCDT0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126AbYCDT0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932321AbYCDT0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:26:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:36398 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1765701AbYCDT0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:26:18 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18fkipM+FkfMqNp1hGsa+xSwF+5/P11z8wxSWhAY8
	owGSSzFm6ubKyC
Subject: Re: [PATCH] block: fix residual byte count handling
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com,
       tomof@acm.org, James.Bottomley@HansenPartnership.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
In-Reply-To: <20080304185420.GT6704@kernel.dk>
References: <1204634238.5997.5.camel@homer.simson.net>
	 <20080304123939.GM6704@kernel.dk>
	 <1204634619.17258.0.camel@homer.simson.net>
	 <1204635515.17258.12.camel@homer.simson.net>
	 <20080304130307.GN6704@kernel.dk>
	 <1204640722.5783.10.camel@homer.simson.net>
	 <20080304181736.GP6704@kernel.dk>
	 <1204655711.19496.10.camel@homer.simson.net>
	 <20080304184534.GR6704@kernel.dk>
	 <1204656555.6598.4.camel@homer.simson.net>
	 <20080304185420.GT6704@kernel.dk>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 20:26:10 +0100
Message-Id: <1204658770.6284.2.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 19:54 +0100, Jens Axboe wrote:
> On Tue, Mar 04 2008, Mike Galbraith wrote:
> > 
> > On Tue, 2008-03-04 at 19:45 +0100, Jens Axboe wrote:
> > 
> > > > It says cc66b4512cae8df4ed1635483210aabf7690ec27... kewpie doll?
> > > 
> > > That looks right, then perhaps there's still an issue there :/
> > > Logs?
> > 
> > Tejuns patchlet (below) fixed it here.
> 
> OK, can you try changing that to
> 
>         good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;
> 
> and retest?

Yup, disk #42 is happily burning away.

	-Mike

