Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbZEMIwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbZEMIwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 04:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbZEMIwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 04:52:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40982 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758279AbZEMIwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 04:52:19 -0400
Date: Wed, 13 May 2009 09:51:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brad Boyer <flar@allandria.com>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       takata@linux-m32r.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
Message-ID: <20090513095127.308b00e7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090513043409.GA13577@cynthia.pants.nu>
References: <20090511222702.352192505@arndb.de>
	<200905112238.55404.arnd@arndb.de>
	<20090512090602.65722342@lxorguk.ukuu.org.uk>
	<200905121123.21436.arnd@arndb.de>
	<20090513033027.GA13193@cynthia.pants.nu>
	<alpine.DEB.1.00.0905130610240.18305@zirkon.biophys.uni-duesseldorf.de>
	<20090513043409.GA13577@cynthia.pants.nu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If it doesn't interfere with plain PIO mode, fine. 
> 
> I agree. There definitely needs to still be support for IDE ports that
> don't have DMA capability.

There is - it's just if the platform doesn't implement the dma_* APIs you
get a problem.

Alan
