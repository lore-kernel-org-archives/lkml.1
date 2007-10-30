Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbXJ3Jh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbXJ3Jh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbXJ3Jhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:37:47 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21409 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376AbXJ3Jhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:37:46 -0400
Date: Tue, 30 Oct 2007 10:35:15 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] cleanup asm/scatterlist.h includes
Message-ID: <20071030093515.GI4993@kernel.dk>
References: <20071029124907.GI7227@stusta.de> <20071029131301.GD5001@kernel.dk> <20071029145711.GO7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029145711.GO7227@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29 2007, Adrian Bunk wrote:
> On Mon, Oct 29, 2007 at 02:13:01PM +0100, Jens Axboe wrote:
> > On Mon, Oct 29 2007, Adrian Bunk wrote:
> > > Not architecture specific code should not #include <asm/scatterlist.h>.
> > > 
> > > This patch therefore either replaces them with
> > > #include <linux/scatterlist.h> or simply removes them if they were 
> > > unused.
> > 
> > Looks fine to me - what did you compile test this on?
> 
> i386 all static and all modular configs (slightly different from but 
> similar to allyesconfig+allmodconfig) and defconfigs of
> 24 architectures (but some of them fail to compile due to different 
> problems).

Good, applied!

-- 
Jens Axboe

