Return-Path: <linux-kernel-owner+w=401wt.eu-S1762683AbXFEAzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762683AbXFEAzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 20:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759633AbXFEAzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 20:55:45 -0400
Received: from holomorphy.com ([66.93.40.71]:59827 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122AbXFEAzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 20:55:45 -0400
Date: Mon, 4 Jun 2007 17:56:34 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605005634.GG15426@holomorphy.com>
References: <Pine.SOC.4.64.0706032314590.20033@math> <20070603.174010.41894721.davem@davemloft.net> <20070604143005.1b0e3c66@the-village.bc.nu> <20070604.142243.98381397.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070604.142243.98381397.davem@davemloft.net>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 4 Jun 2007 14:30:05 +0100
>> There are PCMCIA controllers and PCI/PCMCIA/Cardbus adapters for the
>> Sparc platform I thought ?

On Mon, Jun 04, 2007 at 02:22:43PM -0700, David Miller wrote:
> The 32-bit sparc port has some but those PCMCIA controllers aren't
> going to be supported in the foreseeable future, you have to abstract
> out all the inb/outb etc. operations to go through the pcmcia
> controller driver for one thing.
> Secondarily, sparc32 lacks an active maintainer and it's
> been like this for several years, the only things getting
> worked on therefore are basica functionality and the most
> important bug fixes.

I don't foresee my ever dealing with those PCMCIA controllers. If by
some miracle I manage to get any work done on basic functionality I'll
consider that having won.


-- wli
