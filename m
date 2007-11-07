Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbXKGWzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbXKGWzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbXKGWy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:54:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46430 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752816AbXKGWy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:54:57 -0500
Date: Wed, 7 Nov 2007 22:54:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <liml@rtr.ca>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>,
       James Andrewartha <jamesa@daa.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com
Subject: Re: SC1200 failure in 2.6.23 and 2.6.24-rc1-git10
Message-ID: <20071107225453.34f8f340@the-village.bc.nu>
In-Reply-To: <47323CAF.2030102@rtr.ca>
References: <20071101213013.M54162@visp.net.lb>
	<20071106221521.4f64a066.akpm@linux-foundation.org>
	<20071107132630.M65286@visp.net.lb>
	<4731D85E.70201@daa.com.au>
	<20071107160426.M31617@visp.net.lb>
	<47320E37.8010106@rtr.ca>
	<20071107211932.M35475@visp.net.lb>
	<47323CAF.2030102@rtr.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> CFA spec requires 848a in word[0], not 844a, which explains
> why hdparm thought it might be ATAPI.  I've updated my hdparm
> source to detect this for hdparm-7.8 (unreleased).
> That card (16MB) is definitely buggy.
> But your other (1GB) card looks fine.
> 
> Thanks.  Somebody else may help with the libata issue.

848A is the preferred configuration value

The use of 044A is also allowed in the case of it being non-removable.
Guess someone got muddled up in the middle.

844A is a bit iffy and it should still be detectable as Word 83 bit 2
should be set ?


As to the old IDE (not libata ?) issue - I suspect a convertor without
DMA support as a first guess.

Alan
