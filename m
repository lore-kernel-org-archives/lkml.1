Return-Path: <linux-kernel-owner+w=401wt.eu-S933794AbXGMFnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794AbXGMFnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXGMFnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:43:01 -0400
Received: from brick.kernel.dk ([80.160.20.94]:26443 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbXGMFnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:43:00 -0400
Date: Fri, 13 Jul 2007 07:42:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, netdev@vger.kernel.org, geert@linux-m68k.org,
       zippel@linux-m68k.org, linux-m68k@vger.kernel.org
Subject: Re: [2.6 patch] more ACSI removal
Message-ID: <20070713054247.GZ4587@kernel.dk>
References: <20070712234553.GR3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712234553.GR3492@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13 2007, Adrian Bunk wrote:
> This patch removes some code that became dead code after the ATARI_ACSI 
> removal.
> 
> It also indirectly fixes the following bug introduced by
> commit c2bcf3b8978c291e1b7f6499475c8403a259d4d6:
> 
>  config ATARI_SLM
>         tristate "Atari SLM laser printer support"
> -       depends on ATARI && ATARI_ACSI!=n
> +       depends on ATARI
> 
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Thanks Adrian, applied!

-- 
Jens Axboe

