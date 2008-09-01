Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYIALQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYIALQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYIALQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:16:39 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37110 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYIALQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:16:39 -0400
Date: Mon, 1 Sep 2008 13:16:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com
Subject: Re: [PATCH #blk-for-2.8] init: DEBUG_BLOCK_EXT_DEVT requires explicit  root= param
Message-ID: <20080901111635.GN20055@kernel.dk>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808292123.07246.bzolnier@gmail.com> <48B90E81.5060905@kernel.org> <200808311538.38918.bzolnier@gmail.com> <48BBCB62.4040309@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BBCB62.4040309@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01 2008, Tejun Heo wrote:
> DEBUG_BLOCK_EXT_DEVT shuffles SCSI and IDE device numbers and root
> device number set using rdev become meaningless.  Root devices should
> be explicitly specified using textual names.  Warn about it if root
> can't be found and DEBUG_BLOCK_EXT_DEVT is enabled.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> There are other ways to specify device numbers directly (ie. root=8:0)
> and DEBUG_BLOCK_EXT_DEVT being a debug option I don't think it
> warrants a complex logic, so I just added simple warning message.

How about just putting that in the help entry as well? Given that it's
now defaulting to 'n', people that enable it should read the help text
anyway.

-- 
Jens Axboe

