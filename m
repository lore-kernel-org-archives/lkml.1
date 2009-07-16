Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbZGPKkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbZGPKkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZGPKkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:40:11 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54680 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960AbZGPKkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:40:10 -0400
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dirk Behme <dirk.behme@googlemail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sudeep K N <sudeepholla.maillist@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A5B5640.2050308@googlemail.com>
References: <20090622164604.GG29188@n2100.arm.linux.org.uk>
	 <1245767657.16488.38.camel@pc1117.cambridge.arm.com>
	 <4A5B5640.2050308@googlemail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 16 Jul 2009 11:39:58 +0100
Message-Id: <1247740798.26074.29.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 10:39:59.0788 (UTC) FILETIME=[C4ACE6C0:01CA0601]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-13 at 17:44 +0200, Dirk Behme wrote:
> Catalin Marinas wrote:
> > The patch below appears to solve the problem with CompactFlash using
> > pata_platform (I cc'ed linux-ide since the patch changes their code).
> > The patch only handles the read case but similarly it may need to handle
> > the write case if D-cache aliasing between user and kernel mappings
> > exists.
> > 
> > For the USB mass storage, I haven't yet figured out the best place to
> > call flush_dcache_page().
> 
> Any news regarding USB mass storage on ARM MPCore? Else this would 
> mean that USB mass storage (USB stick, USB disk) formatted with 
> ext2/3/4 wouldn't work with MPCore?

On the ARM RealView boards, the USB is PIO rather than DMA-capable. I
posted this patch on the list here (but have to follow up with the
maintainers):

http://lists.arm.linux.org.uk/lurker/message/20090710.130032.bfb8b218.en.html

-- 
Catalin

