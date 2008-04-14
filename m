Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYDNLj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYDNLj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYDNLjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:39:51 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:63965
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbYDNLju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:39:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUBAPfeAkjLrQz2/2dsb2JhbAAIqU4
X-IronPort-AV: E=Sophos;i="4.25,655,1199631600"; 
   d="scan'208";a="315627462"
Subject: Re: UIO: Implement a UIO interface for the SMX Cryptengine
From: Ben Nizette <bn@niasdigital.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080414100848.GA19369@digi.com>
References: <20080414100848.GA19369@digi.com>
Content-Type: text/plain; charset=UTF-8
Organization: Nias Digital
Date: Mon, 14 Apr 2008 21:39:41 +1000
Message-Id: <1208173181.3351.63.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[putting lkml back in CC]

On Mon, 2008-04-14 at 12:08 +0200, Uwe Kleine-König wrote:

> The line "depends on UIO" isn't needed (anymore) because the whole
> config item is located in a "if UIO"/"endif".

Right, just saw your patch fly by.  Given mine's been taken up by gregkh
already I was kinda hoping someone further up the tree would end up
fixing it.  If not I can of course rebase and resend.

> 
> The "default n" isn't necessary because that's the default anyhow.

Eh, I like to be explicit.

> 
> I didn't look deeper into that patch, but it might be possible to
share
> code with my patch

Indeed, I quite like your patch.  I spend a fair bit of time on the
AVRFreaks AVR32 support community and I can see a great need for what
you've done.  That said, if HJK/ GregKH don't object I think I'll leave
mine pretty much as-is; having a device-specific ISR in platform code
just doesn't quite sit smooth with me :-)

Thanks!
	--Ben.
