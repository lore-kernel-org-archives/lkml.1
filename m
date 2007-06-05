Return-Path: <linux-kernel-owner+w=401wt.eu-S1764260AbXFEK3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764260AbXFEK3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763911AbXFEK3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:29:09 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:13707 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763891AbXFEK3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:29:08 -0400
Date: Tue, 5 Jun 2007 13:29:05 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] stop x86 ->sysdata abuse; introduce pci_sysdata
Message-ID: <20070605102905.GA3305@rhun.haifa.ibm.com>
References: <11798211643534-git-send-email-muli@il.ibm.com> <11798211643659-git-send-email-muli@il.ibm.com> <11798211643144-git-send-email-muli@il.ibm.com> <11798211663773-git-send-email-muli@il.ibm.com> <1179821166685-git-send-email-muli@il.ibm.com> <11798211661041-git-send-email-muli@il.ibm.com> <20070604113344.0e71ca8c.akpm@linux-foundation.org> <20070604190654.GA20299@havoc.gtf.org> <20070604191346.GL4556@rhun.ibm.com> <20070604210551.GH20299@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604210551.GH20299@havoc.gtf.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 05:05:51PM -0400, Jeff Garzik wrote:
> 
> This patch introduces struct pci_sysdata to x86 and x86-64, and
> converts the existing two users (NUMA, Calgary) to use it.
> 
> This eliminates the conflict between NUMA and Calgary using the same
> pointer for different uses, and lays the groundwork for adding x86
> PCI domain support.

Thanks for the patch. I am testing with Calgary and will push upstream
through the next batch of Calgary updates when it will be ready. At
the moment it doesn't boot on one of my test machines, I'm looking
into it.

Also, FWIW, we don't use the same pointer for different uses (that
wouldn't have worked, obviously) but I've never been 100% comfortable
with the hack we use and this is obviously the right thing to do.

Cheers,
Muli
