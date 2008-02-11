Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYBKQmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYBKQmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbYBKQmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:42:17 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52722 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYBKQmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:42:16 -0500
Date: Mon, 11 Feb 2008 09:42:15 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: kyle@parisc-linux.org, grundler@parisc-linux.org,
       linux-parisc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH?][arch/parisc/kernel/pci-dma.c] pcxl_dma_ops.alloc_noncoherent = pa11_dma_alloc_consistent?
Message-ID: <20080211164215.GM5299@parisc-linux.org>
References: <47B07685.5000606@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B07685.5000606@tiscali.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 05:23:33PM +0100, Roel Kluin wrote:
> duplicate pa11_dma_alloc_consistent; more appropriate appears
> pa11_dma_alloc_noncoherent here. 
> 
> Not tested, please confirm that this fix is correct

I don't think it is.  The memories are fading, so I don't recall why it
is we do it this way, but I'm pretty sure it's correct the way it is.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
