Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbXI0PO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbXI0PO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbXI0POT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:14:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48929 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754758AbXI0POS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:14:18 -0400
Date: Thu, 27 Sep 2007 16:19:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file 
 without options
Message-ID: <20070927161912.2f08aff6@the-village.bc.nu>
In-Reply-To: <20070927150853.GA10154@kernel.dk>
References: <20070927142919.10b62f9b@the-village.bc.nu>
	<20070927070118.2bd4792e@laptopd505.fenrus.org>
	<20070927151921.29b19abb@the-village.bc.nu>
	<20070927143548.GT5243@kernel.dk>
	<20070927154432.302ec5a7@the-village.bc.nu>
	<20070927150853.GA10154@kernel.dk>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Well it's not my call, just seems like a really bad idea to change the
> error value. You can't claim full coverage for such testing anyway, it's
> one of those things that people will complain about two releases later
> saying it broke app foo.

Strange since we've spent years changing error values and getting them
right in the past. 

There are real things to worry about - sysfs, sysfs, sysfs, ... and all
the other crap which is continually breaking stuff, not spec compliance
corrections that don't break things but move us into compliance with the
standard

Alan
