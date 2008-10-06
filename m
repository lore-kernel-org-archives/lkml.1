Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbYJFOBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbYJFOBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 10:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYJFOBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 10:01:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46441 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751939AbYJFOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 10:01:30 -0400
Date: Mon, 6 Oct 2008 15:01:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081006150122.3860cae1@lxorguk.ukuu.org.uk>
In-Reply-To: <20081006065213.76dc729a@infradead.org>
References: <20081005180154.7cc12486@infradead.org>
	<20081006102739.16d1a434@lxorguk.ukuu.org.uk>
	<48EA1540.8060409@gmail.com>
	<20081006144835.6e58f73a@lxorguk.ukuu.org.uk>
	<20081006065213.76dc729a@infradead.org>
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

> > Only a tiny fraction of devices in the world are PCI, and those
> > platforms where you most what /dev/mem type debugging tools are often
> > those without PCI
> 
> if you looked at the patch it's x86 only, and only active if you set
> CONFIG_STRICT_DEVMEM.
> (if you don't select CONFIG_STRICT_DEVMEM, which is off by default, you
> get unlimited access as usualy)

Lots of non PCI devices on x86 systems as well.

And the video problem is a big one for the x86 case as the VGA ISA window
is used by both the kernel and X without a helper driver.

Alan
