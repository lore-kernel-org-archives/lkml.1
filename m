Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbXLRJhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbXLRJhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 04:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXLRJhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 04:37:06 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:59975 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXLRJhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 04:37:04 -0500
Date: Tue, 18 Dec 2007 12:37:15 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Johannes Weiner <hannes@saeurebad.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       Alan Cox <alan@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
       jgarzik@pobox.com, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 1/4] pci: Add pci_enable_device_{io,mem} intefaces
Message-ID: <20071218123715.A7874@jurassic.park.msu.ru>
References: <1197932473.576079.142524077033.qpush@grosgo> <x7prx4vq3e.fsf@saeurebad.de> <1197936157.13400.9.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <1197936157.13400.9.camel@pasglop>; from benh@kernel.crashing.org on Tue, Dec 18, 2007 at 11:02:37AM +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 11:02:37AM +1100, Benjamin Herrenschmidt wrote:
> +EXPORT_SYMBOL(pci_enable_device_io);
> +EXPORT_SYMBOL(pci_enable_device_mem);
>  EXPORT_SYMBOL(pci_enable_device);

Wouldn't it be better to export only the pci_enable_device_flags()
and make these three just "static inline" wrappers in pci.h?

>  EXPORT_SYMBOL(pcim_enable_device);

Looks like many SATA drivers would benefit from pcim_* equivalents
of pci_enable_device_{io,mem}, as they could happily work with just
a single MMIO BAR... Alan?

Ivan.
