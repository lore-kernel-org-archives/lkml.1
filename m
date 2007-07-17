Return-Path: <linux-kernel-owner+w=401wt.eu-S1759386AbXGQDCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386AbXGQDCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 23:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbXGQDBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 23:01:50 -0400
Received: from gw.goop.org ([64.81.55.164]:33265 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbXGQDBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 23:01:50 -0400
Message-ID: <469C30E5.9060909@goop.org>
Date: Mon, 16 Jul 2007 20:00:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>	<469C11B1.8000302@garzik.org>	<20070716175347.bea345dd.akpm@linux-foundation.org>	<469C1423.3090908@garzik.org> <20070716180908.e15325bd.akpm@linux-foundation.org> <469C1FA9.3090809@garzik.org>
In-Reply-To: <469C1FA9.3090809@garzik.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> + uninitialized_var(ino.partitionReferenceNum);
> +
>                                 if (!UDF_SB_LASTBLOCK(sb))
>
> still yields
>
> fs/udf/super.c: In function ‘udf_fill_super’:
> fs/udf/super.c:1359: warning: ‘ino.partitionReferenceNum’ may be used
> uninitialized in this function

It only works on declarations:

	int uninitialized_var(foo);


    J
