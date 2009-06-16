Return-Path: <linux-kernel-owner+w=401wt.eu-S1761170AbZFPS2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761170AbZFPS2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbZFPS2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:28:08 -0400
Received: from brick.kernel.dk ([93.163.65.50]:42699 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807AbZFPS2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:28:08 -0400
Date: Tue, 16 Jun 2009 20:28:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Steve Rottinger <steve@pentek.com>
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: splice methods in character device driver
Message-ID: <20090616182810.GD11363@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk> <4A0AFC62.3090002@pentek.com> <c384c5ea0906031432x2675c5a4xcc940a567ca408b8@mail.gmail.com> <20090604073218.GT11363@kernel.dk> <4A27CA0A.7060400@pentek.com> <20090616115917.GX11363@kernel.dk> <4A37B4D8.5090404@pentek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37B4D8.5090404@pentek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16 2009, Steve Rottinger wrote:
> >> I'm doing about 300MB/s to my hardware RAID, running two instances of my
> >> splice() copy application
> >> (One on each RAID channel).  I would like to combine the two RAID
> >> channels using a software RAID 0;
> >> however, splice, even from /dev/zero runs horribly slow to a software
> >> RAID device.  I'd be curious
> >> to know if anyone else has tried this?
> >>     
> >
> > Did you trace it and find out why it was slow? It should not be. Moving
> > 300MB/sec should not be making any machine sweat.
> >
> I haven't dug into this too deeply, yet; however, I did discover
> something interesting: The splice runs much faster using the software
> raid, if I transfer to a file on a mounted filesystem, instead of the
> raw md block device. 

OK, that's a least a starting point. I'll try this tomorrow (raw block
device vs fs file).

-- 
Jens Axboe

