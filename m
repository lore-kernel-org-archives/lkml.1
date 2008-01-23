Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYAWQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYAWQqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYAWQqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:46:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41918 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbYAWQqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:46:04 -0500
Date: Wed, 23 Jan 2008 16:41:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Remy Bohmer <linux@bohmer.net>, Chip Coldwell <coldwell@redhat.com>
Subject: Re: [PATCH 6/6] atmel_serial: Add DMA support
Message-ID: <20080123164150.4b162826@lxorguk.ukuu.org.uk>
In-Reply-To: <20080123161425.203a0159@dhcp-252-066.norway.atmel.com>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com>
	<200801231418.38997.marc.pignat@hevs.ch>
	<20080123143503.764bc8cf@dhcp-252-066.norway.atmel.com>
	<200801231452.55388.marc.pignat@hevs.ch>
	<20080123150511.3785986c@dhcp-252-066.norway.atmel.com>
	<20080123150436.75fe469c@lxorguk.ukuu.org.uk>
	<20080123161425.203a0159@dhcp-252-066.norway.atmel.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008 16:14:25 +0100
Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:

> On Wed, 23 Jan 2008 15:04:36 +0000
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > No, I think GFP_DMA is for legacy ISA DMA and other DMA controllers
> > > with addressing limitations. The PDC is capable of accessing the full
> > > 32-bit physical address space on both AT91 and AVR32, so no special DMA
> > > flags are needed.
> > 
> > For kernel coherent DMA buffers use the dma_ API to allocate the memory.
> 
> Yes, but since we're managing DMA coherency using the streaming DMA
> API, we don't really need coherent buffers, right?

Right.

Alan
