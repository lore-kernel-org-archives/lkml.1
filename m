Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbYJFNw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbYJFNw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 09:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYJFNwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 09:52:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:47271 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbYJFNwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 09:52:19 -0400
Date: Mon, 6 Oct 2008 06:52:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081006065213.76dc729a@infradead.org>
In-Reply-To: <20081006144835.6e58f73a@lxorguk.ukuu.org.uk>
References: <20081005180154.7cc12486@infradead.org>
	<20081006102739.16d1a434@lxorguk.ukuu.org.uk>
	<48EA1540.8060409@gmail.com>
	<20081006144835.6e58f73a@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008 14:48:35 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I think the proper solution is to make /dev/mem pure diagnostic
> > tool. Drivers should use /sys mappings of pci devices to access
> > their iomem
> 
> Only a tiny fraction of devices in the world are PCI, and those
> platforms where you most what /dev/mem type debugging tools are often
> those without PCI

if you looked at the patch it's x86 only, and only active if you set
CONFIG_STRICT_DEVMEM.
(if you don't select CONFIG_STRICT_DEVMEM, which is off by default, you
get unlimited access as usualy)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
