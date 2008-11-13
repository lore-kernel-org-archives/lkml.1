Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbYKMJ7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbYKMJ7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYKMJ7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:59:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36012 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750824AbYKMJ73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:59:29 -0500
Date: Thu, 13 Nov 2008 09:59:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrey Panin <pazke@donpac.ru>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] 8250: Oxford Semiconductor Devices
Message-ID: <20081113095925.4a3fea5d@lxorguk.ukuu.org.uk>
In-Reply-To: <20081113070756.GA30213@ports.donpac.ru>
References: <20081017192309.9308.74370.stgit@localhost.localdomain>
	<20081017192830.9308.94462.stgit@localhost.localdomain>
	<20081113070756.GA30213@ports.donpac.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +		number_uarts = ioread8(p + 4);
> > +		board->num_ports = number_uarts;
> 
> Why not just return number of ports here ?

That would leak mappings
> 
> > +		printk(KERN_DEBUG
> > +			"%d ports detected on Oxford PCI Express device\n",
> > +								number_uarts);
> 
> Is this printk really necessary ?

For the moment yes.

> WTF is this ? Why existing pci_serial_quirks[] infrastructure cannot be used here ?

Russell already fixed that and the change went upstream.

