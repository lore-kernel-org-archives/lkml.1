Return-Path: <linux-kernel-owner+w=401wt.eu-S1765109AbYCDQFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765109AbYCDQFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbYCDQFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:05:16 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33185 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218AbYCDQFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:05:14 -0500
Subject: Re: [PATCH] block: fix residual byte count handling
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Galbraith <efault@gmx.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com,
       tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
In-Reply-To: <20080304123939.GM6704@kernel.dk>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp>
	 <20080304085944.GG6704@kernel.dk>
	 <20080304180648W.fujita.tomonori@lab.ntt.co.jp>
	 <20080304182228Z.fujita.tomonori@lab.ntt.co.jp>
	 <20080304093536.GH6704@kernel.dk>
	 <1204634238.5997.5.camel@homer.simson.net>
	 <20080304123939.GM6704@kernel.dk>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 10:04:55 -0600
Message-Id: <1204646695.3091.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 13:39 +0100, Jens Axboe wrote:
> On Tue, Mar 04 2008, Mike Galbraith wrote:
> > 
> > On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:
> > 
> > > Looks excellent to me, has a variant of this been tested as OK by the
> > > users reporting the regression?
> > 
> > K3b burning seems to be a nogo here.  This is git pulled this morning
> > though, so it's a somewhat different tree than previously tested fwtw.
> 
> can you please try git as of this morning without any patches applied,
> and then pull
> 
> git://git.kernel.dk/linux-2.6-block.git for-linus
> 
> into that and see if that works?

Works for me with the SAS SMP handler.  Both input request and output
response frame sizes are picked up and returned with the correct
residues.

James


