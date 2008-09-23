Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYIWRnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYIWRnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYIWRnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:43:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60676 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751630AbYIWRnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:43:24 -0400
Date: Tue, 23 Sep 2008 18:43:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: Export the ROM enable/disable helpers and use them
 in mtd
Message-ID: <20080923184315.13f0923f@lxorguk.ukuu.org.uk>
In-Reply-To: <20080923164338.GA12167@shareable.org>
References: <20080923172510.37419440@lxorguk.ukuu.org.uk>
	<20080923164338.GA12167@shareable.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 17:43:38 +0100
Jamie Lokier <jamie@shareable.org> wrote:

> Alan Cox wrote:
> >  EXPORT_SYMBOL(pci_map_rom);
> >  EXPORT_SYMBOL(pci_unmap_rom);
> > +EXPORT_SYMBOL_GPL(pci_enable_rom);
> > +EXPORT_SYMBOL_GPL(pci_disable_rom);
> 
> It doesn't _sound_ like the sort of thing tied into the kernel enough
> to deserve an EXPORT_SYMBOL_*GPL*.  Any particularly reason?

It's not my code so I can't change the licensing on it. If the original
author of that code has no objection I would also think the _GPL version
isn't needed.

Alan
