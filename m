Return-Path: <linux-kernel-owner+w=401wt.eu-S1759745AbXK1Tyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbXK1Tyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbXK1TyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:54:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50861 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752648AbXK1TyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:54:10 -0500
Date: Wed, 28 Nov 2007 19:50:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tvrtko.ursulin@sophos.com
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071128195042.047049fc@the-village.bc.nu>
In-Reply-To: <OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com>
References: <20071128093956.6625584b@freepuppy.rosehill>
	<OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So as there is no question the current code does some ugly things it is 
> even more true that we would be even more happy to use an official API. 
> LSM was that and we were happily using it which we won't be able to do if 
> it abruptly goes away. Yes it is not a perfect match but until it is 
> modified to be better, or until something appropriate is designed and 
> implemented, it would be very nice if it could stay.

So for an SELinux based system what you are saying is you want to be able
to stack your module with the SELinux module and after SELinux has
considered policy rules still be able to veto them on the grounds that
you are say about to serve a virus to a windows box ?

Alan
