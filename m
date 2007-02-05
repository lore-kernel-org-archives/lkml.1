Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXBEMPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXBEMPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 07:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXBEMPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 07:15:11 -0500
Received: from brick.kernel.dk ([62.242.22.158]:25836 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbXBEMPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:15:10 -0500
Date: Mon, 5 Feb 2007 13:17:35 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070205121735.GD4487@kernel.dk>
References: <Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com> <20070131163638.290f40c1.akpm@osdl.org> <20070201062018.GC33919298@melbourne.sgi.com> <20070131231253.fdebc9f5.akpm@osdl.org> <Pine.LNX.4.64.0702011055310.7010@schroedinger.engr.sgi.com> <20070201191857.GQ10305@kernel.dk> <Pine.LNX.4.64.0702011214230.10061@schroedinger.engr.sgi.com> <20070201202646.GR10305@kernel.dk> <Pine.LNX.4.64.0702011435060.4632@schroedinger.engr.sgi.com> <20070205120253.GC4487@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205120253.GC4487@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05 2007, Jens Axboe wrote:
> On Thu, Feb 01 2007, Christoph Lameter wrote:
> > On Thu, 1 Feb 2007, Jens Axboe wrote:
> > 
> > > That looks like barriers, could you try with those disabled? Sorry for
> > > making you go through this, I can't debug and fix it myself before
> > > monday.
> > 
> > Disabling barriers + your patch works. Modified /etc/fstab and added a 
> > nobarrier option to the root filesystem. If I take your patch out then the 
> > systems hangs again.
> 
> I can't reproduce this. Can you see if this debug patch catches
> anything? You need to enable barriers again.

Nevermind, that was too aggressive. I'll come up with a better debug
patch.

-- 
Jens Axboe

