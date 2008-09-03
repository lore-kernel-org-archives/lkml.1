Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYICNnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYICNnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYICNnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:43:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46485 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYICNnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:43:04 -0400
Message-ID: <48BE945E.4090106@garzik.org>
Date: Wed, 03 Sep 2008 09:42:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: torvalds@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ahci: Fix long standing Marvell regressions
References: <20080903000538.7500eaf8@lxorguk.ukuu.org.uk>	<48BDCF09.7000603@garzik.org> <20080903142941.3f25d235@lxorguk.ukuu.org.uk>
In-Reply-To: <20080903142941.3f25d235@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> The actual fix for the moment is very simple. If the user has included
> the pata_marvell driver let it drive the ports. If they've only selected
> for SATA support give them the AHCI driver which will run the port a fraction
> faster. Allow the user to control this decision via ahci.marvell_enable as
> a module parameter so that distributions can ship 'it works' defaults and
> smarter users (or config tools) can then flip it over it desired.
> 
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> ---
> 
>  drivers/ata/Kconfig |    6 ++++--
>  drivers/ata/ahci.c  |   19 +++++++++++++++++++
>  2 files changed, 23 insertions(+), 2 deletions(-)

[snip]

That's far more reasonable, and I'd be happy to queue that with your 
full email text...

Unless you object, I'll roll this up with a couple other libata fixes 
for 2.6.27-rc.

	Jeff



