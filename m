Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYG2E1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYG2E1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 00:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYG2E1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 00:27:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYG2E1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 00:27:12 -0400
Date: Mon, 28 Jul 2008 21:26:55 -0700
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [bug] PCI hotplug, ibmphp_access_ebda: WARNING: at
	arch/x86/mm/ioremap.c:182 __ioremap_caller+0x2d1/0x340()
Message-ID: <20080729042655.GC13455@kroah.com>
References: <20080726131512.GA29472@elte.hu> <200807281531.32640.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807281531.32640.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 03:31:32PM -0700, Jesse Barnes wrote:
> On Saturday, July 26, 2008 6:15 am Ingo Molnar wrote:
> > FYI, -tip testing triggered the new warning below on a testbox. I
> > suspect it's related to recent commits in drivers/pci/hotplug/.
> > I'm wondering, why does a driver map the EBDA? That's a really lowlevel
> > thing.
> 
> AFAICT, this driver digs around in there for hotplug controller configuration 
> (cc'ing Greg since he appears to be one of the original authors).  It's a 
> custom platform driver too, that may be the only method available there.  Is 
> there a shadow copy of the EDBA somewhere we should be using instead?

Yeah, that's a real low-level driver, so it probably has to do this kind
of thing.  I no longer have access to hardware that uses this driver,
try poking Gary (the 2.4 pci hotplug maintainer), he probably knows more
about it now.

thanks,

greg k-h
