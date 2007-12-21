Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbXLUTfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbXLUTfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 14:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbXLUTfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 14:35:12 -0500
Received: from brick.kernel.dk ([87.55.233.238]:24689 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbXLUTfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 14:35:11 -0500
Date: Fri, 21 Dec 2007 20:35:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH - SH/Dreamcast] Add support for GD-Rom device
Message-ID: <20071221193505.GA26896@kernel.dk>
References: <8b67d60712201559h5dbb2a17q8f16223b26b88006@mail.gmail.com> <8b67d60712201607k66d67fa2la8b21fc698fdb3ab@mail.gmail.com> <20071221121441.GB11583@kernel.dk> <1198264359.7235.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198264359.7235.1.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21 2007, Adrian McMenamin wrote:
> 
> On Fri, 2007-12-21 at 13:14 +0100, Jens Axboe wrote:
> 
> > 
> > What is pages doing in gdrom_request()?
> > 
> 
> As the device doesn't do scatter-gather I've set
> blk_queue_max_segment_size to 1 and am not bothering with pages - is
> that wrong?

I mean this:

        unsigned long pages;
        pages = rq->backing_dev_info.ra_pages;

and you never use 'pages'.

-- 
Jens Axboe

