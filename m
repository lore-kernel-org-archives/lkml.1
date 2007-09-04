Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbXIDV3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbXIDV3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 17:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbXIDV3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 17:29:07 -0400
Received: from brick.kernel.dk ([87.55.233.238]:5755 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbXIDV3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 17:29:05 -0400
Date: Tue, 4 Sep 2007 23:24:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Halevy, Benny" <bhalevy@panasas.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca,
       "Harrosh, Boaz" <bharrosh@panasas.com>, dm-devel@redhat.com,
       j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 6/7] blk_end_request: remove/unexport end_that_request_*
Message-ID: <20070904212435.GG4117@kernel.dk>
References: <20070831.184335.85683085.k-ueda@ct.jp.nec.com> <E472128B1EB43941B4E7FB268020C89B02992D9B@riverside.int.panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E472128B1EB43941B4E7FB268020C89B02992D9B@riverside.int.panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04 2007, Halevy, Benny wrote:
> Boaz raised my attention to this patchset today...
> We suspect we'll still need the extern entry points for handling the bidi 
> request in the scsi_io_completion() path as we only want to call
> end_that_request_chunk on req->next_rq and never
> end_that_request_last.
>  
> (see 
> http://www.bhalevy.com/open-osd/download/linux-2.6.23-rc2_and_iscsi-iscsi-2007_08_09/0005-SCSI-bidi-support.patch)
>  
> If this is ok with you I'd leave these entry points in place rather than
> taking them out and putting them back in later.

There's no point in leaving them in when nothing current needs it, I'd
much rather add it back in should the need arise. That's the proper way
to handle things like this.

-- 
Jens Axboe

