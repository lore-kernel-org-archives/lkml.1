Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbXFLQYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbXFLQYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbXFLQYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:24:35 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9097 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbXFLQYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:24:35 -0400
Date: Tue, 12 Jun 2007 18:22:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/18] splice: abstract out actor data
Message-ID: <20070612162215.GM18832@kernel.dk>
References: <11816314942627-git-send-email-jens.axboe@oracle.com> <11816314942637-git-send-email-jens.axboe@oracle.com> <20070612173150.80f6f7e3.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612173150.80f6f7e3.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12 2007, Eric Dumazet wrote:
> On Tue, 12 Jun 2007 08:57:57 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> 
> > +	struct splice_desc sd = {
> > +		.total_len = len,
> > +		.flags = flags,
> > +		.pos = *ppos,
> > +	};
> > +
> > +	sd.file = out;
> 
> minor remark, why sd.file is setup differently than other fields ?
> 
> (this several times on this patch)

yeah, it's inside an anonymous union, and apparently gcc doesn't like it
being initialized that way.

-- 
Jens Axboe

