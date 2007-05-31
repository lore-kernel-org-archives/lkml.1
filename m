Return-Path: <linux-kernel-owner+w=401wt.eu-S1761291AbXEaLHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291AbXEaLHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 07:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759912AbXEaLHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 07:07:25 -0400
Received: from brick.kernel.dk ([80.160.20.94]:8714 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250AbXEaLHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 07:07:24 -0400
Date: Thu, 31 May 2007 13:06:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: carsteno@de.ibm.com
Cc: linux-kernel@vger.kernel.org, hugh@veritas.com, neilb@suse.de,
       zanussi@us.ibm.com, Linus Torvalds <torvalds@osdl.org>,
       hch@infradead.org
Subject: Re: [PATCH] sendfile removal
Message-ID: <20070531110623.GS32105@kernel.dk>
References: <20070531103316.GO32105@kernel.dk> <465EABD2.9090102@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465EABD2.9090102@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31 2007, Carsten Otte wrote:
> Jens Axboe wrote:
> >Work to be done:
> >
> >- The ext2 xip support needs a splice_read() implementation, currently I
> >  just if 0'ed out the send xip_file_sendfile(). CC'ed Carsten, who
> >  seems to be the author of this code.
> Yup. Will do the splice_read implementation for xip. Do you want to 
> see it in splice.c or should it go to filemap_xip?

Just put it in filemap_xip.c, I think that would be the best place.
Thanks!

> Acked-by: Carsten Otte <cotte@de.ibm.com>

-- 
Jens Axboe

