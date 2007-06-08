Return-Path: <linux-kernel-owner+w=401wt.eu-S1032232AbXFHW3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032232AbXFHW3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S971155AbXFHW2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:28:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:37315 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S971141AbXFHW23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=U3n99/mIoHCQBzW6Tj2tLzTZZvozKwLBUjAw8UJrMqUDAfZgJnpfI8vVihv/7JM0/UWZtLDIhuAep5/SSRniU9oHDygZrksIf5UOfyNSfElkvwevpAzS0xfg2y9363q7TZbWyobN/MfYLm5UDfU10gMLhcRsB6eJRVCYSQF98ZY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] ide: ide-generic, add another device exception
Date: Sat, 9 Jun 2007 00:42:50 +0200
User-Agent: KMail/1.9.6
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Korb <ml@akana.de>, linux-ide@vger.kernel.org
References: <20601315171560711667@wsc.cz> <200706081418.56217.bzolnier@gmail.com> <20070608223505.3ff1a662@the-village.bc.nu>
In-Reply-To: <20070608223505.3ff1a662@the-village.bc.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706090042.50287.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 June 2007, Alan Cox wrote:
> On Fri, 8 Jun 2007 14:18:55 +0200
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > On Monday 04 June 2007, Jiri Slaby wrote:
> > > ide-generic, add another device exception
> > 
> > ide-generic is a generic ISA IDE driver, this one is drivers/ide/pci/generic
> > (a generic IDE PCI driver) - fixed patch description to avoid confusion.
> 
> Nope ide-generic is a generic I/O based ST506 interface. It covers a bit
> more than just ISA bus.

If so then can we finally get rid of hd.c?

> > [ Yes, both drivers need a rename - patches are welcomed. ]
> 
> Good way to break everyones module settings

MODULE_ALIAS() should cover this up nicely.

Thanks,
Bart
