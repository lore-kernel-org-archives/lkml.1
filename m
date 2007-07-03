Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXGCU12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXGCU12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbXGCU06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:26:58 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:18521 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201AbXGCU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=EYdYcDRoMcHTSh3/QXvG5WAQRmvyJxZ0TTYpSBflzpjkk1f9UTQiIQcKfH3O8aHnlh/4ZpyXeOBbIo+ahe6H5zPHE5IYoJdtU1Ss3I+n/NnqhFEr7kuNJ7UcxCT7cHBKojwhzlVueVaVmw60x/vb9TLraSN5W4Ar6+FFBDEtSzU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_hpt3x3: Major reworking and testing
Date: Tue, 3 Jul 2007 22:12:01 +0200
User-Agent: KMail/1.9.6
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jeff@garzik.org
References: <20070703161002.1576c39d@the-village.bc.nu> <200707031938.20956.bzolnier@gmail.com> <20070703185652.0b807fcc@the-village.bc.nu>
In-Reply-To: <20070703185652.0b807fcc@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707032212.01619.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2007, Alan Cox wrote:
> > The new improved driver is not really better than the old one because
> > the old one is broken. :)
> > 
> > Old driver does identical configuration when it comes to PIO modes.
> 
> No the old driver doesn't even do that. It starts up. It spuriously
> adjusts some non writable PCI BAR registers, prints a message about
> resources being in use already then exits.

OK, thanks for clarifying this.

> I had a poke around the setup. As far as I can observe we break even if
> the ROM timing values are used as is. I suspect documentation or a good
> deal of luck is needed.

Yeah.

BTW the original Andre's driver had some references to misc configuration
registers at offsets 0x10 and 0x11 of PCI BAR4.

http://www.linuxhq.com/kernel/v2.3/10/drivers/block/hpt343.c

Does anybody have DOS driver for HPT343?  Google doesn't have it...

Thanks,
Bart
