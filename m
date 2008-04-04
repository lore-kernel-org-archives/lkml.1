Return-Path: <linux-kernel-owner+w=401wt.eu-S1756265AbYDDKsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756265AbYDDKsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 06:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYDDKsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 06:48:12 -0400
Received: from wmproxy1-g27.free.fr ([212.27.42.91]:50148 "EHLO
	wmproxy1-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbYDDKsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 06:48:11 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Apr 2008 06:48:11 EDT
Message-ID: <1207305444.47f604e4c37b0@imp.free.fr>
Date: Fri, 04 Apr 2008 12:37:24 +0200
From: Gilles Espinasse <g.esp@free.fr>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
References: <20080404063359.GA13309@havoc.gtf.org>
In-Reply-To: <20080404063359.GA13309@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 192.54.193.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selon Jeff Garzik <jeff@garzik.org>:

> I will have another batch to send in the next day or so, including a
> notable forcedeth fix.
>
> Please pull from 'upstream-davem' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
> upstream-davem
>
> to receive the following updates:
>
>  drivers/net/forcedeth.c         |    5 ++---
>  drivers/net/phy/marvell.c       |    2 --
>  drivers/net/tokenring/olympic.c |    6 +++---
>  drivers/net/tulip/tulip_core.c  |    1 -
>  4 files changed, 5 insertions(+), 9 deletions(-)
>
...
> Chuck Ebbert (1):
>       NET: remove support for Davicom 9102 from the Tulip driver
...
> diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
> index 82f404b..4443f0f 100644
> --- a/drivers/net/tulip/tulip_core.c
> +++ b/drivers/net/tulip/tulip_core.c
> @@ -231,7 +231,6 @@ static struct pci_device_id tulip_pci_tbl[] = {
>  	{ 0x11F6, 0x9881, PCI_ANY_ID, PCI_ANY_ID, 0, 0, COMPEX9881 },
>  	{ 0x8086, 0x0039, PCI_ANY_ID, PCI_ANY_ID, 0, 0, I21145 },
>  	{ 0x1282, 0x9100, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DM910X },
> -	{ 0x1282, 0x9102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, DM910X },
>  	{ 0x1113, 0x1216, PCI_ANY_ID, PCI_ANY_ID, 0, 0, COMET },
>  	{ 0x1113, 0x1217, PCI_ANY_ID, PCI_ANY_ID, 0, 0, MX98715 },
>  	{ 0x1113, 0x9511, PCI_ANY_ID, PCI_ANY_ID, 0, 0, COMET },

I was looking at some dfme vs tulip google search.

How the id removal accord to this debian bug report
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=400837

Looking at dmfe history on git, it is not clearly stated this problem has been
fixed.
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=history;f=drivers/net/tulip/dmfe.c;h=656200472fa17aa3e5e8e5d592c4fc2fa1ff2077;hb=HEAD

Gilles
