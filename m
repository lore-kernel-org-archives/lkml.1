Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbYBKQqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbYBKQqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbYBKQp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:45:58 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46355 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757340AbYBKQp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:45:57 -0500
Subject: Re: [PATCH?][arch/parisc/kernel/pci-dma.c]
	pcxl_dma_ops.alloc_noncoherent = pa11_dma_alloc_consistent?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: kyle@parisc-linux.org, Matthew Wilcox <matthew@wil.cx>,
       grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47B07685.5000606@tiscali.nl>
References: <47B07685.5000606@tiscali.nl>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 10:45:49 -0600
Message-Id: <1202748349.3122.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 17:23 +0100, Roel Kluin wrote:
> duplicate pa11_dma_alloc_consistent; more appropriate appears
> pa11_dma_alloc_noncoherent here. 
> 
> Not tested, please confirm that this fix is correct

No, it looks completely incorrect to me.  What makes you think a pcxl
box has a problem with coherency?

James


