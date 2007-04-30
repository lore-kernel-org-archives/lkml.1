Return-Path: <linux-kernel-owner+w=401wt.eu-S1423333AbXD3OwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423333AbXD3OwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423334AbXD3OwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:52:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49703 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423333AbXD3OwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:52:14 -0400
Date: Mon, 30 Apr 2007 15:55:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modules
 too
Message-ID: <20070430155548.381d1bad@the-village.bc.nu>
In-Reply-To: <20070430105009.GB14944@infradead.org>
References: <200704301227.598020000@suse.de>
	<20070430102814.7E56E151D2@wotan.suse.de>
	<20070430105009.GB14944@infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 11:50:09 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Apr 30, 2007 at 12:28:14PM +0200, Andi Kleen wrote:
> > 
> > Otherwise non GPL modules cannot even do basic operations
> > like disabling interrupts anymore, which would be excessive.
> > 
> > Longer term should split the single structure up into
> > internal and external symbols and not export the internal
> > ones at all.
> > 
> > Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Ingo was dead-set against this and I kinda agree. 

Ditto - do the work first then merge it.

NAK the patch
