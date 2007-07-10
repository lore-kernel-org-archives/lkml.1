Return-Path: <linux-kernel-owner+w=401wt.eu-S1760226AbXGJMrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbXGJMrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbXGJMoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:44:44 -0400
Received: from waste.org ([66.93.16.53]:46745 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057AbXGJMoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:44:23 -0400
Date: Tue, 10 Jul 2007 07:43:44 -0500
From: Matt Mackall <mpm@selenic.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Some love to default profiler
Message-ID: <20070710124343.GS11166@waste.org>
References: <20070704213420.GA5864@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704213420.GA5864@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 01:34:20AM +0400, Alexey Dobriyan wrote:
> 1) Drop __KERNEL__ out of profile.h. It contains only internal kernel stuff and
>    not in exported headers list
> 2) Put profile.c under CONFIG_PROFILING. You enabled profiling in config, you
>    will get it. Removes conditional branch from schedule(). Code savings on my
>    usual config:
> 
> 	   text	   data	    bss	    dec	    hex	filename
> 	2921871	 179895	 180224	3281990	 321446	vmlinux		before
> 	2920141	 179847	 180224	3280212	 320d54	vmlinux		after
> 	--------------------------------------------------------------
> 	  -1730     -48           -1778
> 
> 3) Make timer_hook static (hi, Adrian!)
> 4) Convert do {} while (0) into static inline functions
> 5) minor misc stuff

Something here suggests this should have been 5 patches.

Otherwise, looks good to me.

-- 
Mathematics is the supreme nostalgia of our time.
