Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbXD0M1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbXD0M1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755AbXD0M1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:27:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38951 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755743AbXD0M1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:27:24 -0400
Message-ID: <4631EC0F.7090605@pobox.com>
Date: Fri, 27 Apr 2007 08:26:55 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Peter Williams <pwil3058@bigpond.net.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux-2.6.21 hangs during post boot initialization phase
References: <463166C2.6060106@bigpond.net.au> <alpine.LFD.0.98.0704262035410.9964@woody.linux-foundation.org> <46319297.905@bigpond.net.au> <20070427122247.GA19017@hmsreliant.homelinux.net>
In-Reply-To: <20070427122247.GA19017@hmsreliant.homelinux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.7 (---)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-3.7 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> This was reported to me last night, and I've posted a patch to fix it, its
> available here:
> http://marc.info/?l=linux-netdev&m=117761259222165&w=2
> 
> It applies on top of the previous patch, and should fix your problem.
> 
> Here's a copy of the patch
> 
> Thanks & Regards
> Neil
> 
> 
> diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
> index a6a0f09..7e44939 100644
> --- a/drivers/net/sis900.c
> +++ b/drivers/net/sis900.c


Thanks Neil.  I will send upstream and to stable@kernel.org as soon as 
Peter gets back with a positive test result.

	Jeff


