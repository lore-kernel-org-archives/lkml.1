Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbXLCPzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbXLCPzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 10:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbXLCPzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 10:55:33 -0500
Received: from homer.mvista.com ([63.81.120.155]:38535 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750730AbXLCPzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:55:32 -0500
Message-ID: <47542704.2030602@ru.mvista.com>
Date: Mon, 03 Dec 2007 18:55:48 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, jens.axboe@oracle.com,
       bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 26/28] blk_end_request: changing ide-cd (take 3)
References: <20071130.183447.82055860.k-ueda@ct.jp.nec.com> <200712012342.52134.bzolnier@gmail.com>
In-Reply-To: <200712012342.52134.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> [PATCH] ide-cd: remove dead post_transform_command()

> post_transform_command() call in cdrom_newpc_intr() has no effect because
> it is done after the request has already been fully completed (rq->bio and
> rq->data are always NULL).  It was verified to be true regardless whether
> INQUIRY command is using DMA or PIO to transfer data (by using modified
> Tejun Heo's test-shortsg.c utility and adding a few printk()-s to ide-cd).

> This was uncovered thanks to the "blk_end_request: full I/O completion
> handler (take 3)" patch series from Kiyoshi Ueda.

> Cc: jens.axboe@oracle.com
> Cc: bharrosh@panasas.com
> Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: Tejun Heo <htejun@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
