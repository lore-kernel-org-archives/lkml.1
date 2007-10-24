Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbXJXGqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbXJXGqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbXJXGqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:46:20 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14463 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257AbXJXGqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:46:19 -0400
Date: Wed, 24 Oct 2007 08:46:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Schmitt <schmichr@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] sg: add missing sg_init_table calls to zfcp
Message-ID: <20071024064616.GT14671@kernel.dk>
References: <20071024052900.GB12335@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024052900.GB12335@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> CONFIG_DEBUG_SG reveals two missing sg_init_table calls. Add them.
> 
> kernel BUG at include/linux/scatterlist.h:50!
> illegal operation: 0001 [#1]
> [...]
> Call Trace:
> ([<000000000026f184>] zfcp_ns_gid_pn_request+0x4c/0x2a0)
>  [<0000000000276dd4>] zfcp_erp_strategy_do_action+0x1410/0x1938
>  [<0000000000278412>] zfcp_erp_thread+0x4fa/0x1430
>  [<000000000001990a>] kernel_thread_starter+0x6/0xc
>  [<0000000000019904>] kernel_thread_starter+0x0/0xc
> 
> Cc: Swen Schillig <swen@vnet.ibm.com>
> Cc: Christof Schmitt <christof.schmitt@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
> Jens, could you please push this one via your tree? Thanks!

You bet, thanks!

-- 
Jens Axboe

