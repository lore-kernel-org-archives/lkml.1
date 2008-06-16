Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYFPWla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYFPWla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 18:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYFPWlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 18:41:21 -0400
Received: from colo.lackof.org ([198.49.126.79]:55453 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbYFPWlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:41:20 -0400
Date: Mon, 16 Jun 2008 16:41:07 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: kyle@mcmartin.ca, matthew@wil.cx, grundler@parisc-linux.org,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: parisc: pcibios_init_bus() isn't called
Message-ID: <20080616224107.GA32030@colo.lackof.org>
References: <20080615161327.GC7865@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080615161327.GC7865@cs181133002.pp.htv.fi>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 07:13:27PM +0300, Adrian Bunk wrote:
> arch/parisc/kernel/pci.c:pcibios_init_bus() never gets called - this
> doesn't seem to be intentionally?

I think this is accidentally abandoned code and introduced here:
    http://lkml.org/lkml/2001/12/22/43

So it was called from pci_do_scan_bus(). Can you track down when this
was removed from pci_do_scan_bus() ?

But it was once used by parisc port:
    http://lists.parisc-linux.org/pipermail/parisc-linux/2001-June/037259.html

and then perhaps got removed soon after in the generic code:
    http://www.cs.helsinki.fi/linux/linux-kernel/2003-01/0388.html

But I'm not finding the exact patch that removed it.

thanks,
grant
