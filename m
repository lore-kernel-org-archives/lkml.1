Return-Path: <linux-kernel-owner+w=401wt.eu-S933264AbXC1UvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbXC1UvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933305AbXC1UvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:51:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47840 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933264AbXC1UvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:51:20 -0400
Date: Wed, 28 Mar 2007 22:54:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       kyle@canonical.com
Subject: Re: HPA patches
Message-ID: <20070328225431.69d0a3cc@the-village.bc.nu>
In-Reply-To: <20070328200829.GA12776@srcf.ucam.org>
References: <20070323191321.5d00887a@lxorguk.ukuu.org.uk>
	<20070328000851.GA25551@srcf.ucam.org>
	<20070328105754.72b578bd@the-village.bc.nu>
	<20070328200829.GA12776@srcf.ucam.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hm. I tried adding it in the eh code after ata_set_mode() in 
> ata_eh_recover(), which alters the problem slightly - hpa_sectors is 
> still 0, so the taskfile call is still failing, but now the system just 
> stops at around the time that anything attempts to access sda with no 
> errors other than

I wonder if the firmware is dying when we ask the disk to go zero sized
rather than erroring politely. I'm not sure hth HPA sectors can come back
as zero but we can be fairly sure 0 means "no HPA" in this case I guess ?

