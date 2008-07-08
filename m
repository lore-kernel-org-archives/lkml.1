Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbYGHHMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbYGHHMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYGHHMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:12:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49023 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752015AbYGHHMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:12:01 -0400
Date: Tue, 8 Jul 2008 07:39:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: mchan@broadcom.com, dwmw2@infradead.org, bastian@waldi.eu.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
Message-ID: <20080708073922.6c2470c1@the-village.bc.nu>
In-Reply-To: <20080707.150549.242704515.davem@davemloft.net>
References: <1215456981.5532.20.camel@dell>
	<20080707.143803.99767036.davem@davemloft.net>
	<20080707221950.3dfba435@the-village.bc.nu>
	<20080707.150549.242704515.davem@davemloft.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The firmware needs to be reloaded every time the chip resets.
> You're not saving anything/

> See above, you aren't saving anything.  The firmware needs to stay
> around so it can be reloaded into the card during exceptions.
> 
> That is, unless you want a more failure prone system.

Ok so if tg3 always needs the same firmware and always needs it in memory
then maybe it isn't a significant candidate for request_firmware beyond
the neatness of distribution. I note the firmware hasn't changed in years
so it can easily be shipped separately and the one package would have
done for all this time.

> > Driver authors aren't God.
> 
> They (actually, more specifically the maintainers) to a certain extent
> are, because they are the ones who eat doo-doo when something explodes.

So do the distributions and the users.

Alan
