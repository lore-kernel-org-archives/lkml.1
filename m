Return-Path: <linux-kernel-owner+w=401wt.eu-S938502AbXGSPIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938502AbXGSPIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937487AbXGSPIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:08:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37857 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S937289AbXGSPIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:08:23 -0400
Date: Thu, 19 Jul 2007 16:15:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [patch 11/13] cell: driver for DDR2 memory on
 AXON
Message-ID: <20070719161503.304c4037@the-village.bc.nu>
In-Reply-To: <200707191649.27976.arnd@arndb.de>
References: <20070718160439.723093835@arndb.de>
	<200707190048.09686.arnd@arndb.de>
	<20070719101230.GA4553@lst.de>
	<200707191649.27976.arnd@arndb.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Any suggestion on what BLKBSZGET should return?
> 
> 1) blocksize = 0 (same as it does already for most devices)

This is what tools like df expect
