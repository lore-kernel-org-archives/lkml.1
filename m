Return-Path: <linux-kernel-owner+w=401wt.eu-S1761280AbXGDNDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761280AbXGDNDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759355AbXGDNDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:03:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32905 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759339AbXGDNDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:03:00 -0400
Date: Wed, 4 Jul 2007 15:02:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: Libata PATA status
Message-ID: <20070704130258.GA10904@one.firstfloor.org>
References: <20070703185116.59c8f5f5@the-village.bc.nu> <p73k5tg2uj9.fsf@bingen.suse.de> <20070704131746.4bbe4d0e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704131746.4bbe4d0e@the-village.bc.nu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 01:17:46PM +0100, Alan Cox wrote:
> On 04 Jul 2007 15:00:26 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > > 
> > > Post SRST 
> > What is SRST?
> > 
> > My personal wish list feature would be a little forwarder driver
> > to forward /dev/hd* to /dev/sd* for this; then old IDE could be
> > disabled without risking breaking old root file systems.
> 
> That would be udevd for new systems or "ln -s" for old ones ? 

Then old kernels couldn't be booted anymore.

> 
> I don't see a way to build that "simple" forwarder because the device
> allocation is now dynamic rather than tied to specific device on specific
> port - a concept with really no meaning any more.

Sure for SATA. But surely for PATA it would be possible to fake
the mapping of the old driver? Doing it simple minded (e.g. only
for the builtin devices) would be probably sufficient.

-Andi

