Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbYJHKg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbYJHKg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 06:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYJHKgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 06:36:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52725 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753161AbYJHKgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:36:48 -0400
Date: Wed, 8 Oct 2008 11:27:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Li Yang <leoli@freescale.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Tejun Heo <tj@kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>, Wang Jian <lark@linux.net.cn>
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
Message-ID: <20081008112743.6a90baf7@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0810081159240.24611@vixen.sonytel.be>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	<48EA77EF.6080502@genesi-usa.com>
	<20081006213209.GA13072@oksana.dev.rtsoft.ru>
	<48EABBD3.1010401@kernel.org>
	<20081007103723.0224671e@lxorguk.ukuu.org.uk>
	<1223455254.3145.143.camel@macbook.infradead.org>
	<20081008100025.1c535401@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0810081159240.24611@vixen.sonytel.be>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'll leave you to argue with Linus about that, but since that was the
> > decision back in 2005 (for good C reasons) we can safely rely on it.
> 
> `git grep NO_IRQ include arch/*/include' is still quite enlightening...

Good guide to platform code we should delete really
