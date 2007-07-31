Return-Path: <linux-kernel-owner+w=401wt.eu-S1760734AbXGaPiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbXGaPiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXGaPiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:38:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55034 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751064AbXGaPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:38:10 -0400
Date: Tue, 31 Jul 2007 16:45:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Correct IORDY handling
Message-ID: <20070731164511.4d2f81ee@the-village.bc.nu>
In-Reply-To: <46AF44D3.3090608@ru.mvista.com>
References: <20070731140148.4cb780de@the-village.bc.nu>
	<46AF44D3.3090608@ru.mvista.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > +			dev->pio_mode <= XFER_PIO_2)
> 
>     Overindented line (to my taste :-). And do we really need to check this?
> 

Yes - if it refuses SET_XFER_MODE we really don't want to run any mode
above PIO2. No hardware *should* do this but then this is IDE...
