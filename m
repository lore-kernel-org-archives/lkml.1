Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbXD0MxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbXD0MxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbXD0MxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:53:24 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3578 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755781AbXD0MxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:53:23 -0400
Date: Fri, 27 Apr 2007 08:52:32 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux-2.6.21 hangs during post boot initialization phase
Message-ID: <20070427125232.GB19017@hmsreliant.homelinux.net>
References: <463166C2.6060106@bigpond.net.au> <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org> <46319297.905@bigpond.net.au> <20070427122247.GA19017@hmsreliant.homelinux.net> <4631EC0F.7090605@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4631EC0F.7090605@pobox.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 08:26:55AM -0400, Jeff Garzik wrote:
> Neil Horman wrote:
> >This was reported to me last night, and I've posted a patch to fix it, its
> >available here:
> >http://marc.info/?l=linux-netdev&m=117761259222165&w=2
> >
> >It applies on top of the previous patch, and should fix your problem.
> >
> >Here's a copy of the patch
> >
> >Thanks & Regards
> >Neil
> >
> >
> >diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
> >index a6a0f09..7e44939 100644
> >--- a/drivers/net/sis900.c
> >+++ b/drivers/net/sis900.c
> 
> 
> Thanks Neil.  I will send upstream and to stable@kernel.org as soon as 
> Peter gets back with a positive test result.
> 
> 	Jeff
> 

Thanks Jeff, all.  Sorry for the trouble. I've had the person who reported it to
me test this out last night as well. He cam back with positive results.  He had
complained of some other timeouts, but as he described them, I belive they were
unrelated to this patch.

Thanks & Regards
Neil

