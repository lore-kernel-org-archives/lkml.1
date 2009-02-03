Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZBCMBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZBCMBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZBCMBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:01:31 -0500
Received: from edu.joroinen.fi ([194.89.68.130]:48709 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbZBCMBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:01:30 -0500
Date: Tue, 3 Feb 2009 14:01:28 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] Fix sata_sil compilation error with libata debug enabled (2.6.29-rcX)
Message-ID: <20090203120128.GT15052@edu.joroinen.fi>
References: <20090202194714.GN15052@edu.joroinen.fi> <4987BC43.3040400@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4987BC43.3040400@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 02, 2009 at 10:38:43PM -0500, Jeff Garzik wrote:
> Pasi Kärkkäinen wrote:
> >Hello!
> >
> >I tried compiling 2.6.29-rc1 and 2.6.29-rc3 with libata debugging enabled
> >and got the following error:
> >
> >  CC [M]  drivers/ata/sata_sil.o
> >drivers/ata/sata_sil.c: In function 'sil_fill_sg':
> >drivers/ata/sata_sil.c:327: error: 'pi' undeclared (first use in this 
> >function)
> >drivers/ata/sata_sil.c:327: error: (Each undeclared identifier is reported 
> >only once
> >drivers/ata/sata_sil.c:327: error: for each function it appears in.)
> >make[2]: *** [drivers/ata/sata_sil.o] Error 1
> >make[1]: *** [drivers/ata] Error 2
> >make: *** [drivers] Error 2
> >
> >include/linux/libata.h has the following enabled:
> >
> >#define ATA_DEBUG
> >#define ATA_VERBOSE_DEBUG
> >#define ATA_IRQ_TRAP
> >
> >The attached patch fixes the compilation.. I'm not sure if it's the correct
> >fix, but looking at the code it seems correct.. or at least makes the
> >code compile for me :)
> 
> applied
> 

Great, thanks!

-- Pasi
