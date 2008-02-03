Return-Path: <linux-kernel-owner+w=401wt.eu-S1762359AbYBCFdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762359AbYBCFdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 00:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYBCFdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 00:33:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:36580 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYBCFdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 00:33:35 -0500
Subject: Re: PCI: Remove users of pci_enable_device_bars()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Greg KH <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
In-Reply-To: <20080202200531.GC24717@suse.de>
References: <200802020506.m1256FVn024064@hera.kernel.org>
	 <47A40D54.70509@garzik.org> <200802022101.11095.bzolnier@gmail.com>
	 <20080202200531.GC24717@suse.de>
Content-Type: text/plain
Date: Sun, 03 Feb 2008 16:32:58 +1100
Message-Id: <1202016778.7208.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Since Alan has commented on it:
> > 
> > http://lkml.org/lkml/2007/12/17/422
> > 
> > "5520 in fact is always enabled as it is the host bridge.
> > pci_enable_device_io will do just fine. The 5520 fun is if you disable it
> > the system hangs."
> > 
> > I moved on assuming that either submitter or integrator would follow up...
> > but it seems that it didn't happen. :(
> > 
> > PS Could somebody remove the stale comment from cs5520.c?
> 
> Ben, care to send me a patch for this, as it's your change?

Ah sure, will do tomorrow.

Cheers,
Ben.


