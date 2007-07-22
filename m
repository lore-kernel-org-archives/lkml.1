Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbXGVOq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbXGVOq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbXGVOqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:46:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33101 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020AbXGVOqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:46:19 -0400
Date: Sun, 22 Jul 2007 15:53:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "treul" <lgijnpuhx@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: dma hardware underrun
Message-ID: <20070722155310.47f98ca4@the-village.bc.nu>
In-Reply-To: <f7vnsh$aun$1@sea.gmane.org>
References: <f7vnsh$aun$1@sea.gmane.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> My debugging result shows the underrun goes away if I put 2 printf's in the 
> harddisk ISR. The printf is at milli-seconds whereas the duration of the 
> original ISR is at lower magnitude. In addition, I find a SATA-PCI harddisk 
> does not have the underrun problem. IDE-PCI device gets the trouble.

Is the SATA controller on the motherboard and the PATA one on the PCI
bus ?

> So, do you have any idea about where the root cause can be hiding? Or what 
> do you think of adding printf's in ISR? (performance? incurring other 
> problems by disabling interrupt too long?

On a standard PCI bus an IDE DMA disk can saturate the bus. That may be
your underlying problem ?
