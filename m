Return-Path: <linux-kernel-owner+w=401wt.eu-S1031703AbXEANd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031703AbXEANd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 09:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031701AbXEANd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 09:33:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47761 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031703AbXEANd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 09:33:27 -0400
Date: Tue, 1 May 2007 14:36:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: William Thompson <wt@electro-mechanical.com>, Mark Lord <liml@rtr.ca>,
       Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: 2.6.20 libata cdrom
Message-ID: <20070501143637.341c1226@the-village.bc.nu>
In-Reply-To: <46373F9A.9020705@rtr.ca>
References: <20070427175205.GD7809@electro-mechanical.com>
	<4635C35D.1020807@gmail.com>
	<20070430202107.GF5942@electro-mechanical.com>
	<4636C2C7.8090206@gmail.com>
	<20070501121703.GH5942@electro-mechanical.com>
	<46373AEE.6070908@rtr.ca>
	<20070501131818.GA18521@electro-mechanical.com>
	<46373F9A.9020705@rtr.ca>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But libata might actually be able to use mdma2 with it,
> as I believe (unsubstantiated) that Alan may have done
> a better implementation of setting the timings than what
> we had with our old IDE drivers.

The new code knows how to set MWDMA2 timings properly, and it knows about
picking timings that also work for PIO. That's not my credit however, it
came for free when we adopted and used the ide-timing.h code from Vojtech
Pavlik.

I know Sergei thinks we should probably switch timings between PIO and
DMA operations when needed rather than run slower so it will be
interesting to know what this drive actually needs to behave with libata.

