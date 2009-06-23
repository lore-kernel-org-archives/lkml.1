Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZFWCjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZFWCjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZFWCjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:39:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:46146 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbZFWCjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:39:07 -0400
Date: Tue, 23 Jun 2009 11:37:48 +0900
To: vapier.adi@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 2/2] Blackfin: fix dma-mapping build errors
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <8bd0f97a0906221929y51af5000w63e2edb7e54abe74@mail.gmail.com>
References: <1245722086-13340-2-git-send-email-vapier@gentoo.org>
	<20090623111430D.fujita.tomonori@lab.ntt.co.jp>
	<8bd0f97a0906221929y51af5000w63e2edb7e54abe74@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090623113616B.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 23 Jun 2009 11:37:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009 22:29:29 -0400
Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Mon, Jun 22, 2009 at 22:14, FUJITA Tomonori wrote:
> > On Mon, 22 Jun 2009 21:54:46 -0400 Mike Frysinger wrote:
> >> The recent deprecation of dma_sync_{sg,single} ironically broke Blackfin
> >> systems.
> >
> > Oops, sorry about that.
> >
> >> This is because we don't define dma_sync_sg_for_cpu at all, so
> >> until the DMA asm-generic conversion/cleanup is done after the next
> >> release, simply redirect the dma_sync_sg_for_cpu to the debug version.
> >
> > This doesn't look correct (though it works). dma-debug.h is supposed
> > to be used by architectures that support DMA_API_DEBUG feature
> > (blackfin doesn't support it). dma_sync_sg_for_cpu is not the
> > debug version of dma_sync_sg_for_cpu.
> 
> guessing you meant "debug_dma_sync_sg_for_cpu is not the debug version
> of dma_sync_sg_for_cpu"

Sorry, yeah, your guess is correct.
