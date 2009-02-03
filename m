Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbZBCDi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbZBCDi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZBCDir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:38:47 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56795 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbZBCDir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:38:47 -0500
Message-ID: <4987BC43.3040400@garzik.org>
Date: Mon, 02 Feb 2009 22:38:43 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] Fix sata_sil compilation error with libata debug enabled
 (2.6.29-rcX)
References: <20090202194714.GN15052@edu.joroinen.fi>
In-Reply-To: <20090202194714.GN15052@edu.joroinen.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pasi Kärkkäinen wrote:
> Hello!
> 
> I tried compiling 2.6.29-rc1 and 2.6.29-rc3 with libata debugging enabled
> and got the following error:
> 
>   CC [M]  drivers/ata/sata_sil.o
> drivers/ata/sata_sil.c: In function 'sil_fill_sg':
> drivers/ata/sata_sil.c:327: error: 'pi' undeclared (first use in this function)
> drivers/ata/sata_sil.c:327: error: (Each undeclared identifier is reported only once
> drivers/ata/sata_sil.c:327: error: for each function it appears in.)
> make[2]: *** [drivers/ata/sata_sil.o] Error 1
> make[1]: *** [drivers/ata] Error 2
> make: *** [drivers] Error 2
> 
> include/linux/libata.h has the following enabled:
> 
> #define ATA_DEBUG
> #define ATA_VERBOSE_DEBUG
> #define ATA_IRQ_TRAP
> 
> The attached patch fixes the compilation.. I'm not sure if it's the correct
> fix, but looking at the code it seems correct.. or at least makes the
> code compile for me :)

applied


