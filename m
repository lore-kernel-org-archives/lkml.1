Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbXJYBld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbXJYBld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbXJYBlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:41:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52155 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752729AbXJYBlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:41:24 -0400
Date: Thu, 25 Oct 2007 02:44:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.24-rc1] resource_len() utility function
Message-ID: <20071025024405.3e960e9c@the-village.bc.nu>
In-Reply-To: <200710241820.52376.david-b@pacbell.net>
References: <200710241820.52376.david-b@pacbell.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 18:20:52 -0700
David Brownell <david-b@pacbell.net> wrote:

> Add a new resource_len() function, so drivers can start using this
> instead of driver-private code for a common idiom.  The call can be
> useful with at least:
> 
>  - request_region(), release_region()
>  - request_mem_region(), release_mem_region()
>  - ioremap()
> 
> Candidate drivers include those using platform or PNP busses, and
> maybe some others.  PCI already has a similar function.
> 
> This patch also updates a representative set of drivers in two
> subsystems to use this call (SPI, and USB peripheral/gadget).

PCI also increasingly is using functions that allow the user to choose to
map a resource as a resource (eg pci_iomap). So is it better to have
functions request_mem_resource(res)  free_mem_resource(res) and similar
instead or as well ?


