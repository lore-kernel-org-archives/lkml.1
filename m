Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYJFNs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYJFNs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 09:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYJFNss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 09:48:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45016 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbYJFNss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 09:48:48 -0400
Date: Mon, 6 Oct 2008 14:48:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: RFC: banning device driver reserved resources from /dev/mem
Message-ID: <20081006144835.6e58f73a@lxorguk.ukuu.org.uk>
In-Reply-To: <48EA1540.8060409@gmail.com>
References: <20081005180154.7cc12486@infradead.org>
	<20081006102739.16d1a434@lxorguk.ukuu.org.uk>
	<48EA1540.8060409@gmail.com>
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

> I think the proper solution is to make /dev/mem pure diagnostic tool.
> Drivers should use /sys mappings of pci devices to access their iomem

Only a tiny fraction of devices in the world are PCI, and those platforms
where you most what /dev/mem type debugging tools are often those without
PCI

> , or even better they should not touch pci mappings
> directly at all, but talk to kernel, and if xorg needs access 
> to video memory it should talk to drm and get its mapping from there.

Most video cards don't use DRM, but the kernel does have the same video
memory mapped for text consoles.

Alan
