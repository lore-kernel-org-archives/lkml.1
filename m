Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYGDVYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYGDVYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbYGDVYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:24:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44005 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755949AbYGDVYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:24:08 -0400
Date: Fri, 4 Jul 2008 22:04:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, dwmw2@infradead.org, andi@firstfloor.org, tytso@mit.edu,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080704220444.011e7e61@lxorguk.ukuu.org.uk>
In-Reply-To: <20080704.134329.209642254.davem@davemloft.net>
References: <1215178035.10393.763.camel@pmac.infradead.org>
	<486E2818.1060003@garzik.org>
	<20080704142753.27848ff8@lxorguk.ukuu.org.uk>
	<20080704.134329.209642254.davem@davemloft.net>
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

> External firmware is by design an error prone system, even with
> versioning.  But by being built and linked into the driver, it
> is fool proof.
> 
> On a technical basis alone, we would never disconnect a crucial
> component such as firmware, from the driver.  The only thing
> charging these transoformations, from day one, is legal concerns.

As I said: We had this argument ten years ago (more than that now
actually). People said the same thing about modules.

Alan
