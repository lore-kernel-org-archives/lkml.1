Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbYIALXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbYIALXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 07:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758968AbYIALXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 07:23:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:33255 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758662AbYIALXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 07:23:12 -0400
Message-ID: <48BBD01A.7000603@kernel.org>
Date: Mon, 01 Sep 2008 13:20:58 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dm-devel@redhat.com
Subject: Re: [PATCH #blk-for-2.8] init: DEBUG_BLOCK_EXT_DEVT requires explicit
  root= param
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808292123.07246.bzolnier@gmail.com> <48B90E81.5060905@kernel.org> <200808311538.38918.bzolnier@gmail.com> <48BBCB62.4040309@kernel.org> <20080901111635.GN20055@kernel.dk>
In-Reply-To: <20080901111635.GN20055@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Sep 2008 11:22:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> There are other ways to specify device numbers directly (ie. root=8:0)
>> and DEBUG_BLOCK_EXT_DEVT being a debug option I don't think it
>> warrants a complex logic, so I just added simple warning message.
> 
> How about just putting that in the help entry as well? Given that it's
> now defaulting to 'n', people that enable it should read the help text
> anyway.

I'll add that to help message but I still think it'll be beneficial to
have warning message printed to avoid getting people off guard. e.g.
alpha/beta distro built with the debug option turned on to detect bugs.

Thanks.

-- 
tejun
