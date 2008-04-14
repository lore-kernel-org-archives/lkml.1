Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbYDNWOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbYDNWOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 18:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYDNWOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 18:14:19 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44635 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbYDNWOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 18:14:19 -0400
Date: Tue, 15 Apr 2008 01:13:12 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: chris@zankel.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xtensa: don't offer PARPORT_PC
Message-ID: <20080414221312.GI26885@cs181133002.pp.htv.fi>
References: <20080414195551.GE26885@cs181133002.pp.htv.fi> <20080414223124.6b92de11@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080414223124.6b92de11@core>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:31:24PM +0100, Alan Cox wrote:
> On Mon, 14 Apr 2008 22:55:51 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch fixes the following compile error:
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC [M]  drivers/parport/parport_pc.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c:67:25: error: asm/parport.h: No such file or directory
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c: In function 'parport_pc_find_ports':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/parport/parport_pc.c:3215: error: implicit declaration of function 'parport_pc_find_nonpci_ports'
> > make[3]: *** [drivers/parport/parport_pc.o] Error 1
> > 
> > <--  snip  -->
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> If xtensa has PCI then if you fix up the headers so the PCI stuff works
> we'll be in a better shape.

The only merged platform does not support PCI, and I don't have any 
xtensa hardware for knowing what to put there.

Chris?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

