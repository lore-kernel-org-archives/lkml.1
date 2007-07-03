Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbXGCPDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbXGCPDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760512AbXGCPCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:02:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49738 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760492AbXGCPCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:02:41 -0400
Subject: Re: How to handle patches that cross maintainers?
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <4BEFAFC6-3346-4F29-B1C5-377952E3FBBF@kernel.crashing.org>
References: <4BEFAFC6-3346-4F29-B1C5-377952E3FBBF@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Jul 2007 12:01:50 -0300
Message-Id: <1183474910.3926.134.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Ter, 2007-07-03 às 04:01 -0500, Kumar Gala escreveu:
> Andrew,
> 
> I was hoping to get your input on how to handle patches that cross  
> maintainers.  I've got a patch that is pretty PPC specific, but  
> happens to touch some drivers as well.
> 
> Here's the diffstat to get a rough idea:
> 
> arch/powerpc/kernel/io.c                |   12 ++++++------
> arch/powerpc/mm/hash_native_64.c        |    2 +-
> arch/powerpc/mm/stab.c                  |    4 ++--
> drivers/ide/pci/scc_pata.c              |    4 ++--
> drivers/media/dvb/bt8xx/bt878.h         |    5 ++---
> drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
> include/asm-powerpc/system.h            |    2 +-
> 7 files changed, 15 insertions(+), 16 deletions(-)
> 
> Now, I've had this issue before w/o any good sense on how to handle it.

The better is to copy all of us and wait for some time to allow each
maintainer to ack or comment the changeset, if needed.

Please c/c me for any changes on /drivers/media stuff.

Cheers,
Mauro

