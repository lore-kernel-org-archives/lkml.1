Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbXI0OjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbXI0OjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXI0OjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:39:05 -0400
Received: from [81.2.110.250] ([81.2.110.250]:50562 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755480AbXI0OjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:39:04 -0400
Date: Thu, 27 Sep 2007 15:44:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file
 without options
Message-ID: <20070927154432.302ec5a7@the-village.bc.nu>
In-Reply-To: <20070927143548.GT5243@kernel.dk>
References: <20070927142919.10b62f9b@the-village.bc.nu>
	<20070927070118.2bd4792e@laptopd505.fenrus.org>
	<20070927151921.29b19abb@the-village.bc.nu>
	<20070927143548.GT5243@kernel.dk>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Its a change of a specific error return from the wrong error to the right
> > one, nothing more. Fixing the returned error gives us correct behaviour
> > according to the standards and other systems.
> 
> It may still break applications. Waving some standard at them if they
> complain is unlikely to impress them.

And our existing behaviour may well break correctly written
portable applications, and is incorrect as well.

Testing so far says it doesn't break anything, which is no suprise if you
apply about ten braincells to the case under consideration.

Alan
