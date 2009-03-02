Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZCBVCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZCBVCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZCBVCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:02:11 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:34008 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZCBVCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:02:10 -0500
Date: Mon, 2 Mar 2009 14:01:52 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/6] Rewrite MSI-HOWTO
Message-ID: <20090302210152.GA725@parisc-linux.org>
References: <1235410082-5016-1-git-send-email-matthew@wil.cx> <1235410082-5016-2-git-send-email-matthew@wil.cx> <20090227061525.GA9883@colo.lackof.org> <20090227121443.GL16891@parisc-linux.org> <20090302203340.GA9302@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302203340.GA9302@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 01:33:40PM -0700, Grant Grundler wrote:
> AFAICT "round-robin" was a behavior of older kernels.
> All the x86 platforms I've looked at direct the MSI to exactly
> one CPU.

I think it's a factor of your chipset.  For example, my laptop:

$ grep MSI /proc/interrupts 
 26:      33095      33046   PCI-MSI-edge      eth0
 27:     127014     126190   PCI-MSI-edge      ahci
 28:          0          0   PCI-MSI-edge      ahci
 29:          0          0   PCI-MSI-edge      ahci
 31:     525988     518310   PCI-MSI-edge      iwlagn

I know my G33-based desktop also distributes interrupts equally across
all four cores.  It is, of course, possibly to manually set the
affinity, and perhaps that's what you're seeing.

> > Did you see this is patch 1/6?  ;-)
> 
> yes....after I hit send and continued reviewing the rest of the patches. ;)

It's good to know somebody looked at patches 2-6 because I've not had
any comments yet.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
