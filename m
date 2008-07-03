Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbYGCXUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbYGCXUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 19:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbYGCXUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 19:20:07 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37715 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756398AbYGCXUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 19:20:06 -0400
Date: Fri, 4 Jul 2008 00:02:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080704000206.259475a0@lxorguk.ukuu.org.uk>
In-Reply-To: <486D5D4F.9060000@garzik.org>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org>
	<20080703205548.D6E5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<486CC440.9030909@garzik.org>
	<Pine.LNX.4.64.0807031353030.11033@blonde.site>
	<486CCFED.7010308@garzik.org>
	<1215091999.10393.556.camel@pmac.infradead.org>
	<486CD654.4020605@garzik.org>
	<1215093175.10393.567.camel@pmac.infradead.org>
	<20080703173040.GB30506@mit.edu>
	<1215111362.10393.651.camel@pmac.infradead.org>
	<486D3E88.9090900@garzik.org>
	<486D4596.60005@infradead.org>
	<486D511A.9020405@garzik.org>
	<20080703232554.7271d645@lxorguk.ukuu.org.uk>
	<486D5D4F.9060000@garzik.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, I was tossing that about in my head:
> 
> Is it a better idea to eliminate 'make firmware_install' completely, and 
> instead implement it silently via 'make install'?
> 
> 'make install' is already a big fat distro hook...

make firmware_install can encapsulate a lot of kernel specific knowledge
so I think it belongs in the kernel tree to avoid problems in future. The
use of make firmware_install belongs in the distro make install hooks.

Otherwise we will mess up the distro stuff if we have to change the
innards of make firmware_install in future, as may well occur.
