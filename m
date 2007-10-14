Return-Path: <linux-kernel-owner+w=401wt.eu-S1763938AbXJNVPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763938AbXJNVPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 17:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759697AbXJNVPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 17:15:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:40299 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759534AbXJNVPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 17:15:11 -0400
Subject: Re: [git patches] IDE updates (part 2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200710141807.24295.bzolnier@gmail.com>
References: <200710131825.24768.bzolnier@gmail.com>
	 <200710140041.25152.bzolnier@gmail.com> <1192320489.22054.40.camel@pasglop>
	 <200710141807.24295.bzolnier@gmail.com>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 07:15:00 +1000
Message-Id: <1192396500.6188.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> How's about this patch?
> 
> [PATCH] ide-pmac: fix pmac_ide_init_hwif_ports()
> 
> * pmac_ide_init_hwif_ports() can be called by ide_init_hwif_ports()
>   (through ppc_ide_md.ide_init_hwif hook) for non IDE PMAC interfaces.
>   If this is the case the hw->io_ports[] should be already setup by
>   ide_init_hwif_ports()->ide_std_init_ports() so remove redundant code
>   from pmac_ide_init_hwif_ports().
> 
>   As side-effect this change fixes ctl_addr == 0 special handling in
>   ide_init_hwif_ports().
> 
> * Fix misleading comment while at it.

I would have to try it. Problem is, I don't actually have any powermac
with a PCI IDE controller at hand.. ouch. I'll see what I can find.

Ben.


