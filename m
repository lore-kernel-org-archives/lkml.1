Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbXKYQpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbXKYQpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 11:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXKYQpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 11:45:36 -0500
Received: from brick.kernel.dk ([87.55.233.238]:23802 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbXKYQpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 11:45:36 -0500
Date: Sun, 25 Nov 2007 17:45:32 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Message-ID: <20071125164532.GB6658@kernel.dk>
References: <20071125161801.GB21947@stusta.de> <20071125162105.GA6658@kernel.dk> <20071125163153.GD21947@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125163153.GD21947@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25 2007, Adrian Bunk wrote:
> On Sun, Nov 25, 2007 at 05:21:07PM +0100, Jens Axboe wrote:
> > On Sun, Nov 25 2007, Adrian Bunk wrote:
> > > There isn't any big advantage and doesn't seem to be much usage of 
> > > modular schedulers.
> > > 
> > > OTOH, the overhead made the kernel image of an x86 defconfig (that 
> > > doesn't use modular schedulers) bigger by nearly 2 kB.
> > 
> > Big nack, I use it all the time for testing.
> 
> OK.
> 
> > Just because you don't
> > happen to use it is not a reason to remove it.
> 
> s/you/you and all distributions you checked/

Well they should make them modules (two of them, that is). It's been a
long time since I considered a distro .config a benchmark/guideline of
any sort.

-- 
Jens Axboe

