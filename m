Return-Path: <linux-kernel-owner+w=401wt.eu-S1759635AbXGDJnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635AbXGDJnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 05:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbXGDJnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 05:43:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45787 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757019AbXGDJnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 05:43:39 -0400
Date: Wed, 4 Jul 2007 10:49:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH] libata_acpi: A different strategy for using ACPI
 information
Message-ID: <20070704104954.16812248@the-village.bc.nu>
In-Reply-To: <468AE196.9070202@shaw.ca>
References: <fa.rEwk8NvbygVfpOfb23QZ97ZMeXs@ifi.uio.no>
	<468AE196.9070202@shaw.ca>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Looks fairly reasonable to me. However, I suspect any use of _GTM is 
> somewhat dangerous (at least after the resume) unless we use the _STM 
> and _GTF methods in the proper sequence when resuming. (Is that in the 
> -mm tree now?)

Yes - and we only use it in these drivers to check for cable evidence not
for anything more serious.

> speed we give it is valid, since there is no sane way for the function 
> to indicate failure. (Thus the problem with the "cram in all possible 
> values to see what it supports" strategy for determining mode limits..)

The spec I have says it'll hand back the mode it actually uses which is
effectively a solution for 'failure'
