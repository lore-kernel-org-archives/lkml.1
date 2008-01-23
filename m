Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYAWPPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYAWPPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 10:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYAWPPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 10:15:33 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60694 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751686AbYAWPPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 10:15:32 -0500
Date: Wed, 23 Jan 2008 16:14:25 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Remy Bohmer <linux@bohmer.net>, Chip Coldwell <coldwell@redhat.com>
Subject: Re: [PATCH 6/6] atmel_serial: Add DMA support
Message-ID: <20080123161425.203a0159@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080123150436.75fe469c@lxorguk.ukuu.org.uk>
References: <1201013444-30370-1-git-send-email-hskinnemoen@atmel.com>
	<200801231418.38997.marc.pignat@hevs.ch>
	<20080123143503.764bc8cf@dhcp-252-066.norway.atmel.com>
	<200801231452.55388.marc.pignat@hevs.ch>
	<20080123150511.3785986c@dhcp-252-066.norway.atmel.com>
	<20080123150436.75fe469c@lxorguk.ukuu.org.uk>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008 15:04:36 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > No, I think GFP_DMA is for legacy ISA DMA and other DMA controllers
> > with addressing limitations. The PDC is capable of accessing the full
> > 32-bit physical address space on both AT91 and AVR32, so no special DMA
> > flags are needed.
> 
> For kernel coherent DMA buffers use the dma_ API to allocate the memory.

Yes, but since we're managing DMA coherency using the streaming DMA
API, we don't really need coherent buffers, right?

Haavard
