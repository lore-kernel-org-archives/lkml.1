Return-Path: <linux-kernel-owner+w=401wt.eu-S1757027AbYGCWof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbYGCWof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbYGCWoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:44:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52492 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755364AbYGCWoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:44:23 -0400
Date: Thu, 3 Jul 2008 23:25:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080703232554.7271d645@lxorguk.ukuu.org.uk>
In-Reply-To: <486D511A.9020405@garzik.org>
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

O
> Further, all current kernel build and test etc. scripts are unaware of 
> 'make firmware_install', and it is unfair to everybody to force a 
> flag-day build process change on people, just to keep their drivers in 
> the same working state today as it was yesterday.

IMHO we want firmware built in as the default for the moment. If the
firmware model makes sense (as I think it does) then the distributions
will catch up, turn it on and sort out the default behaviour - exactly as
they did all those years ago with modules, more recently with "use an
initrd" and so on.

> as "making no sense".  All these are real world examples where users 
> FOLLOWING THEIR NORMAL, PROSCRIBED KERNEL PROCESSES will produce 

I hope you mean "prescribed" ;)

> The only valid assumption here is to assume that the user is /unaware/ 
> of these new steps they must take in order to continue to have a working 
> system.

To a large extent not the user but their distro - consider "make install"
