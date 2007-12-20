Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXLTRqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXLTRqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXLTRp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:45:58 -0500
Received: from waste.org ([66.93.16.53]:39703 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbXLTRp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:45:57 -0500
Date: Thu, 20 Dec 2007 11:45:40 -0600
From: Matt Mackall <mpm@selenic.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, m.kozlowski@tuxland.pl,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Message-ID: <20071220174540.GW19691@waste.org>
References: <20071216.202611.226170474.davem@davemloft.net> <20071216223917.873e34bf.akpm@linux-foundation.org> <20071217145554.GD19691@waste.org> <20071220.045359.107684960.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220.045359.107684960.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 04:53:59AM -0800, David Miller wrote:
> From: Matt Mackall <mpm@selenic.com>
> Date: Mon, 17 Dec 2007 08:55:54 -0600
> 
> > On Sun, Dec 16, 2007 at 10:39:17PM -0800, Andrew Morton wrote:
> > Actually, you may only need these two:
> > 
> > > maps4-add-proc-kpagecount-interface.patch
> > > maps4-add-proc-kpageflags-interface.patch
> 
> Yes these two were enough, and exporting fs/proc/base.c's
> mem_lseek().
> 
> As hard as I try, I can't reproduce this at all.  I tried
> both on my workstation and my niagara boxes.

That's good to know, I was having a very hard time imagining how the
kpagecount code could be going south.
 
> It must be other needle in the 30MB+ -mm haystack. :-(

Have we seen a config for the broken machine? Perhaps that'll help us
make a guess..

-- 
Mathematics is the supreme nostalgia of our time.
