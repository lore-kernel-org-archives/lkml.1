Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbXCZN2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbXCZN2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 09:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXCZN2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 09:28:04 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:56776 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbXCZN2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 09:28:03 -0400
Message-ID: <4607CA5A.4040906@s5r6.in-berlin.de>
Date: Mon, 26 Mar 2007 15:27:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>, linux-scsi@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: some PCMCIA SCSI drivers can be built *only* as modules
References: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote at LKML:
> drivers/scsi/pcmcia/Kconfig:
> ...
> config PCMCIA_AHA152X
>         tristate "Adaptec AHA152X PCMCIA support"
>         depends on m && !64BIT
>         select SCSI_SPI_ATTRS
>         help
>           Say Y here if you intend to attach this type of PCMCIA SCSI host
>           adapter to your computer.
> 
>           To compile this driver as a module, choose M here: the
>           module will be called aha152x_cs.
> ...
> 
>   it would seem to make no sense that the "depends on" clause for this
> option includes "m", forcing this (and all other four entries in that
> Kconfig file, by the way) to be built as modules, while the help text
> for all five entries suggests you can select "y".
> 
>   as jack nicholson would say, something's gotta give.

LSML a.k.a. linux-scsi may know what's gotta give.
-- 
Stefan Richter
-=====-=-=== --== ==-=-
http://arcgraph.de/sr/
