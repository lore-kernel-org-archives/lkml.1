Return-Path: <linux-kernel-owner+w=401wt.eu-S1751638AbXLYV1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638AbXLYV1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 16:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbXLYV1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 16:27:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:48396 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbXLYV1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 16:27:30 -0500
Subject: Re: [RFC/PATCH 4/4] [POWERPC] pci: Disable IO/Mem on a device when
	resources can't be allocated
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
In-Reply-To: <1198617653.7209.4.camel@pasglop>
References: <1197932473.576079.142524077033.qpush@grosgo>
	 <20071217230127.46B3BDDE38@ozlabs.org>
	 <20071224072301.GD3758@colo.lackof.org>  <1198617653.7209.4.camel@pasglop>
Content-Type: text/plain
Date: Wed, 26 Dec 2007 08:26:27 +1100
Message-Id: <1198617987.7209.11.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This is exactly what's supposed to be happening, but the code is buggy
> and nobody noticed :-) (I'm mixing up IORESOURCE_* flags and
> PCI_COMMAND_* flags). Thanks for reviewing !

Note that this patch isn't in the series Greg queued up anyway. The
powerpc specific bits will be going in via Paulus an I already asked him
to drop that specific one until I send a fixed version.

Cheers,
Ben.


