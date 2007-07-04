Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbXGDNMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbXGDNMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbXGDNMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:12:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46207 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758322AbXGDNMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:12:13 -0400
Date: Wed, 4 Jul 2007 14:18:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: Libata PATA status
Message-ID: <20070704141819.01a357fa@the-village.bc.nu>
In-Reply-To: <20070704130258.GA10904@one.firstfloor.org>
References: <20070703185116.59c8f5f5@the-village.bc.nu>
	<p73k5tg2uj9.fsf@bingen.suse.de>
	<20070704131746.4bbe4d0e@the-village.bc.nu>
	<20070704130258.GA10904@one.firstfloor.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > disabled without risking breaking old root file systems.
> > 
> > That would be udevd for new systems or "ln -s" for old ones ? 
> 
> Then old kernels couldn't be booted anymore.

Why not. I boot back and forth randomly between old and new IDE kernels
without problems. The root fs loaded is set in kernel or grub (or on most
distros nowdays by label scanning from initrd) so just works. Then mount
label or uuid based mounting does the rest.

> Sure for SATA. But surely for PATA it would be possible to fake
> the mapping of the old driver? Doing it simple minded (e.g. only
> for the builtin devices) would be probably sufficient.

You could probably reliably map "hda/b/c/d" initially with some kind of
forwarder providing nobody hot plugged them.  Just not sure I see the
point of doing it kernel side.

Alan
