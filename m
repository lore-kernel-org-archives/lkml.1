Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbYEEQdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbYEEQdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYEEQdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:33:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:11052 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbYEEQdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:33:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HlWLh3VOT0SwQ8NNwrdmWfQhp+OezJ4CvNM6/8Yh5D1FoqQAsIK6O0FPZsgqMW2SefrVa+REr69F1HG23zK+l5CQSmK6JGnEzoo7M/tWcYJShnjXV+ybOQ+Ff8PRBL08yuTlOjTp6PaWyxIAByVXN4CvmAwOj+NhYDi2FzJ61YU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/3] ide: set REQ_NOMERGE request flag in ide_do_drive_cmd()
Date: Mon, 5 May 2008 18:31:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, jens.axboe@oracle.com
References: <200805031514.24727.bzolnier@gmail.com> <20080505204334P.tomof@acm.org>
In-Reply-To: <20080505204334P.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051831.12574.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008, FUJITA Tomonori wrote:
> On Sat, 3 May 2008 15:14:24 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > This is a preparation for converting IDE to use blk_execute_rq().
> > 
> > There should be no functional changes caused by this patch.
> > 
> > Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Borislav Petkov <petkovbb@gmail.com>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ide/ide-io.c |    2 ++
> >  1 file changed, 2 insertions(+)
> 
> I think that you can drop this since the block layer doesn't check
> REQ_NOMERGE with the way ide_do_drive_cmd queues requests.

Yeah, I see now that REQ_NOMERGE only matters for fs requests.

Dropped.
