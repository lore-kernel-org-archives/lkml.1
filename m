Return-Path: <linux-kernel-owner+w=401wt.eu-S1763455AbYDVSMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763455AbYDVSMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbYDVSMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:12:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:35173 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753360AbYDVSM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:12:29 -0400
Subject: Re: [PATCH] add vmstat_text for NR_WRITEBACK_TEMP
From: Miklos Szeredi <mszeredi@suse.cz>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1208887130.5534.97.camel@localhost>
References: <1208887130.5534.97.camel@localhost>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 20:12:27 +0200
Message-Id: <1208887947.3828.29.camel@tucsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-22 at 13:58 -0400, Lee Schermerhorn wrote:
> PATCH - add vmstat_test for NR_WRITEBACK_TEMP
> 
> Against:  2.6.25-rc8-mm2 [maybe also missing in '.25-mm1]
> 
> /proc/vmstat items after "nr_vmscan_write" are off-by-one
> because of missing test for NR_WRITEBACK_TEMP that was added
> to mmzone.h.  
> 
> Apparently from:
> 
> 	mm-add-nr_writeback_temp-counter.patch
> 
> in -mm tree.
> 
> Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

Acked-by: Miklos Szeredi <mszeredi@suse.cz>

Thanks,
Miklos

> 
>  mm/vmstat.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.25-rc8-mm2/mm/vmstat.c
> ===================================================================
> --- linux-2.6.25-rc8-mm2.orig/mm/vmstat.c	2008-04-15 12:07:18.000000000 -0400
> +++ linux-2.6.25-rc8-mm2/mm/vmstat.c	2008-04-15 12:11:48.000000000 -0400
> @@ -699,6 +699,7 @@ static const char * const vmstat_text[] 
>  	"nr_unstable",
>  	"nr_bounce",
>  	"nr_vmscan_write",
> +	"nr_writeback_temp",
>  
>  #ifdef CONFIG_NUMA
>  	"numa_hit",
> 
> 

