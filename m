Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbYEENEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbYEENEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYEEND5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:03:57 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:50885 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbYEEND4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:03:56 -0400
Date: Mon, 5 May 2008 22:02:53 +0900
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, petkovbb@gmail.com,
       jens.axboe@oracle.com
Subject: Re: [PATCH 2/3] ide: set REQ_NOMERGE request flag in
 ide_do_drive_cmd()
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200805031514.24727.bzolnier@gmail.com>
References: <200805031514.24727.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080505204334P.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008 15:14:24 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> This is a preparation for converting IDE to use blk_execute_rq().
> 
> There should be no functional changes caused by this patch.
> 
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-io.c |    2 ++
>  1 file changed, 2 insertions(+)

I think that you can drop this since the block layer doesn't check
REQ_NOMERGE with the way ide_do_drive_cmd queues requests.
