Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbXKAKxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbXKAKxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbXKAKxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:53:05 -0400
Received: from [81.2.110.250] ([81.2.110.250]:60776 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756473AbXKAKxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:53:02 -0400
Date: Thu, 1 Nov 2007 10:53:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071101105335.1f20bab3@the-village.bc.nu>
In-Reply-To: <4729A0DF.20800@garzik.org>
References: <47274A5F.6070409@gentoo.org>
	<20071030153417.59b9182c@the-village.bc.nu>
	<47276DCA.1000808@gentoo.org>
	<20071030190153.373c9347@the-village.bc.nu>
	<47278439.4030801@gentoo.org>
	<20071031114958.210bd7cc@the-village.bc.nu>
	<20071031115754.GK5059@kernel.dk>
	<4729A0DF.20800@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> demonstrated by (a) Alan's patch did not change DMA lbam/lbah 
> programming and (b) Daniel's report of the message "ata2.00: 66 bytes 

(a) did. Well the original did, dunno about your version.

> I am not drawing any conclusions yet, but I'm thinking that blimit=8k 
> may be a better choice for SATA ATAPI.

Only if your transfer is actually 8K or more.


Alan
