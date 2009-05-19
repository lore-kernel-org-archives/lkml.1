Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbZESJiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbZESJiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZESJiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:38:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42916 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbZESJiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:38:05 -0400
Date: Tue, 19 May 2009 11:38:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, max@duempel.org, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] splice: implement default splice_read method
Message-ID: <20090519093806.GU4140@kernel.dk>
References: <20090507133734.450612199@szeredi.hu> <20090507133748.161689790@szeredi.hu> <20090512223500.d7ef4648.akpm@linux-foundation.org> <20090513063707.GC4140@kernel.dk> <E1M4ALP-0005za-1i@pomaz-ex.szeredi.hu> <20090514172935.GR4140@kernel.dk> <E1M4f8b-0000Tb-GI@pomaz-ex.szeredi.hu> <20090514180003.GU4140@kernel.dk> <E1M6254-00070d-0p@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M6254-00070d-0p@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18 2009, Miklos Szeredi wrote:
> Hi Jens,
> 
> On Thu, 14 May 2009, Jens Axboe wrote:
> > On Thu, May 14 2009, Miklos Szeredi wrote:
> > > > > Hmm.  Simple solution would be to do a write() for each buffer.  But
> > > > > this only affects HIGHMEM kernels, so it's a bit pointless to do that
> > > > > on all archs.  Sigh...
> > > > 
> > > > It is unfortunate, we are going to be stuck with that for some time
> > > > still...
> 
> Here's a patch that fixes the multiple kmap() issue.  It goes on top
> of the previous splice patches.

Thanks Miklos, applied.

-- 
Jens Axboe

