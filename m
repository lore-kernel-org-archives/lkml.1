Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbXL0VDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbXL0VDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 16:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXL0VDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 16:03:33 -0500
Received: from colo.lackof.org ([198.49.126.79]:56806 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbXL0VDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 16:03:32 -0500
Date: Thu, 27 Dec 2007 14:03:15 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 4/4] [POWERPC] pci: Disable IO/Mem on a device when
	resources can't be allocated
Message-ID: <20071227210315.GB17782@colo.lackof.org>
References: <1197932473.576079.142524077033.qpush@grosgo> <20071217230127.46B3BDDE38@ozlabs.org> <20071224072301.GD3758@colo.lackof.org> <1198617653.7209.4.camel@pasglop> <1198617987.7209.11.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198617987.7209.11.camel@pasglop>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2007 at 08:26:27AM +1100, Benjamin Herrenschmidt wrote:
> 
> > This is exactly what's supposed to be happening, but the code is buggy
> > and nobody noticed :-) (I'm mixing up IORESOURCE_* flags and
> > PCI_COMMAND_* flags). Thanks for reviewing !
> 
> Note that this patch isn't in the series Greg queued up anyway. The
> powerpc specific bits will be going in via Paulus an I already asked him
> to drop that specific one until I send a fixed version.

Ah ok....but I was mostly worried about the use of PPC bits as an example.
Anyway, in general it looks like the right direction to me too.

cheers,
grant
