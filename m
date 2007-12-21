Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbXLUQgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbXLUQgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXLUQgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:36:05 -0500
Received: from elvis.franken.de ([193.175.24.41]:35316 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbXLUQgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:36:04 -0500
Date: Fri, 21 Dec 2007 17:35:50 +0100
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rdreier@cisco.com, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk,
       davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer in scsi_cmnd
Message-ID: <20071221163550.GA14740@alpha.franken.de>
References: <20071221023011.4C4BADDDFA@ozlabs.org> <20071221103326.7ce1bc4f@the-village.bc.nu> <20071221131640.GN29690@parisc-linux.org> <20071221133027.GA11495@alpha.franken.de> <20071221140024.GO29690@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221140024.GO29690@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 07:00:25AM -0700, Matthew Wilcox wrote:
> On Fri, Dec 21, 2007 at 02:30:28PM +0100, Thomas Bogendoerfer wrote:
> > there are SCSI host drivers, which also DMA to the sense buffer like
> > sgiwd93.c for example.
> 
> Yes ... and there are others which don't, for example qla2xxx and
> sym53c8xx.

well I don't care which way to go. I'd prefer a pointer to an
allocated sense buffer, but maybe that's just me.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
