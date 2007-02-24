Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbXBWXoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbXBWXoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932768AbXBWXoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:44:18 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35557 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932754AbXBWXoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:44:17 -0500
Date: Sat, 24 Feb 2007 00:48:09 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: <Tom.Morrison@Verizon.net>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Problems with init of Marvell PCI Express SATA Card
Message-ID: <20070224004809.30a0e105@lxorguk.ukuu.org.uk>
In-Reply-To: <CJEDIOAEPEPAEFLDLKIBAEJMCDAA.Tom.Morrison@Verizon.net>
References: <20070224001829.2b444773@lxorguk.ukuu.org.uk>
	<CJEDIOAEPEPAEFLDLKIBAEJMCDAA.Tom.Morrison@Verizon.net>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007 18:21:26 -0500
"Tom Morrison" <Tom.Morrison@Verizon.net> wrote:

> Alan,
> 
> Where do I look in the kernel to see if there is
> 'driver support' present based upon the card?
> 
> As I mentioned as well, the same driver is used
> for the PCI Driver (using 6042 chip). So, at some
> level, the support is there.
> 
> The key is does Linux *Kernel* support for PCI
> Express have support for this card? Which goes
> back to the initial question - where/how do I
> look to see if it does????

PCI Express looks like PCI so generally there isn't specific support 
needed. The Marvell driver supports the 6101 and 6145 chipsets for PATA
and for SATA the sata_mv driver supports the 5040, 5041, 5080, 5081,
6040, 6041, 6042, 6080, 6081.

Alan
