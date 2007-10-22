Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbXJVSQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbXJVSQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbXJVSQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:16:24 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22179 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbXJVSQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:16:23 -0400
Date: Mon, 22 Oct 2007 20:16:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block layer: remove a unused argument of drive_stat_acct()
Message-ID: <20071022181618.GC16425@kernel.dk>
References: <471CACC3.7000007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471CACC3.7000007@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22 2007, Jerome Marchand wrote:
> The nr_sector argument of drive_stat_acct() is not used anymore since
> the read and write sectors statistics are now updated in
> end_that_request_first(). This patch removes the useless argument.

Thanks, applied.

-- 
Jens Axboe

