Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbYG2JYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbYG2JYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYG2JYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:24:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33504 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754813AbYG2JYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:24:06 -0400
Date: Tue, 29 Jul 2008 10:06:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       Vasily Averin <vvs@sw.ru>
Subject: Re: [PATCH]: Proposed fix to the I2O problems with > 4GB space
Message-ID: <20080729100602.4766cfa5@lxorguk.ukuu.org.uk>
In-Reply-To: <20080729004756.113d85a0.akpm@linux-foundation.org>
References: <20080725131637.48072ef3@lxorguk.ukuu.org.uk>
	<20080729004756.113d85a0.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> all mucked up.  Sometimes takes three args, sometimes four.  When it's
> four the fourth arg is sometimes a gfp_t, sometimes a PCI_DMA_foo.
> 
> It fell afoul of the dma_mapping_error() interface change too.

Probably forgot to refresh the patch series... must be age ;)

I'll take a look at that next week
