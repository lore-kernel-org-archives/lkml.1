Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbXJMWg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbXJMWg0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 18:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbXJMWgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 18:36:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:23822 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbXJMWgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 18:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jOhI1zct4O/HVaz7YpxgbmcWlVLJG3kCmiVPYcyqUXYz+VIApEFvMKKA0wQMeREctScilRqNhewcAvMRFiA5aiC7hatBs/WoOIVdDU3C6M9SgYby8SuWfQbSGeFOO2zW2XNm+sUgAyuTIm8rAkeg+KGRsheR/BEJVbkQlEQqic0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] IDE updates (part 2)
Date: Sun, 14 Oct 2007 00:41:25 +0200
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200710131825.24768.bzolnier@gmail.com> <200710140009.06260.bzolnier@gmail.com> <20071013232922.3ff6a464@the-village.bc.nu>
In-Reply-To: <20071013232922.3ff6a464@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710140041.25152.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007, Alan Cox wrote:
> > > > 		/* Probably a PCI interface... */
> > > > 		for (i = IDE_DATA_OFFSET; i <= IDE_STATUS_OFFSET; ++i)
> > > > 			hw->io_ports[i] = data_port + i - IDE_DATA_OFFSET;
> > > > 		hw->io_ports[IDE_CONTROL_OFFSET] = ctrl_port;
> 
> Ok so in actual fact
> 
> - The piece of code above can't be executed anyway
> - The ctrl_port argument is not needed ?

pmac_ide_init_hwif_ports() is also called by ide_init_hwif_ports()
through ppc_ide_md.init_hwif.

Bart
