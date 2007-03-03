Return-Path: <linux-kernel-owner+w=401wt.eu-S2992878AbXCCB3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992878AbXCCB3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992885AbXCCB3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:29:49 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55707 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992878AbXCCB3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:29:47 -0500
Message-ID: <45E8CF86.30102@garzik.org>
Date: Fri, 02 Mar 2007 20:29:42 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: chris.leech@gmail.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] I/OAT fixes
References: <41b516cb0703021723s40ca2f4es6d200f7ced7aaffd@mail.gmail.com>
In-Reply-To: <41b516cb0703021723s40ca2f4es6d200f7ced7aaffd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Leech wrote:
> Please pull from git://lost.foo-projects.org/~cleech/linux-2.6#master
> 
> A few drivers/dma and related I/OAT fixes, and missing documentation.
> These have been posted for review and sitting in MM for a while now.
> 
> - Chris
> 
> Andrew Morton (1):
>      I/OAT: warning fix
> 
> Chris Leech (6):
>      ioatdma: Push pending transactions to hardware more frequently
>      ioatdma: Remove the wrappers around read(bwl)/write(bwl) in ioatdma
>      ioatdma: Remove the use of writeq from the ioatdma driver
>      I/OAT: Add documentation for the tcp_dma_copybreak sysctl
>      I/OAT: Add entries to MAINTAINERS for the DMA memcpy subsystem and 
> ioatdma
>      I/OAT: Only offload copies for TCP when there will be a context switch
> 
> Dan Aloni (1):
>      I/OAT: fix I/OAT for kexec
> 
> Jeff Garzik (1):
>      drivers/dma: handle sysfs errors
> 
>  Documentation/networking/ip-sysctl.txt |    6 +
> MAINTAINERS                            |   12 +++
>  drivers/dma/dmaengine.c                |   22 +++++-
>  drivers/dma/ioatdma.c                  |   81 ++++++++++++----------
>  drivers/dma/ioatdma_io.h               |  118
> ---------------------------------
>  net/ipv4/tcp.c                         |   26 +++++--
> 6 files changed, 100 insertions(+), 165 deletions(-)

Where is the patch for review?

	Jeff



