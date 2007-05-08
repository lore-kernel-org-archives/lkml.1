Return-Path: <linux-kernel-owner+w=401wt.eu-S968005AbXEHNzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968005AbXEHNzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967564AbXEHNzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:55:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37968 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966841AbXEHNzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:55:53 -0400
Date: Tue, 8 May 2007 15:53:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rene Herman <rene.herman@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
Message-ID: <20070508135327.GQ4163@kernel.dk>
References: <464045F0.3040906@gmail.com> <84144f020705080653i16d324c8pbd2925d844f400fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020705080653i16d324c8pbd2925d844f400fc@mail.gmail.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08 2007, Pekka Enberg wrote:
> Hi Rene,
> 
> On 5/8/07, Rene Herman <rene.herman@gmail.com> wrote:
> >+static int __mitsumi_read_toc(struct mitsumi_cdrom *mcd)
> >+{
> >+       int tracks = mcd->header.cdth_trk1 - mcd->header.cdth_trk0 + 1;
> >+       int retries;
> >+       int err = 0;
> >+
> >+       kfree(mcd->toc);
> >+
> >+       mcd->toc = kzalloc(tracks * sizeof *mcd->toc, GFP_KERNEL);
> 
> Perhaps we should use krealloc() + memset() here?

and sizeof(*cmd->toc) as well.

-- 
Jens Axboe

