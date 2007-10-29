Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbXJ2O5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbXJ2O5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbXJ2O5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:57:05 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:44440 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752172AbXJ2O5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:57:04 -0400
Date: Mon, 29 Oct 2007 15:57:11 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] cleanup asm/scatterlist.h includes
Message-ID: <20071029145711.GO7227@stusta.de>
References: <20071029124907.GI7227@stusta.de> <20071029131301.GD5001@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071029131301.GD5001@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 02:13:01PM +0100, Jens Axboe wrote:
> On Mon, Oct 29 2007, Adrian Bunk wrote:
> > Not architecture specific code should not #include <asm/scatterlist.h>.
> > 
> > This patch therefore either replaces them with
> > #include <linux/scatterlist.h> or simply removes them if they were 
> > unused.
> 
> Looks fine to me - what did you compile test this on?

i386 all static and all modular configs (slightly different from but 
similar to allyesconfig+allmodconfig) and defconfigs of
24 architectures (but some of them fail to compile due to different 
problems).

> Jens Axboe

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

