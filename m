Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYG1Jyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYG1Jyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 05:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbYG1Jya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 05:54:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYG1Jy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 05:54:29 -0400
Date: Mon, 28 Jul 2008 11:54:12 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Vrabel <david.vrabel@csr.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080728115412.75397898@brian.englab.brq.redhat.com>
In-Reply-To: <20080725155146.GB17093@parisc-linux.org>
References: <4860D09D.4060801@csr.com>
	<48807166.9010006@csr.com>
	<20080722155629.1160635e@brian.englab.brq.redhat.com>
	<200807221052.26879.jbarnes@virtuousgeek.org>
	<20080725152918.43bf3100@brian.englab.brq.redhat.com>
	<20080725134252.GG6701@parisc-linux.org>
	<20080725155329.79821436@brian.englab.brq.redhat.com>
	<20080725155146.GB17093@parisc-linux.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 09:51:46 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Fri, Jul 25, 2008 at 03:53:29PM +0200, Michal Schmidt wrote:
> > Maybe we should just not use MSI for devices without maskbits.
> 
> That seems excessive.  I wouldn't object to forbidding CPU affinity
> changes for devices:
> 
>  - Without maskbits
>  - With the intx quirk
> 
> I'd want to look into it in a bit more detail .... perhaps we could
> allow irq affinity if we don't have to change the address, only the
> data.

At least on x86, the destination processor is encoded in the message
address (see Intel Architecture Software Developer's Manual Vol. 3A,
9.11.1), so it won't help.

Michal

