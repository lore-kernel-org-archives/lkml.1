Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbZFSWaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbZFSWaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZFSWaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:30:09 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:46586 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbZFSWaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:30:08 -0400
Date: Sat, 20 Jun 2009 00:28:28 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sdhci: Specific quirk vor VIA SDHCI controller in
	VX855ES
Message-ID: <20090619222828.GA4664@prithivi.gnumonks.org>
References: <20090618145338.GX7692@prithivi.gnumonks.org> <20090619213314.150f0d98@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619213314.150f0d98@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Jun 19, 2009 at 09:33:14PM +0200, Pierre Ossman wrote:

> Does this block have a name? Something nicer than 0x95d0 in the id list
> would be nice.

Unfortunately no.  We really have a big mess with those integrated chipsets
that have something like 15 PCI devices inside one component.  We cannot call
all of them 'VX855'. or 'VX800', as that would clash.  Naming things
'PCI_DEVICE_VIA_VX800_SDHCI' is also not really correct, since the same
block appearas in other integrated chipsets, too.

As for VIA's documentation, every block is called something like D13F3 (pci
device 13 function 3), which doesn't really sound all that much better than
just putting a 0x95d0 there.

To make things even furter complicated, some VIA Docs refer to the SDHCI
controller as 'SDIO controller' and the via-sdmmc as 'SD card controller'...

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
