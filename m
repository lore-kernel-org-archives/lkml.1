Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbXFDIHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbXFDIHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 04:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbXFDIHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 04:07:16 -0400
Received: from brick.kernel.dk ([80.160.20.94]:5370 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbXFDIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 04:07:15 -0400
Date: Mon, 4 Jun 2007 10:05:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, cotte@de.ibm.com, hugh@veritas.com,
       neilb@suse.de, zanussi@us.ibm.com, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070604080535.GP32105@kernel.dk>
References: <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com> <465FC92C.50608@cosmosbay.com> <466040C1.6030004@zytor.com> <alpine.LFD.0.98.0706010904110.3957@woody.linux-foundation.org> <20070602150104.GH32105@kernel.dk> <alpine.LFD.0.98.0706020836360.23741@woody.linux-foundation.org> <20070603130507.GA11170@mail.ustc.edu.cn> <20070603142931.GA5916@mail.ustc.edu.cn> <20070604004647.GA8076@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604004647.GA8076@mail.ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04 2007, Fengguang Wu wrote:
> Hi Jens,
> 
> This is another try, still not in a comfortable state though.
> //Busy waiting is possible for interleaved reads.

A few random comments...

Adding an internal flag is fine, but please put it at the upper end of
the spectrum. So, use (1 << 31) for that flag.

And please work on the #splice branch of the block repo, not -mm. There
are quite a few things pending for inclusion in there, and I'm sure your
patch as-is wont apply.

-- 
Jens Axboe

