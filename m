Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbXKYQVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbXKYQVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 11:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXKYQVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 11:21:12 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21678 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbXKYQVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 11:21:11 -0500
Date: Sun, 25 Nov 2007 17:21:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Message-ID: <20071125162105.GA6658@kernel.dk>
References: <20071125161801.GB21947@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125161801.GB21947@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25 2007, Adrian Bunk wrote:
> There isn't any big advantage and doesn't seem to be much usage of 
> modular schedulers.
> 
> OTOH, the overhead made the kernel image of an x86 defconfig (that 
> doesn't use modular schedulers) bigger by nearly 2 kB.

Big nack, I use it all the time for testing. Just because you don't
happen to use it is not a reason to remove it.

-- 
Jens Axboe

