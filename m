Return-Path: <linux-kernel-owner+w=401wt.eu-S1762018AbXEPMf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762018AbXEPMf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbXEPMfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:35:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45924 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757107AbXEPMfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:35:50 -0400
Date: Wed, 16 May 2007 13:40:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Thomas Kuther <gimpel@sonnenkinder.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: IT821x: no DMA since 2.6.21
Message-ID: <20070516134021.0fefa16b@the-village.bc.nu>
In-Reply-To: <200705160258.15928.bzolnier@gmail.com>
References: <20070515125308.3a9f6442@SiRiUS.home>
	<20070515123132.2e596d69@the-village.bc.nu>
	<200705160258.15928.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The real problem seems to be that IT821x "virtual" ID misses info
> about supported DMA modes (while it seems to contain enabled DMA
> mode info).

It does at least for the RAID volumes which are quite peculiar and seem
to have been defined by flipping bits until Windows worked 8)


> [ Patch is based on the above theory and Alan's work on pata_it821x.
>   Sorry for no real description (TODO) but it's almost 3:00 am ... ]

Thanks for doing that. I've got a potential patch for libata and the
smart mode problem. Turns out that Tejun's sanity checks in the bus reset
path are too smart for the firmware ;)

Alan
